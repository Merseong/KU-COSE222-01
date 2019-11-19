`timescale 1ns/1ps
`define mydelay 1

//--------------------------------------------------------------
// mips.v
// David_Harris@hmc.edu and Sarah_Harris@hmc.edu 23 October 2005
// Single-cycle MIPS processor
//--------------------------------------------------------------

// single-cycle MIPS processor
module mips(input         clk, reset,
            output [31:0] pc,
            input  [31:0] instr,
            output        memwrite,
            output [31:0] memaddr,
            output [31:0] memwritedata,
            input  [31:0] memreaddata);

  wire        signext, shiftl16, memtoreg, branch;
  wire        pcsrc, zero;
  wire [1:0]  alusrc;
  wire [1:0]  regdst; 
  wire		  regwrite;
  wire [1:0]  jump;
  wire [3:0]  alucontrol;

  // Instantiate Controller
  controller c(
    .op         (instr[31:26]), 
		.funct      (instr[5:0]), 
		.zero       (zero),
		.signext    (signext),
		.shiftl16   (shiftl16),
		.memtoreg   (memtoreg),
		.memwrite   (memwrite),
		.pcsrc      (pcsrc),
		.alusrc     (alusrc),
		.regdst     (regdst),
		.regwrite   (regwrite),
		.jump       (jump),
		.alucontrol (alucontrol));

  // Instantiate Datapath
  datapath dp(
    .clk        (clk),
    .reset      (reset),
    .signext    (signext),
    .shiftl16   (shiftl16),
    .memtoreg   (memtoreg),
    .pcsrc      (pcsrc),
    .alusrc     (alusrc),
    .regdst     (regdst),
    .regwrite   (regwrite),
    .jump       (jump),
    .alucontrol (alucontrol),
    .zero       (zero),
    .pc         (pc),
    .instr      (instr),
    .aluout     (memaddr), 
    .writedata  (memwritedata),
    .readdata   (memreaddata));

endmodule

module controller(input  [5:0] op, funct,
                  input        zero,
                  output       signext,
                  output       shiftl16,
                  output       memtoreg, memwrite,
                  output       pcsrc, 
                  output [1:0] alusrc,
                  output [1:0] regdst, 
                  output       regwrite,
                  output [1:0] jump,
                  output [3:0] alucontrol);

  wire [1:0] aluop;
  wire [1:0] jumptemp;
  wire [1:0] branch;

  maindec md(
    .op       (op),
    .signext  (signext),
    .shiftl16 (shiftl16),
    .memtoreg (memtoreg),
    .memwrite (memwrite),
    .branch   (branch),
    .alusrc   (alusrc),
    .regdst   (regdst),
    .regwrite (regwrite),
    .jump     (jumptemp),
    .aluop    (aluop));

  aludec ad( 
    .funct      (funct),
    .aluop      (aluop),
	 .jumptemp   (jumptemp),
	 .jump       (jump),
    .alucontrol (alucontrol));

  assign pcsrc = branch[0] & zero | branch[1] & !zero; // be careful for branch is 2'b11

endmodule


module maindec(input  [5:0] op,
               output       signext,
               output       shiftl16,
               output       memtoreg, memwrite,
               output [1:0] branch, 
               output [1:0] alusrc,
               output [1:0] regdst, 
               output       regwrite,
               output [1:0] jump,
               output [1:0] aluop);

  reg [14:0] controls;

  assign {signext, shiftl16, regwrite, regdst, alusrc, branch, memwrite,
          memtoreg, jump, aluop} = controls;

  always @(*)
    case(op)
      6'b000000: controls <= #`mydelay 15'b0_0_1_01_00_00_0_0_00_11; // Rtype
      6'b100011: controls <= #`mydelay 15'b1_0_1_00_01_00_0_1_00_00; // LW
      6'b101011: controls <= #`mydelay 15'b1_0_0_00_01_00_1_0_00_00; // SW
      6'b000100: controls <= #`mydelay 15'b1_0_0_00_00_01_0_0_00_01; // BEQ
		6'b000101: controls <= #`mydelay 15'b1_0_0_00_00_10_0_0_00_01; // BNE
      6'b001000, 
      6'b001001: controls <= #`mydelay 15'b1_0_1_00_01_00_0_0_00_00; // ADDI, ADDIU: only difference is exception
      6'b001101: controls <= #`mydelay 15'b0_0_1_00_01_00_0_0_00_10; // ORI
      6'b001111: controls <= #`mydelay 15'b0_1_1_00_01_00_0_0_00_00; // LUI
      6'b000010: controls <= #`mydelay 15'b0_0_0_00_00_00_0_0_01_00; // J
      6'b000011: controls <= #`mydelay 15'b0_0_1_10_10_00_0_0_01_10; // JAL
      default:   controls <= #`mydelay 15'bxxxxxxxxxxxxxxx; // ???
    endcase

endmodule

module aludec(input      [5:0] funct,
              input      [1:0] aluop,
				  input      [1:0] jumptemp,
				  output     [1:0] jump,
              output reg [3:0] alucontrol);
				  
  reg [5:0] controls;
  wire [3:0] alucontroltemp;

  assign {alucontroltemp, jump} = controls;

  always @(*)
  begin
	 case(aluop)
		2'b00: controls <= #`mydelay {4'b0010, jumptemp[1:0]};  // add
		2'b01: controls <= #`mydelay {4'b1010, jumptemp[1:0]};  // sub
		2'b10: controls <= #`mydelay {4'b0001, jumptemp[1:0]};  // or
		default: case(funct)          // RTYPE
			 6'b000000: controls <= #`mydelay {4'b0001, jumptemp[1:0]}; // NOP
			 6'b001000: controls <= #`mydelay 6'b0001_10; // JR
			 6'b100000,
			 6'b100001: controls <= #`mydelay {4'b0010, jumptemp[1:0]}; // ADD, ADDU: only difference is exception
			 6'b100010,
			 6'b100011: controls <= #`mydelay {4'b1010, jumptemp[1:0]}; // SUB, SUBU: only difference is exception
			 6'b100100: controls <= #`mydelay {4'b0000, jumptemp[1:0]}; // AND
			 6'b100101: controls <= #`mydelay {4'b0001, jumptemp[1:0]}; // OR
			 6'b101010: controls <= #`mydelay {4'b1011, jumptemp[1:0]}; // SLT
			 6'b101011: controls <= #`mydelay {4'b1100, jumptemp[1:0]}; // SLTU
			 default:   controls <= #`mydelay {4'bxxxx, jumptemp[1:0]}; // ???
		endcase
	 endcase
	 alucontrol <= #`mydelay alucontroltemp[3:0];
  end

endmodule

module datapath(input         clk, reset,
                input         signext,
                input         shiftl16,
                input         memtoreg, pcsrc,
                input  [1:0]  alusrc, regdst,
                input         regwrite, 
					 input  [1:0]  jump,
                input  [3:0]  alucontrol,
                output        zero,
                output [31:0] pc,
                input  [31:0] instr,
                output [31:0] aluout, writedata,
                input  [31:0] readdata);
					 
  assign writedata = writedata_mem;
  assign zero = zero_mem;
  assign aluout = aluout_mem;

  wire [4:0]  writereg;
  wire [31:0] pcnext, pcnextbr, pcbranch;
  wire [31:0] signimmsh, shiftedimm;
  wire [31:0] srca, srcb;
  wire [31:0] result;
  wire        shift;
  wire [4:0]  ra1;
  
  wire [31:0] pcplus4_if;
//wire [31:0] instr_if == instr;
  
  wire [31:0] pcplus4_id;
  wire [31:0] instr_id;
  wire [31:0] writedata_id;
  wire [31:0] srca_id;
  wire [31:0] signimm_id;
  
  wire [31:0] pcplus4_ex;
  wire [31:0] srca_ex;
  wire [31:0] writedata_ex;
  wire [31:0] signimm_ex;
  wire [31:0] pcbranch_ex;
  wire        zero_ex;
  wire [31:0] aluout_ex;
  
  wire [31:0] pcbranch_mem;
  wire        zero_mem;
  wire [31:0] aluout_mem;
  wire [31:0] writedata_mem;
  wire [31:0] memreaddata_mem;
  
  wire [31:0] memreaddata_wb;
  wire [31:0] aluout_wb;
  
  // for pipeline
  flopenr #(64) if_id(
    .clk   (clk),
	 .reset (reset),
	 .en    (1'b1),
	 .d     ({pcplus4_if, instr}),
	 .q     ({pcplus4_id, instr_id}));
	 
  flopenr #(128) id_ex(
    .clk   (clk),
	 .reset (reset),
	 .en    (1'b1),
	 .d     ({pcplus4_id, srca_id, writedata_id, signimm_id}),
	 .q     ({pcplus4_ex, srca_ex, writedata_ex, signimm_ex}));
	 
  flopenr #(97) ex_mem(
    .clk   (clk),
	 .reset (reset),
	 .en    (1'b1),
	 .d     ({pcbranch_ex, zero_ex, aluout_ex, writedata_ex}),
	 .q     ({pcbranch_mem, zero_mem, aluout_mem, writedata_mem}));
	 
  flopenr #(64) mem_wb(
    .clk   (clk),
	 .reset (reset),
	 .en    (1'b1),
	 .d     ({memreaddata_mem, aluout_mem}),
	 .q     ({memreaddata_wb, aluout_wb}));

  // next PC logic
  flopr #(32) pcreg(
    .clk   (clk),
    .reset (reset),
    .d     (pcnext),
    .q     (pc));

  adder pcadd1(
    .a (pc),
    .b (32'b100),
    .y (pcplus4_if));

  sl2 immsh(
    .a (signimm_ex),
    .y (signimmsh));
				 
  adder pcadd2(
    .a (pcplus4_ex),
    .b (signimmsh),
    .y (pcbranch_ex));

  mux2 #(32) pcbrmux(
    .d0  (pcplus4_if),
    .d1  (pcbranch_ex),
    .s   (pcsrc),
    .y   (pcnextbr));

  mux4 #(32) pcmux(
    .d0   (pcnextbr),
    .d1   ({pcplus4_ex[31:28], instr_id[25:0], 2'b00}),
	 .d2   (aluout_mem),
	 .d3   (32'b0),
    .s    (jump),
    .y    (pcnext));

  // register file logic
  regfile rf(
    .clk     (clk),
    .we      (regwrite),
    .ra1     (ra1),
    .ra2     (instr_id[20:16]),
    .wa      (writereg),
    .wd      (result),
    .rd1     (srca_id),
    .rd2     (writedata_id));
	
  mux2 #(5) zeromux(
    .d0	(instr_id[25:21]),
    .d1	(5'b00000),
    .s	(alusrc[1]),
    .y	(ra1));

  mux4 #(5) wrmux(
    .d0  (instr_id[20:16]),
    .d1  (instr_id[15:11]),
    .d2  (5'b11111), // $31
    .d3  (5'b00001),
    .s   (regdst),
    .y   (writereg));

  mux2 #(32) resmux(
    .d0 (aluout_wb),
    .d1 (readdata_wb),
    .s  (memtoreg),
    .y  (result));

  sign_zero_ext sze(
    .a       (instr_id[15:0]),
    .signext (signext),
    .y       (signimm_id[31:0]));

  shift_left_16 sl16(
    .a         (signimm_ex[31:0]),
    .shiftl16  (shiftl16),
    .y         (shiftedimm[31:0]));

  // ALU logic
  mux4 #(32) srcbmux(
    .d0 (writedata_ex),
    .d1 (shiftedimm[31:0]),
    .d2 (pcplus4_ex),
    .d3 (32'b0),
    .s  (alusrc),
    .y  (srcb));

  alu alu(
    .a       (srca_ex),
    .b       (srcb),
    .alucont (alucontrol),
    .result  (aluout_ex),
    .zero    (zero_ex));
    
endmodule
