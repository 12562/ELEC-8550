
module and3 (y, a, b, c);
       input a, b, c;
       output y;
       assign y = a & b & c;
endmodule

module and4 (y, a, b, c, d);
       input a, b, c, d;
       output y;
       assign y = a & b & c & d;
endmodule

module or3 (y, a, b, c);
       input a, b, c;
       output y;
       assign y = a | b | c;
endmodule

module or4 (y, a, b, c, d);
       input a, b, c, d;      
       output y ;
       assign y = a | b | c | d;
endmodule
       
module cg_and_cp (g, p, s, x, y, c);
       input x, y, c;
       output g, p, s;
       and (g, x, y);
       xor (p, x, y);
       xor (s, p, c);
endmodule

module four_bit_lookahead_carry_generator (c_out, p_block, g_block, p, g, c_in);
       input [3:0] p;
       input [3:0] g;
       input c_in;
       output [2:0] c_out;
       output p_block;
       output g_block;
       wire [8:0] p_g_and_c;
       
       and (p_g_and_c[0], c_in, p[0]);
       or  (c_out[0], p_g_and_c[0], g[0]);
        
       and (p_g_and_c[1], p[1], g[0]);
       and3 and3_inst1 (p_g_and_c[2], p[1], p[0], c_in);
       or3  or3_inst1 (c_out[1], p_g_and_c[1], p_g_and_c[2], g[1]);

       and (p_g_and_c[3], p[2], g[1]);
       and3 and3_inst2 (p_g_and_c[4], p[2], p[1], g[0]);
       and4 and4_inst1 (p_g_and_c[5], p[2], p[1], p[0], c_in);
       or4 or4_inst1 (c_out[2], p_g_and_c[3], p_g_and_c[4], p_g_and_c[5], g[2]);
 
       and (p_g_and_c[6], p[3], g[2]);
       and3 and3_inst3 (p_g_and_c[7], p[3], p[2], g[1]);
       and4 and4_inst2 (p_g_and_c[8], p[3], p[2], p[1], g[0]);
       or4 or4_inst2 (g_block, p_g_and_c[6], p_g_and_c[7], p_g_and_c[8], g[3]);

       and4 and4_inst3 (p_block, p[3], p[2], p[1], p[0]);    
endmodule

module four_bit_CLA_adder (G, P, S, X, Y, C_in);
       output G, P;
       output [3:0] S;
       input  [3:0] X;
       input  [3:0] Y;
       input C_in;
       wire [3:0] g;
       wire [3:0] p;
       wire [3:1] c;
              
       cg_and_cp inst1 (g[0], p[0], S[0], X[0], Y[0], C_in);
       cg_and_cp inst2 (g[1], p[1], S[1], X[1], Y[1], c[1]);
       cg_and_cp inst3 (g[2], p[2], S[2], X[2], Y[2], c[2]);
       cg_and_cp inst4 (g[3], p[3], S[3], X[3], Y[3], c[3]);
       four_bit_lookahead_carry_generator carry_generator_4 (c, P, G, p, g, C_in);
endmodule

module tb_4_bit_CLA_adder ();
       wire [15:0] S;
       wire G, P;
       wire [68:0] sum;
       reg  [15:0] X, Y;
       reg  C_in;
       reg [67:0] A, B;

       sixteen_bit_CLA_adder dut (G, P, S, X, Y, C_in);
       sixty_eight_bit_CLA_adder dut1 (sum, A, B); 
     initial
       begin 
         //$monitor("G = %b  P = %b  S = %16b  X = %16b  Y = %16b  C_in = %b" ,G, P, S, X, Y, C_in);
         $monitor("sum = %d  B = %d  A = %d" , sum, A, B);
         #5 assign A = 65535;assign B = 65535; assign C_in = 1'b0; 
         #5 assign A = 65535;assign B = 0; assign C_in = 1'b1; 
         #5 assign A = 0;assign B = 65535; assign C_in = 1'b1; 
         #5 assign A = 1065535;assign B = 1; assign C_in = 1'b0; 
       end
endmodule

module sixteen_bit_CLA_adder (G, P, S, X, Y, C_0);
       output G, P;
       output [15:0] S;
       input  [15:0] X, Y;
       input C_0;
       wire [3:0] g, p;
       wire [2:0] c;

       four_bit_CLA_adder inst0 (g[0], p[0], S[3:0],   X[3:0],   Y[3:0],   C_0);
       four_bit_CLA_adder inst1 (g[1], p[1], S[7:4],   X[7:4],   Y[7:4],   c[0]);
       four_bit_CLA_adder inst2 (g[2], p[2], S[11:8],  X[11:8],  Y[11:8],  c[1]);
       four_bit_CLA_adder inst3 (g[3], p[3], S[15:12], X[15:12], Y[15:12], c[2]);
       four_bit_lookahead_carry_generator carry_generator_16 (c, P, G, p, g, C_0);
endmodule

module sixty_four_bit_CLA_adder (G, P, S, X, Y, C_0);
       output G, P;
       output [63:0] S;
       input  [63:0] X, Y;
       input C_0;
       wire [3:0] g, p;
       wire [2:0] c;

       sixteen_bit_CLA_adder inst0 (g[0], p[0], S[15:0],   X[15:0],   Y[15:0],   C_0);
       sixteen_bit_CLA_adder inst1 (g[1], p[1], S[31:16],   X[31:16],   Y[31:16],   c[0]);
       sixteen_bit_CLA_adder inst2 (g[2], p[2], S[47:32],  X[47:32],  Y[47:32],  c[1]);
       sixteen_bit_CLA_adder inst3 (g[3], p[3], S[63:48], X[63:48], Y[63:48], c[2]);
       four_bit_lookahead_carry_generator carry_generator_16 (c, P, G, p, g, C_0);
endmodule

module two_bit_lookahead_carry_generator (C, P, G, C_0);
       input [1:0] P, G; 
       output [1:0] C;
       input C_0;
       wire [2:0] g_p_and_c;
       
       and (g_p_and_c[0], P[0], C_0);
       or (C[0], g_p_and_c[0], G[0]);
        
       and (g_p_and_c[1], P[1], G[0]);
       and3 inst0 (g_p_and_c[2], P[1], P[0], C_0);
       or3 inst1 (C[1], g_p_and_c[1], g_p_and_c[2], G[1]);
endmodule

module sixty_eight_bit_CLA_adder (sum, X, Y); 
       input [67:0] X, Y;
       output [68:0] sum;
       wire C_64; 
       wire [1:0] G, P;
       sixty_four_bit_CLA_adder inst0 (G[0], P[0], sum[63:0], X[63:0], Y[63:0], 1'b0);
       four_bit_CLA_adder inst1 (G[1], P[1], sum[67:64], X[67:64], Y[67:64], C_64);
       two_bit_lookahead_carry_generator carry_generator_68 ({sum[68], C_64}, P, G, 1'b0);
endmodule
