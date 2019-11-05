`timescale 1ns/1ps
`define mydelay 1

//------------------------------------------------
// mipsparts.v
// David_Harris@hmc.edu 23 October 2005
// Components used in MIPS processor
//------------------------------------------------

`define REGFILE_FF
`ifdef REGFILE_FF

module regfile(input             clk, 
               input             we, 
               input      [4:0]  ra1, ra2, wa, 
               input      [31:0] wd, 
               output reg [31:0] rd1, rd2);

	reg [31:0] R1;
	reg [31:0] R2;
	reg [31:0] R3;
	reg [31:0] R4;
	reg [31:0] R5;
	reg [31:0] R6;
	reg [31:0] R7;
	reg [31:0] R8;
	reg [31:0] R9;
	reg [31:0] R10;
	reg [31:0] R11;
	reg [31:0] R12;
	reg [31:0] R13;
	reg [31:0] R14;
	reg [31:0] R15;
	reg [31:0] R16;
	reg [31:0] R17;
	reg [31:0] R18;
	reg [31:0] R19;
	reg [31:0] R20;
	reg [31:0] R21;
	reg [31:0] R22;
	reg [31:0] R23;
	reg [31:0] R24;
	reg [31:0] R25;
	reg [31:0] R26;
	reg [31:0] R27;
	reg [31:0] R28;
	reg [31:0] R29;
	reg [31:0] R30;
	reg [31:0] R31;

	always @(posedge clk)
	begin
  	 if (we) 
	 begin
   		case (wa[4:0])
   		5'd0:   ;
   		5'd1:   R1  <= wd;
   		5'd2:   R2  <= wd;
   		5'd3:   R3  <= wd;
   		5'd4:   R4  <= wd;
   		5'd5:   R5  <= wd;
   		5'd6:   R6  <= wd;
   		5'd7:   R7  <= wd;
   		5'd8:   R8  <= wd;
   		5'd9:   R9  <= wd;
   		5'd10:  R10 <= wd;
   		5'd11:  R11 <= wd;
   		5'd12:  R12 <= wd;
   		5'd13:  R13 <= wd;
   		5'd14:  R14 <= wd;
   		5'd15:  R15 <= wd;
   		5'd16:  R16 <= wd;
   		5'd17:  R17 <= wd;
   		5'd18:  R18 <= wd;
   		5'd19:  R19 <= wd;
   		5'd20:  R20 <= wd;
   		5'd21:  R21 <= wd;
   		5'd22:  R22 <= wd;
   		5'd23:  R23 <= wd;
   		5'd24:  R24 <= wd;
   		5'd25:  R25 <= wd;
   		5'd26:  R26 <= wd;
   		5'd27:  R27 <= wd;
   		5'd28:  R28 <= wd;
   		5'd29:  R29 <= wd;
   		5'd30:  R30 <= wd;
   		5'd31:  R31 <= wd;
   		endcase
     end
	end

	always @(*)
	begin
		case (ra2[4:0])
		5'd0:   rd2 = 32'b0;
		5'd1:   rd2 = R1;
		5'd2:   rd2 = R2;
		5'd3:   rd2 = R3;
		5'd4:   rd2 = R4;
		5'd5:   rd2 = R5;
		5'd6:   rd2 = R6;
		5'd7:   rd2 = R7;
		5'd8:   rd2 = R8;
		5'd9:   rd2 = R9;
		5'd10:  rd2 = R10;
		5'd11:  rd2 = R11;
		5'd12:  rd2 = R12;
		5'd13:  rd2 = R13;
		5'd14:  rd2 = R14;
		5'd15:  rd2 = R15;
		5'd16:  rd2 = R16;
		5'd17:  rd2 = R17;
		5'd18:  rd2 = R18;
		5'd19:  rd2 = R19;
		5'd20:  rd2 = R20;
		5'd21:  rd2 = R21;
		5'd22:  rd2 = R22;
		5'd23:  rd2 = R23;
		5'd24:  rd2 = R24;
		5'd25:  rd2 = R25;
		5'd26:  rd2 = R26;
		5'd27:  rd2 = R27;
		5'd28:  rd2 = R28;
		5'd29:  rd2 = R29;
		5'd30:  rd2 = R30;
		5'd31:  rd2 = R31;
		endcase
	end

	always @(*)
	begin
		case (ra1[4:0])
		5'd0:   rd1 = 32'b0;
		5'd1:   rd1 = R1;
		5'd2:   rd1 = R2;
		5'd3:   rd1 = R3;
		5'd4:   rd1 = R4;
		5'd5:   rd1 = R5;
		5'd6:   rd1 = R6;
		5'd7:   rd1 = R7;
		5'd8:   rd1 = R8;
		5'd9:   rd1 = R9;
		5'd10:  rd1 = R10;
		5'd11:  rd1 = R11;
		5'd12:  rd1 = R12;
		5'd13:  rd1 = R13;
		5'd14:  rd1 = R14;
		5'd15:  rd1 = R15;
		5'd16:  rd1 = R16;
		5'd17:  rd1 = R17;
		5'd18:  rd1 = R18;
		5'd19:  rd1 = R19;
		5'd20:  rd1 = R20;
		5'd21:  rd1 = R21;
		5'd22:  rd1 = R22;
		5'd23:  rd1 = R23;
		5'd24:  rd1 = R24;
		5'd25:  rd1 = R25;
		5'd26:  rd1 = R26;
		5'd27:  rd1 = R27;
		5'd28:  rd1 = R28;
		5'd29:  rd1 = R29;
		5'd30:  rd1 = R30;
		5'd31:  rd1 = R31;
		endcase
	end

endmodule

`else

module regfile(input         clk, 
               input         we, 
               input  [4:0]  ra1, ra2, wa, 
               input  [31:0] wd, 
               output [31:0] rd1, rd2);

  reg [31:0] rf[31:0];

  // three ported register file
  // read two ports combinationally
  // write third port on rising edge of clock
  // register 0 hardwired to 0

  always @(posedge clk)
    if (we) rf[wa] <= #`mydelay wd;	

  assign #`mydelay rd1 = (ra1 != 0) ? rf[ra1] : 0;
  assign #`mydelay rd2 = (ra2 != 0) ? rf[ra2] : 0;
endmodule

`endif


module alu(input      [31:0] a, b, 
           input      [2:0]  alucont, 
           output reg [31:0] result,
           output            zero);

  wire [31:0] b2, sum, slt, sltu;
  wire        N, Z, C, V;

  assign b2 = alucont[2] ? ~b:b; 

  adder_32bit iadder32 (.a   (a),
			     				.b   (b2),
								.cin (alucont[2]),
								.sum (sum),
								.N   (N),
								.Z   (Z),
								.C   (C),
								.V   (V));

  // signed less than ("N set and V clear" OR "N clear and V set")
  assign slt  = N ^ V ; 

  // unsigned lower (C clear) 
  assign sltu = ~C ;   

  always@(*)
    case(alucont[1:0])
      2'b00: result <= #`mydelay a & b;
      2'b01: result <= #`mydelay a | b;
      2'b10: result <= #`mydelay sum;
      2'b11: result <= #`mydelay slt;
    endcase

  assign #`mydelay zero = (result == 32'b0);

endmodule


module adder_32bit (input  [31:0] a, b, 
                    input         cin,
                    output [31:0] sum,
                    output        N,Z,C,V);

	wire [31:0]  ctmp;

	assign N = sum[31];
	assign Z = (sum == 32'b0);
	assign C = ctmp[31];
	assign V = ctmp[31] ^ ctmp[30];

	adder_1bit bit31 (.a(a[31]), .b(b[31]), .cin(ctmp[30]), .sum(sum[31]), .cout(ctmp[31]));
	adder_1bit bit30 (.a(a[30]), .b(b[30]), .cin(ctmp[29]), .sum(sum[30]), .cout(ctmp[30]));
	adder_1bit bit29 (.a(a[29]), .b(b[29]), .cin(ctmp[28]), .sum(sum[29]), .cout(ctmp[29]));
	adder_1bit bit28 (.a(a[28]), .b(b[28]), .cin(ctmp[27]), .sum(sum[28]), .cout(ctmp[28]));
	adder_1bit bit27 (.a(a[27]), .b(b[27]), .cin(ctmp[26]), .sum(sum[27]), .cout(ctmp[27]));
	adder_1bit bit26 (.a(a[26]), .b(b[26]), .cin(ctmp[25]), .sum(sum[26]), .cout(ctmp[26]));
	adder_1bit bit25 (.a(a[25]), .b(b[25]), .cin(ctmp[24]), .sum(sum[25]), .cout(ctmp[25]));
	adder_1bit bit24 (.a(a[24]), .b(b[24]), .cin(ctmp[23]), .sum(sum[24]), .cout(ctmp[24]));
	adder_1bit bit23 (.a(a[23]), .b(b[23]), .cin(ctmp[22]), .sum(sum[23]), .cout(ctmp[23]));
	adder_1bit bit22 (.a(a[22]), .b(b[22]), .cin(ctmp[21]), .sum(sum[22]), .cout(ctmp[22]));
	adder_1bit bit21 (.a(a[21]), .b(b[21]), .cin(ctmp[20]), .sum(sum[21]), .cout(ctmp[21]));
	adder_1bit bit20 (.a(a[20]), .b(b[20]), .cin(ctmp[19]), .sum(sum[20]), .cout(ctmp[20]));
	adder_1bit bit19 (.a(a[19]), .b(b[19]), .cin(ctmp[18]), .sum(sum[19]), .cout(ctmp[19]));
	adder_1bit bit18 (.a(a[18]), .b(b[18]), .cin(ctmp[17]), .sum(sum[18]), .cout(ctmp[18]));
	adder_1bit bit17 (.a(a[17]), .b(b[17]), .cin(ctmp[16]), .sum(sum[17]), .cout(ctmp[17]));
	adder_1bit bit16 (.a(a[16]), .b(b[16]), .cin(ctmp[15]), .sum(sum[16]), .cout(ctmp[16]));
	adder_1bit bit15 (.a(a[15]), .b(b[15]), .cin(ctmp[14]), .sum(sum[15]), .cout(ctmp[15]));
	adder_1bit bit14 (.a(a[14]), .b(b[14]), .cin(ctmp[13]), .sum(sum[14]), .cout(ctmp[14]));
	adder_1bit bit13 (.a(a[13]), .b(b[13]), .cin(ctmp[12]), .sum(sum[13]), .cout(ctmp[13]));
	adder_1bit bit12 (.a(a[12]), .b(b[12]), .cin(ctmp[11]), .sum(sum[12]), .cout(ctmp[12]));
	adder_1bit bit11 (.a(a[11]), .b(b[11]), .cin(ctmp[10]), .sum(sum[11]), .cout(ctmp[11]));
	adder_1bit bit10 (.a(a[10]), .b(b[10]), .cin(ctmp[9]),  .sum(sum[10]), .cout(ctmp[10]));
	adder_1bit bit9  (.a(a[9]),  .b(b[9]),  .cin(ctmp[8]),  .sum(sum[9]),  .cout(ctmp[9]));
	adder_1bit bit8  (.a(a[8]),  .b(b[8]),  .cin(ctmp[7]),  .sum(sum[8]),  .cout(ctmp[8]));
	adder_1bit bit7  (.a(a[7]),  .b(b[7]),  .cin(ctmp[6]),  .sum(sum[7]),  .cout(ctmp[7]));
	adder_1bit bit6  (.a(a[6]),  .b(b[6]),  .cin(ctmp[5]),  .sum(sum[6]),  .cout(ctmp[6]));
	adder_1bit bit5  (.a(a[5]),  .b(b[5]),  .cin(ctmp[4]),  .sum(sum[5]),  .cout(ctmp[5]));
	adder_1bit bit4  (.a(a[4]),  .b(b[4]),  .cin(ctmp[3]),  .sum(sum[4]),  .cout(ctmp[4]));
	adder_1bit bit3  (.a(a[3]),  .b(b[3]),  .cin(ctmp[2]),  .sum(sum[3]),  .cout(ctmp[3]));
	adder_1bit bit2  (.a(a[2]),  .b(b[2]),  .cin(ctmp[1]),  .sum(sum[2]),  .cout(ctmp[2]));
	adder_1bit bit1  (.a(a[1]),  .b(b[1]),  .cin(ctmp[0]),  .sum(sum[1]),  .cout(ctmp[1]));
	adder_1bit bit0  (.a(a[0]),  .b(b[0]),  .cin(cin),      .sum(sum[0]),  .cout(ctmp[0]));

endmodule


module adder_1bit (input a, b, cin,
                   output sum, cout);

  assign sum  = a ^ b ^ cin;
  assign cout = (a & b) | (a & cin) | (b & cin);

endmodule


module adder(input [31:0] a, b,
             output [31:0] y);

  assign #`mydelay y = a + b;
endmodule



module sl2(input  [31:0] a,
           output [31:0] y);

  // shift left by 2
  assign #`mydelay y = {a[29:0], 2'b00};
endmodule



module sign_zero_ext(input      [15:0] a,
                     input             signext,
                     output reg [31:0] y);
              
   always @(*)
	begin
	   if (signext)  y <= {{16{a[15]}}, a[15:0]};
	   else          y <= {16'b0, a[15:0]};
	end

endmodule



module shift_left_16(input      [31:0] a,
		               input         shiftl16,
                     output reg [31:0] y);

   always @(*)
	begin
	   if (shiftl16) y = {a[15:0],16'b0};
	   else          y = a[31:0];
	end
              
endmodule



module flopr #(parameter WIDTH = 8)
              (input                  clk, reset,
               input      [WIDTH-1:0] d, 
               output reg [WIDTH-1:0] q);

  always @(posedge clk, posedge reset)
    if (reset) q <= #`mydelay 0;
    else       q <= #`mydelay d;

endmodule



module flopenr #(parameter WIDTH = 8)
                (input                  clk, reset,
                 input                  en,
                 input      [WIDTH-1:0] d, 
                 output reg [WIDTH-1:0] q);
 
  always @(posedge clk, posedge reset)
    if      (reset) q <= #`mydelay 0;
    else if (en)    q <= #`mydelay d;

endmodule



module mux2 #(parameter WIDTH = 8)
             (input  [WIDTH-1:0] d0, d1, 
              input              s, 
              output [WIDTH-1:0] y);

  assign #`mydelay y = s ? d1 : d0; 

endmodule
