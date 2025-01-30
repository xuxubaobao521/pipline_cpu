`include "define.v"
module PC_sel(
	input wire			ED_op_jalr_i,
	input wire			ED_train_vaild_i,
	input wire			ED_train_taken_i,
	input wire[`PC_WIDTH - 1:0] 	ED_jmp_i,
	
	input wire[`PC_WIDTH - 1:0] 	F_PC_i,
	output wire[`PC_WIDTH - 1:0]	F_sel_PC_o
);
	
	assign F_sel_PC_o = (ED_train_vaild_i & (~ED_train_taken_i)) | ED_op_jalr_i ? ED_jmp_i : F_PC_i;
endmodule
