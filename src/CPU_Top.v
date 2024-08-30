`include "PC.v"
`include "Mux2_32b.v"
`include "Add2_32b.v"
`include "INSTR_MEM.v"
`include "IF_ID.v"
`include "Shift_left_1b.v"
`include "Sign_Extend.v"
`include "HazardUnit.v"
`include "Registers.v"
`include "Mux3_32b.v"
`include "Forwarding.v"
`include "ID_EX.v"
`include "Control.v"
`include "Mux_ctrl.v"
`include "BranchUnit.v"
`include "ALU.v"
`include "ALU_Ctrl.v"
`include "EX_MEM.v"
`include "DATA_MEM.v"
`include "MEM_WB.v"

/* ------------------------------ I/O Ports ------------------------------ */

module CPU_Top(
    input wire       CLK, 
    input wire       nRESET
    );

/* ------------------------------ Wire & Reg ------------------------------ */

wire [31:0] pc_i;           // Mux_pc -> PC
wire [31:0] pc_o;           // PC -> Add_pc, Instr_Mem
wire [31:0] pc_incr;        // Add_pc -> Mux_pc, IF_ID
wire [31:0] instr;          // INSTR_MEM -> IF_ID
wire [31:0] IF_ID_pc_o;     // IF_ID -> ID_EX, Add_br
wire [31:0] IF_ID_instr_o;  // IF_ID -> ID_EX, HazardUnit, Registers, Control, Mux_ctrl, BranchUnit
wire [11:0] IF_ID_imm;      // IF_ID -> Imm_Extend_B
wire [31:0] pc_br_addr;     // Add_br -> Mux_pc
wire [31:0] br_offset;      // Shift -> Add_br
wire [11:0] pc_imm_B;       // INSTR_MEM -> IF_ID
wire [31:0] extd_imm_B;     // Imm_Extend_B -> Shift, ID_EX
wire [31:0] extd_imm_IS;    // Imm_Extend_IS
wire        hazard;         // HazardUnit -> PC, IF_ID, Mux_Ctrl
wire [31:0] REG_DATA;       // Registers -> external
wire [31:0] Reg_RSdata;     // Registers -> ID_EX, BranchUnit
wire [31:0] Reg_RTdata;     // Registers -> ID_EX, BranchUnit

wire [31:0] ID_EX_instr_o;      // ID_EX -> EX_MEM, HazardUnit, ALU_Ctrl
wire [31:0] ID_EX_pc_o;         // ID_EX -> EX_MEM
wire [31:0] ID_EX_RDdata0_o;    // ID_EX -> Mux_fwd0
wire [31:0] ID_EX_RDdata1_o;    // ID_EX -> Mux_fwd1
wire [31:0] ID_EX_imm_extd_ISo; // ID_EX -> Mux_alu
wire [ 4:0] ID_EX_RSaddr_o;     // ID_EX -> Forwarding
wire [ 4:0] ID_EX_RTaddr_o;     // ID_EX -> Forwarding
wire [ 4:0] ID_EX_RDaddr_o;     // ID_EX -> EX_MEM
wire [ 1:0] ID_EX_ALUop_o;      // ID_EX -> ALU_Ctrl
wire        ID_EX_ALUsrc_o;     // ID_EX -> Mux_alu
wire        ID_EX_RegWrite_o;   // ID_EX -> EX_MEM
wire        ID_EX_MemToReg_o;   // ID_EX -> EX_MEM
wire        ID_EX_MemRead_o;    // ID_EX -> EX_MEM, HazardUnit
wire        ID_EX_MemWrite_o;   // ID_EX -> EX_MEM

wire [ 1:0] Ctrl_ALUop_o;       // Control -> Mux_ctrl
wire        Ctrl_ALUsrc_o;      // Control -> Mux_ctrl
wire        Ctrl_RegWrite_o;    // Control -> Mux_ctrl
wire        Ctrl_MemRead_o;     // Control -> Mux_ctrl
wire        Ctrl_MemWrite_o;    // Control -> Mux_ctrl
wire        Ctrl_MemToReg_o;    // Control -> Mux_ctrl
wire        Ctrl_imm_sel;       // Control -> Imm_Extend_IS

wire [ 4:0] Mux_ctrl_RDaddr_o;      // Mux_ctrl -> ID_EX
wire [ 1:0] Mux_ctrl_ALUop_o;       // Mux_ctrl -> ID_EX
wire        Mux_ctrl_ALUsrc_o;      // Mux_ctrl -> ID_EX
wire        Mux_ctrl_RegWrite_o;    // Mux_ctrl -> ID_EX
wire        Mux_ctrl_MemRead_o;     // Mux_ctrl -> ID_EX
wire        Mux_ctrl_MemWrite_o;    // Mux_ctrl -> ID_EX
wire        Mux_ctrl_MemToReg_o;    // Mux_ctrl -> ID_EX

wire        branch;         // BranchUnit -> Mux_pc
wire        flush;          // BranchUnit -> IF_ID

wire [31:0] Mux_fwd0_data;  // Mux_fwd0 -> ALU
wire [31:0] Mux_fwd1_data;  // Mux_fwd1 -> EX_MEM, Mux_alu
wire [31:0] Mux_alu_data;   // Mux_alu -> ALU

wire [31:0] ALUresult;   // ALU -> EX_MEM
wire [ 2:0] ALUctrl;     // ALU_Ctrl -> ALU

wire [31:0] EX_MEM_ALUresult_o; // EX_MEM -> MEM_WB, DATA_MEM, Mux_fwd0, Mux_fwd1
wire [31:0] EX_MEM_RDdata_o;    // EX_MEM -> DATA_MEM
wire [ 4:0] EX_MEM_RDaddr_o;    // EX_MEM -> MEM_WB, Forwarding
wire        EX_MEM_RegWrite_o;  // EX_MEM -> MEM_WB, Forwarding
wire        EX_MEM_MemToReg_o;  // EX_MEM -> MEM_WB
wire        EX_MEM_MemRead_o;   // EX_MEM -> DATA_MEM
wire        EX_MEM_MemWrite_o;  // EX_MEM -> DATA_MEM

wire [31:0] MEMdata_o;      // DATA_MEM -> MEM_WB
wire [31:0] DM_data_mem_o;  // DATA_MEM -> external

wire [31:0] MEM_WB_ALUresult_o;	// MEM_WB -> Mux_WB
wire [ 4:0] MEM_WB_RDaddr_o;	// MEM_WB -> Fowarding, Registers
wire        MEM_WB_RegWrite_o;	// MEM_WB -> Fowarding, Registers
wire        MEM_WB_MemToReg_o;	// MEM_WB -> Mux_WB
wire [31:0] MEM_WB_MemData_o;	// MEM_WB -> Mux_WB

wire [31:0] Mux_WB_data_o; // Mux_WB -> Registers, Mux_fwd0, Mux_fwd1

wire [ 1:0] forward0;   // Forwarding -> Mux_fwd0
wire [ 1:0] forward1;   // Forwarding -> Mux_fwd1

wire [31:0] MEM_0;
wire [31:0] MEM_1;
wire [31:0] MEM_2;
wire [31:0] MEM_3;
wire [31:0] MEM_4;
wire [31:0] MEM_5;
wire [31:0] MEM_6;
wire [31:0] MEM_7;

wire [11:0] IF_ID_imm_I;
wire [11:0] IF_ID_imm_S;

wire [31:0] X1;
wire [31:0] X2;
wire [31:0] X3;
wire [31:0] X4;
wire [31:0] X5;
/* ------------------------------ Assignments ------------------------------ */

assign IF_ID_imm_I = IF_ID_instr_o[31:20];                          // I-type imm
assign IF_ID_imm_S = {IF_ID_instr_o[31:25], IF_ID_instr_o[11:7]};   // S-type imm
assign pc_imm_B = {instr[31], instr[7], instr[30:25], instr[11:8]}; // B-type imm

/* ------------------------------ Sub-modules ------------------------------ */

PC uPC(
    .CLK        (CLK),      // <- external
    .nRESET     (nRESET),   // <- external
    .hazard_i   (hazard),   // <- HazardUnit
    .pc_i       (pc_i),     // <- Mux_pc
    .pc_o       (pc_o)      // -> Add_pc, INSTR_MEM
);

Mux2_32b Mux_pc(
    .data1_i    (pc_incr),      // <- Add_pc
    .data2_i    (pc_br_addr),   // <- Add_br 
    .select_i   (branch),       // <- BranchUnit
    .data_o     (pc_i)          // -> PC
);

Add2_32b Add_pc(
    .data1_i    (pc_o),     // <- PC
    .data2_i    (32'd4),    // +4
    .data_o     (pc_incr)   // -> Mux_pc, IF_ID
);

INSTR_MEM uINSTR_MEM(
    .CLK        (CLK),      // <- external
    .nRESET     (nRESET),   // <- external
    .addr_i     (pc_o),     // <- PC
    .instr_o    (instr)     // -> IF_ID
);

IF_ID uIF_ID(
    .CLK            (CLK),          // <- external
    .nRESET         (nRESET),       // <- external
    .pc_i           (pc_incr),      // <- Add_pc
    .instr_i        (instr),        // <- INSTR_MEM
    .hazard_i       (hazard),       // <- HazardUnit
    .flush_i        (flush),        // <- BranchUnit
    .pc_offset_i    (pc_imm_B),     // <- INSTR_MEM (assign)
    .pc_offset_o    (IF_ID_imm),    // -> Imm_Extend_B
    .pc_o           (IF_ID_pc_o),   // -> Add_br, ID_EX
    .instr_o        (IF_ID_instr_o) // -> ID_EX, HazardUnit, Registers, Control, Mux_ctrl, BranchUnit
);

Add2_32b Add_br(
    .data1_i    (br_offset),     // <- Shift
    .data2_i    (IF_ID_pc_o),    // <- IF_ID
    .data_o     (pc_br_addr)     // -> Mux_pc
);

Shift_left_1b Shift(
  .data_i   (extd_imm_B),   // <- Imm_Extend_B
  .data_o   (br_offset)     // -> Add_br
);

Sign_Extend Imm_Extend_IS(  // for I-type, S-type
    .select_i   (Ctrl_imm_sel), // <- Control
    .data0_i    (IF_ID_imm_I),  // <- IF_ID (I-type) assign
    .data1_i    (IF_ID_imm_S),  // <- IF_ID (S-type) assign
    .data_o     (extd_imm_IS)   // -> ID_EX
);

Sign_Extend Imm_Extend_B(   // for B-type
    .select_i   (1'b0),
    .data0_i    (IF_ID_imm),    // <- IF_ID
    .data1_i    (12'b0),
    .data_o     (extd_imm_B)    // -> Shift
);

HazardUnit uHazardUnit(
    .IF_IDrs_i          (IF_ID_instr_o[19:15]), // <- IF_ID
    .IF_IDrt_i          (IF_ID_instr_o[24:20]), // <- IF_ID
    .ID_EXrd_i          (IF_ID_instr_o[19:15]), // <- ID_EX
    .ID_EX_MemRead_i    (ID_EX_MemRead_o),      // <- ID_EX
    .hazard_o           (hazard)                // -> IF_ID, Mux_Ctrl
);

Registers uRegisters(
    .CLK        (CLK),                  // <- external
    .nRESET     (nRESET),               // <- external
    .RSaddr_i   (IF_ID_instr_o[19:15]), // <- IF_ID
    .RTaddr_i   (IF_ID_instr_o[24:20]), // <- IF_ID
    .RDaddr_i   (MEM_WB_RDaddr_o),      // <- MEM_WB
    .RDdata_i   (Mux_WB_data_o),        // <- Mux_WB
    .RegWrite_i (MEM_WB_RegWrite_o),    // <- MEM_WB
    .RSdata_o   (Reg_RSdata),           // -> ID_EX
    .RTdata_o   (Reg_RTdata),           // -> ID_EX
    .x1_o(X1),             // Debug output for x1
    .x2_o(X2),             // Debug output for x2
    .x3_o(X3),             // Debug output for x3
    .x4_o(X4),             // Debug output for x4
    .x5_o(X5)              // Debug output for x5
);

Mux3_32b Mux_fwd0(
    .sel        (forward0),             // <- Forwarding
    .data1_i    (ID_EX_RDdata0_o),      // <- ID_EX
    .data2_i    (EX_MEM_ALUresult_o),   // <- EX_MEM
    .data3_i    (Mux_WB_data_o),        // <- Mux_WB
    .data_o     (Mux_fwd0_data)         // -> ALU
);

Mux3_32b Mux_fwd1(
    .sel        (forward1),             // <- Forwarding
    .data1_i    (ID_EX_RDdata1_o),      // <- ID_EX
    .data2_i    (EX_MEM_ALUresult_o),   // <- EX_MEM
    .data3_i    (Mux_WB_data_o),        // <- Mux_WB
    .data_o     (Mux_fwd1_data)         // -> EX_MEM, Mux_alu
);

Forwarding uForwarding(   
    .MEM_RegWrite_i (EX_MEM_RegWrite_o),    // <- EX_MEM
    .MEM_RDaddr_i   (EX_MEM_RDaddr_o),      // <- EX_MEM
    .EX_RSaddr_i    (ID_EX_RSaddr_o),       // <- ID_EX
    .EX_RTaddr_i    (ID_EX_RTaddr_o),       // <- ID_EX
    .WB_RegWrite_i  (MEM_WB_RegWrite_o),    // <- MEM_WB
    .WB_RDaddr_i    (MEM_WB_RDaddr_o),      // <- MEM_WB
    .forward_0      (forward0),             // -> Mux_fwd0
    .forward_1      (forward1)              // -> Mux_fwd1
);

Mux2_32b Mux_alu(
    .data1_i    (Mux_fwd1_data),        // <- Mux_fwd1
    .data2_i    (ID_EX_imm_extd_ISo),   // <- ID_EX
    .select_i   (ID_EX_ALUsrc_o),       // <- ID_EX
    .data_o     (Mux_alu_data)          // -> ALU
);

ID_EX uID_EX(
	.CLK            (CLK),                  // <- external
	.nRESET         (nRESET),               // <- external
	.pc_i           (IF_ID_pc_o),           // <- IF_ID
	.instr_i        (IF_ID_instr_o),        // <- IF_ID
	.RDdata0_i      (Reg_RSdata),           // <- Registers
	.RDdata1_i      (Reg_RTdata),           // <- Registers
	.imm_extd_ISi   (extd_imm_IS),          // <- Imm_Extend_IS
	.RSaddr_i       (IF_ID_instr_o[19:15]), // <- IF_ID
    .RTaddr_i       (IF_ID_instr_o[24:20]), // <- IF_ID
	.RDaddr_i       (Mux_ctrl_RDaddr_o),    // <- Mux_ctrl
	.ALUop_i        (Mux_ctrl_ALUop_o),     // <- Mux_ctrl
	.ALUsrc_i       (Mux_ctrl_ALUsrc_o),    // <- Mux_ctrl
	.RegWrite_i     (Mux_ctrl_RegWrite_o),  // <- Mux_ctrl
	.MemToReg_i     (Mux_ctrl_MemToReg_o),  // <- Mux_ctrl
	.MemRead_i      (Mux_ctrl_MemRead_o),   // <- Mux_ctrl
	.MemWrite_i     (Mux_ctrl_MemWrite_o),  // <- Mux_ctrl
	.pc_o           (ID_EX_pc_o),           // -> EX_MEM
	.instr_o        (ID_EX_instr_o),        // -> EX_MEM
	.RDdata0_o      (ID_EX_RDdata0_o),      // -> Mux_fwd0
	.RDdata1_o      (ID_EX_RDdata1_o),      // -> Mux_fwd1
	.imm_extd_ISo   (ID_EX_imm_extd_ISo),   // -> Mux_alu
	.RSaddr_o       (ID_EX_RSaddr_o),       // -> Forwarding
	.RTaddr_o       (ID_EX_RTaddr_o),       // -> Forwarding
	.RDaddr_o       (ID_EX_RDaddr_o),       // -> EX_MEM
	.ALUop_o        (ID_EX_ALUop_o),        // -> ALU_Ctrl
	.ALUsrc_o       (ID_EX_ALUsrc_o),       // -> Mux_alu
	.RegWrite_o     (ID_EX_RegWrite_o),	    // -> EX_MEM
	.MemToReg_o     (ID_EX_MemToReg_o),		// -> EX_MEM
	.MemRead_o      (ID_EX_MemRead_o),		// -> EX_MEM, Hazard
	.MemWrite_o     (ID_EX_MemWrite_o)		// -> EX_MEM
);

Control uControl(
	.ID_op_i    (IF_ID_instr_o[6:0]),   // <- IF_ID
	.ALUop_o    (Ctrl_ALUop_o),         // -> Mux_ctrl
	.ALUsrc_o   (Ctrl_ALUsrc_o),        // -> Mux_ctrl
	.RegWrite_o (Ctrl_RegWrite_o),      // -> Mux_ctrl
	.MemRead_o  (Ctrl_MemRead_o),       // -> Mux_ctrl
	.MemWrite_o (Ctrl_MemWrite_o),      // -> Mux_ctrl
	.MemToReg_o (Ctrl_MemToReg_o),      // -> Mux_ctrl
	.imm_sel    (Ctrl_imm_sel)          // -> IMM_Extend_IS
);

Mux_ctrl uMux_ctrl(
    .hazard_i   (hazard),               // <- HazardDetect
    .RDaddr_i   (IF_ID_instr_o[11:7]),  // <- IF_ID
    .ALUop_i    (Ctrl_ALUop_o),         // <- Control
    .ALUsrc_i   (Ctrl_ALUsrc_o),        // <- Control
    .RegWrite_i (Ctrl_RegWrite_o),      // <- Control
    .MemRead_i  (Ctrl_MemRead_o),       // <- Control
    .MemWrite_i (Ctrl_MemWrite_o),      // <- Control 
    .MemToReg_i (Ctrl_MemToReg_o),      // <- Control
    .RDaddr_o   (Mux_ctrl_RDaddr_o),    // -> ID_EX
    .ALUop_o    (Mux_ctrl_ALUop_o),     // -> ID_EX
    .ALUsrc_o   (Mux_ctrl_ALUsrc_o),    // -> ID_EX
    .RegWrite_o (Mux_ctrl_RegWrite_o),  // -> ID_EX
    .MemRead_o  (Mux_ctrl_MemRead_o),   // -> ID_EX
    .MemWrite_o (Mux_ctrl_MemWrite_o),  // -> ID_EX
    .MemToReg_o (Mux_ctrl_MemToReg_o)   // -> ID_EX
);

BranchUnit uBranchUnit(
    .RSdata_i   (Reg_RSdata),           // <- Registers
    .RTdata_i   (Reg_RTdata),           // <- Registers
    .opcode     (IF_ID_instr_o[6:0]),   // <- IF_ID
    .funct3     (IF_ID_instr_o[14:12]), // <- IF_ID
    .branch     (branch),               // -> Mux_pc
    .flush      (flush)                 // -> IF_ID
);

ALU uALU(
	.data1_i    (Mux_fwd0_data),    // <- Mux_fwd0
	.data2_i    (Mux_alu_data),     // <- Mux_alu
	.ALUctrl_i  (ALUctrl),          // <- ALU_Ctrl
	.result     (ALUresult)         // -> EX_MEM
);

ALU_Ctrl uALU_Ctrl(
    .funct_i    ({ID_EX_instr_o[31:25], ID_EX_instr_o[14:12]}), // <- ID_EX {funct7, funct3}
    .ALUop_i    (ID_EX_ALUop_o),                                // <- ID_EX
    .ALUctrl_o  (ALUctrl)                                       // -> ALU
);

EX_MEM uEX_MEM(
	.CLK            (CLK),                  // <- external
	.nRESET         (nRESET),               // <- external
	.pc_i           (ID_EX_pc_o),           // <- ID_EX
	.instr_i        (ID_EX_instr_o),        // <- ID_EX
	.ALUresult_i    (ALUresult),            // <- ALU
	.RDdata_i       (Mux_fwd1_data),        // <- Mux_fwd1
	.RDaddr_i       (ID_EX_RDaddr_o),       // <- ID_EX
	.RegWrite_i     (ID_EX_RegWrite_o),     // <- ID_EX
	.MemToReg_i     (ID_EX_MemToReg_o),     // <- ID_EX
	.MemRead_i      (ID_EX_MemRead_o),      // <- ID_EX
	.MemWrite_i     (ID_EX_MemWrite_o),     // <- ID_EX
	.ALUresult_o    (EX_MEM_ALUresult_o),   // -> MEM_WB, DATA_MEM, Mux_fwd0, Mux_fwd1
	.RDdata_o       (EX_MEM_RDdata_o),      // -> DATA_MEM
	.RDaddr_o       (EX_MEM_RDaddr_o),      // -> MEM_WB, Forwarding
	.RegWrite_o     (EX_MEM_RegWrite_o),    // -> MEM_WB, Forwarding
	.MemToReg_o     (EX_MEM_MemToReg_o),    // -> MEM_WB
	.MemRead_o      (EX_MEM_MemRead_o),     // -> DATA_MEM
	.MemWrite_o     (EX_MEM_MemWrite_o)     // -> DATA_MEM
);

DATA_MEM uDATA_MEM(   
    .CLK        (CLK),                  // <- external
    .nRESET     (nRESET),               // <- external
    .addr_i     (EX_MEM_ALUresult_o),   // <- EX_MEM
    .data_i     (EX_MEM_RDdata_o),      // <- EX_MEM
    .MemWrite_i (EX_MEM_MemWrite_o),    // <- EX_MEM
    .MemRead_i  (EX_MEM_MemRead_o),     // <- EX_MEM
    .data_o     (MEMdata_o),             // -> MEM_WB
    .mem_data_0 (MEM_0),  // Memory data at address 0
    .mem_data_1 (MEM_1),  // Memory data at address 4
    .mem_data_2 (MEM_2),  // Memory data at address 8
    .mem_data_3 (MEM_3),  // Memory data at address 12
    .mem_data_4 (MEM_4),  // Memory data at address 16
    .mem_data_5 (MEM_5),  // Memory data at address 20
    .mem_data_6 (MEM_6),  // Memory data at address 24
    .mem_data_7 (MEM_7)   // Memory data at address 28
);


MEM_WB uMEM_WB(
	.CLK            (CLK),                  // <- external
	.nRESET         (nRESET),               // <- external
	.ALUresult_i    (EX_MEM_ALUresult_o),   // <- EX_MEM
	.RDaddr_i       (EX_MEM_RDaddr_o),      // <- EX_MEM
	.RegWrite_i     (EX_MEM_RegWrite_o),    // <- EX_MEM
	.MemToReg_i     (EX_MEM_MemToReg_o),    // <- EX_MEM
	.MemData_i      (MEMdata_o),            // <- DATA_MEM
	.ALUresult_o    (MEM_WB_ALUresult_o),   // -> Mux_WB
	.RDaddr_o       (MEM_WB_RDaddr_o),      // -> Forwarding, Registers
	.RegWrite_o     (MEM_WB_RegWrite_o),    // -> Forwarding, Registers
	.MemToReg_o     (MEM_WB_MemToReg_o),    // -> Mux_WB
	.MemData_o      (MEM_WB_MemData_o)      // -> Mux_WB
);

Mux2_32b Mux_WB(
    .data1_i    (MEM_WB_ALUresult_o),   // <- MEM_WB
    .data2_i    (MEM_WB_MemData_o),     // <- MEM_WB
    .select_i   (MEM_WB_MemToReg_o),    // <- MEM_WB
    .data_o     (Mux_WB_data_o)         // -> Registers, Forwarding
);

endmodule
