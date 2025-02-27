//指令长度 PC长度 字长
`define INSTR_WIDTH 32
`define PC_WIDTH 32
`define XLEN 32

//操作码
`define branch 7'b1100011
`define jal 7'b1101111
`define jalr 7'b1100111
`define store 7'b0100011
`define load 7'b0000011
`define alur 7'b0110011
`define alurw 7'b0111011
`define alui 7'b0010011
`define aluiw 7'b0011011
`define lui 7'b0110111
`define auipc 7'b0010111
`define system 7'b1110011

`define OP_WIDTH 12
`define op_branch 0
`define op_jal 1
`define op_jalr 2
`define op_store 3
`define op_load 4
`define op_alur 5
`define op_alurw 6
`define op_alui 7
`define op_aluiw 8
`define op_lui 9
`define op_auipc 10
`define op_system 11

//ALU操作 
`define ALU_add 3'b000
`define ALU_sub 3'b000
`define ALU_sll 3'b001
`define ALU_slt 3'b010
`define ALU_sltu 3'b011
`define ALU_xor 3'b100
`define ALU_srl 3'b101
`define ALU_sra 3'b101
`define ALU_or 3'b110
`define ALU_and 3'b111
`define ALU_mul 3'b000
`define ALU_mulh 3'b001
`define ALU_mulhsu 3'b010
`define ALU_mulhu 3'b011
`define ALU_div 3'b100
`define ALU_divu 3'b101
`define ALU_rem 3'b110
`define ALU_remu 3'b111

`define ALU_WIDTH 18
`define alu_add 0
`define alu_sub 1
`define alu_sll 2
`define alu_slt 3
`define alu_sltu 4
`define alu_xor 5
`define alu_srl 6
`define alu_sra 7
`define alu_or 8
`define alu_and 9
`define alu_mul 10
`define alu_mulh 11
`define alu_mulhu 12
`define alu_mulhsu 13
`define alu_div 14
`define alu_divu 15
`define alu_rem 16
`define alu_remu 17

//branch操作
`define eq 3'b000
`define ne 3'b001
`define lt 3'b100
`define ge 3'b101
`define ltu 3'b110
`define geu 3'b111


`define BRANCH_WIDTH 6
`define branch_eq 0 
`define branch_ne 1
`define branch_lt 2
`define branch_ge 3
`define branch_ltu 4
`define branch_geu 5

//store
`define sb 3'b000
`define sh 3'b001
`define sw 3'b010
`define sd 3'b011

`define STORE_WIDTH 4
`define store_sb 0
`define store_sh 1
`define store_sw 2
`define store_sd 3
//load
`define lb 3'b000
`define lh 3'b001
`define lw 3'b010
`define ld 3'b011
`define lbu 3'b100
`define lhu 3'b101
`define lwu 3'b110

`define LOAD_WIDTH 7
`define load_lb 0
`define load_lh 1
`define load_lw 2
`define load_ld 3
`define load_lbu 4
`define load_lhu 5
`define load_lwu 6

//最开始的nop指令
`define nop_instr 32'h00000013
`define nop_commit 1'b0
`define nop_PC    32'd0
`define nop_nPC 32'd0
//分支预测器
`define history_WIDTH 7
`define PHT_WIDTH 128
//BTB
`define BIA_WIDTH 12
`define BTA_WIDTH 32
`define BTB_index_WIDTH 8


//csr
`define CSR_NUMBER 4096
`define rw 3'b001
`define rs 3'b010
`define rc 3'b011
`define wi 3'b101
`define si 3'b110
`define ci 3'b111

`define CSR_WIDTH 8
`define csr_rw 0
`define csr_rs 1
`define csr_rc 2
`define csr_wi 3
`define csr_si 4
`define csr_ci 5
`define ecall 6
`define mret 7

`define CSR_number_WIDTH 12

//cache
`define cache_offset 4
`define cache_index 9
`define cache_tag 19
`define cache_data 128
`define cache_line 512

// 2^9 = 512个cahce行
//cacahe 每行2^{4}B  共2^(9)行 cache容量为8KB 直接映射
//地址划分
//tag(31-13)共19位       index(12-4)共九位   offset(3-0) 共四位

`define cancel 0
`define normal 1
`define save 2