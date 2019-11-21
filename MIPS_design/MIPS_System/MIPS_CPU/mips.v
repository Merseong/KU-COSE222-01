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

  wire        signext, shiftl16;
  wire [1:0]  branch;
  wire        pcsrc, zero;
  wire [1:0]  jump;
  wire [3:0]  alucontrol;
  wire        id_control;
  wire [6:0]  ex_control;
  wire [2:0]  mem_control;
  wire [1:0]  wb_control;
  wire [5:0]  op_id;
  wire [5:0]  funct_ex;
  wire [1:0]  aluop_ex;

  // Instantiate Controller
  controller c(
    .op_id         (op_id),
    .funct_ex      (funct_ex), 
    .aluop_ex      (aluop_ex),
    .jump          (jump),
    .id_control    (id_control),
    .ex_control    (ex_control),
    .mem_control   (mem_control),
    .wb_control    (wb_control),
    .alucontrol    (alucontrol));

  // Instantiate Datapath
  datapath dp(
    .clk              (clk),
    .reset            (reset),
    .jump             (jump),
    .id_control_idin  (id_control),
    .ex_control_idin  (ex_control),
    .mem_control_idin (mem_control),
    .wb_control_idin  (wb_control),
    .alucontrol_exin  (alucontrol),
    .instr_ifin       (instr),
    .op_idout         (op_id),
    .funct_exout      (funct_ex),
    .aluop_exout      (aluop_ex),
    .pc               (pc),
    .aluout           (memaddr), 
    .writedata        (memwritedata),
    .memwrite         (memwrite),
    .readdata         (memreaddata));

endmodule

module controller(input  [5:0] op_id, funct_ex,
                  input  [1:0] aluop_ex,
                  output [1:0] jump,
                  output       id_control,
                  output [6:0] ex_control,
                  output [2:0] mem_control,
                  output [1:0] wb_control,
                  output [3:0] alucontrol);
  
  wire [1:0]  jumptemp;
 
  maindec md(
    .op         (op_id),
    .jump       (jumptemp),
    .id_control (id_control),
    .ex_control (ex_control),
    .mem_control(mem_control),
    .wb_control (wb_control));

  aludec ad( 
    .funct      (funct_ex),
    .aluop      (aluop_ex),
    .jumptemp   (jumptemp),
    .jump       (jump),
    .alucontrol (alucontrol));

endmodule


module maindec(input  [5:0] op,
               output       id_control,
               output [6:0] ex_control,
               output [2:0] mem_control,
               output [1:0] wb_control,
               output [1:0] jump);

  reg  [14:0] controls;
  
  // other
  wire        signext;
  //wire [1:0]  jump;
  // ex
  wire        shiftl16;
  wire [1:0]  alusrc;
  wire [1:0]  aluop;
  wire [1:0]  regdst; 
  // mem
  wire        regwrite;
  wire [1:0]  branch;
  // wb
  wire        memtoreg, memwrite;

  assign {signext, shiftl16, regwrite, regdst, alusrc, branch, memwrite,
          memtoreg, jump, aluop} = controls;
       
  /*
  shiftl16 = ex_control[6]
  regdst = ex_control[5:4]
  aluop = ex_control[3:2]
  alusrc = ex_control[1:0]
  
  memwrite = mem_control[2]
  branch = mem_control[1:0]
  
  memtoreg = wb_control[1]
  regwrite = wb_control[0]
  */
  assign id_control = signext;
  assign ex_control = {shiftl16, regdst, aluop, alusrc};
  assign mem_control = {memwrite, branch};
  assign wb_control = {memtoreg, regwrite};

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
                input  [1:0]  jump,
                input         id_control_idin,
                input  [6:0]  ex_control_idin,
                input  [2:0]  mem_control_idin,
                input  [1:0]  wb_control_idin,
                input  [3:0]  alucontrol_exin,
                input  [31:0] instr_ifin,
                output [5:0]  op_idout,
                output [5:0]  funct_exout,
                output [1:0]  aluop_exout,
                output [31:0] pc,
                output [31:0] aluout, writedata,
                output        memwrite,
                input  [31:0] readdata);

  wire [31:0] pcnext, pcnextbr;
  wire [31:0] signimmsh, shiftedimm;
  wire [31:0] srcb;
  wire [31:0] result;
//wire        shift;
  wire [4:0]  ra1;
  wire        pcsrc;
  wire [1:0]  fw_control_srca;
  wire [1:0]  fw_control_srcb;
  wire [31:0] srca_fw, srcb_fw;
  wire        stall_control;
  
  // if out
  wire [31:0] pcplus4_if;
//wire [31:0] instr_if == instr;
  
  // id in
  wire [31:0] pcplus4_id;
  wire [31:0] instr_id;
  // id out
  wire [31:0] writedata_id;
  wire [31:0] srca_id;
  wire [31:0] signimm_id;
  wire [4:0]  instr_rs_id;
  wire [4:0]  instr_rt_id;
  wire [4:0]  instr_rd_id;
  wire        id_control_id;
  wire [6:0]  ex_control_id;
  wire [2:0]  mem_control_id;
  wire [1:0]  wb_control_id;
  
  // ex in
  wire [31:0] pcplus4_ex;
  wire [31:0] srca_ex;
  wire [31:0] signimm_ex;
  wire [4:0]  instr_rs_ex;
  wire [4:0]  instr_rt_ex;
  wire [4:0]  instr_rd_ex;
  wire [6:0]  ex_control_ex;
  // ex in-out
  wire [31:0] writedata_ex;
  wire [2:0]  mem_control_ex;
  wire [1:0]  wb_control_ex;
  // ex out
  wire [31:0] pcbranch_ex;
  wire        zero_ex;
  wire [31:0] aluout_ex;
  wire [4:0]  writereg_ex;
  
  // mem in
  wire [31:0] pcbranch_mem;
  wire [31:0] writedata_mem;
  wire        zero_mem;
  wire [2:0]  mem_control_mem;
  // mem in-out
  wire [31:0] aluout_mem;
  wire [4:0]  writereg_mem;
  wire [1:0]  wb_control_mem;
  // mem out
  wire [31:0] memreaddata_mem;
  
  // wb in
  wire [31:0] memreaddata_wb;
  wire [31:0] aluout_wb;
  wire [4:0]  writereg_wb;
  wire [1:0]  wb_control_wb;
  
  assign writedata = writedata_mem;
  assign aluout = aluout_mem;
  assign memreaddata_mem = readdata;
  assign instr_rs_id = instr_id[25:21];
  assign instr_rt_id = instr_id[20:16];
  assign instr_rd_id = instr_id[15:11];
  assign op_idout = instr_id[31:26];
  assign funct_exout = signimm_ex[5:0];
  assign aluop_exout = ex_control_ex[3:2];
  assign pcsrc = mem_control_mem[0] & zero_mem | mem_control_mem[1] & !zero_mem; // be careful for branch is 2'b11
  assign memwrite = mem_control_mem[2];
  assign stall_control = (wb_control_ex[1] == 1'b1) && ((instr_rt_ex == instr_rs_id) || (instr_rt_ex == instr_rt_id));
  
  // for pipeline
  flopenr #(64) if_id(
    .clk   (clk),
    .reset (reset),
    .en    (~stall_control),
    .d     ({pcplus4_if, instr_ifin}),
    .q     ({pcplus4_id, instr_id}));
  
  mux2 #(13) hazardmux(
    .d0  ({id_control_idin, ex_control_idin, mem_control_idin, wb_control_idin}),
    .d1  (13'b0),
    .s   (stall_control),
    .y   ({id_control_id, ex_control_id, mem_control_id, wb_control_id}));
  
  flopenr #(155) id_ex(
    .clk   (clk),
    .reset (reset),
    .en    (1'b1),
    .d     ({pcplus4_id, srca_id, writedata_id, signimm_id, instr_rs_id, instr_rt_id, instr_rd_id, ex_control_id, mem_control_id, wb_control_id}),
    .q     ({pcplus4_ex, srca_ex, writedata_ex, signimm_ex, instr_rs_ex, instr_rt_ex, instr_rd_ex, ex_control_ex, mem_control_ex, wb_control_ex}));
   
  flopenr #(107) ex_mem(
    .clk   (clk),
    .reset (reset),
    .en    (1'b1),
    .d     ({pcbranch_ex, zero_ex, aluout_ex, writedata_ex, writereg_ex, mem_control_ex, wb_control_ex}),
    .q     ({pcbranch_mem, zero_mem, aluout_mem, writedata_mem, writereg_mem, mem_control_mem, wb_control_mem}));
   
  flopenr #(71) mem_wb(
    .clk   (clk),
    .reset (reset),
    .en    (1'b1),
    .d     ({memreaddata_mem, aluout_mem, writereg_mem, wb_control_mem}),
    .q     ({memreaddata_wb, aluout_wb, writereg_wb, wb_control_wb}));

  // next PC logic
  flopenr #(32) pcreg(
    .clk   (clk),
    .reset (reset),
    .en    (~stall_control),
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
    .d1  (pcbranch_mem),
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
    .we      (wb_control_wb[0]),
    .ra1     (ra1),
    .ra2     (instr_id[20:16]),
    .wa      (writereg_wb),
    .wd      (result),
    .rd1     (srca_id),
    .rd2     (writedata_id));
  
  mux2 #(5) zeromux(
    .d0  (instr_id[25:21]),
    .d1  (5'b00000),
    .s   (ex_control_ex[1]),
    .y   (ra1));

  mux4 #(5) wrmux(
    .d0  (instr_rt_ex),
    .d1  (instr_rd_ex),
    .d2  (5'b11111), // $31
    .d3  (5'b00001),
    .s   (ex_control_ex[5:4]),
    .y   (writereg_ex));

  mux2 #(32) resmux(
    .d0 (aluout_wb),
    .d1 (memreaddata_wb),
    .s  (wb_control_wb[1]),
    .y  (result));

  sign_zero_ext sze(
    .a       (instr_id[15:0]),
    .signext (id_control_id),
    .y       (signimm_id[31:0]));

  shift_left_16 sl16(
    .a         (signimm_ex[31:0]),
    .shiftl16  (ex_control_ex[6]),
    .y         (shiftedimm[31:0]));

  // ALU logic
  mux4 #(32) srcbmux(
    .d0 (srcb_fw),
    .d1 (shiftedimm[31:0]),
    .d2 (pcplus4_ex),
    .d3 (32'b0),
    .s  (ex_control_ex[1:0]),
    .y  (srcb));

  forwarding fw(
    .rs_ex           (instr_rs_ex),
    .rt_ex           (instr_rt_ex),
    .writereg_mem    (writereg_mem),
    .writereg_wb     (writereg_wb),
    .memtoreg_mem    (wb_control_mem[0]),
    .memtoreg_wb     (wb_control_wb[0]),
    .fw_control_srca (fw_control_srca),
    .fw_control_srcb (fw_control_srcb));
    
  mux4 #(32) fwsrcamux(
    .d0 (srca_ex),
    .d1 (aluout_mem),
    .d2 (result),
    .d3 (32'bx),
    .s  (fw_control_srca),
    .y  (srca_fw));
    
  mux4 #(32) fwsrcbmux(
    .d0 (writedata_ex),
    .d1 (aluout_mem),
    .d2 (result),
    .d3 (32'bx),
    .s  (fw_control_srcb),
    .y  (srcb_fw));

  alu alu(
    .a       (srca_fw),
    .b       (srcb),
    .alucont (alucontrol_exin),
    .result  (aluout_ex),
    .zero    (zero_ex));
    
endmodule

module forwarding (input      [4:0] rs_ex,
                   input      [4:0] rt_ex,
                   input      [4:0] writereg_mem,
                   input      [4:0] writereg_wb,
                   input            memtoreg_mem,
                   input            memtoreg_wb,
                   output reg [1:0] fw_control_srca,
                   output reg [1:0] fw_control_srcb);

   always@(*)
   begin
      if           (rs_ex == writereg_mem && memtoreg_mem == 1'b1) fw_control_srca <= #`mydelay 2'b01;
      else if      (rs_ex == writereg_wb && memtoreg_wb == 1'b1)   fw_control_srca <= #`mydelay 2'b10;
      else                                                         fw_control_srca <= #`mydelay 2'b00;
      
      if           (rt_ex == writereg_mem && memtoreg_mem == 1'b1) fw_control_srcb <= #`mydelay 2'b01;
      else if      (rt_ex == writereg_wb && memtoreg_wb == 1'b1)   fw_control_srcb <= #`mydelay 2'b10;
      else                                                         fw_control_srcb <= #`mydelay 2'b00;
   end

endmodule
