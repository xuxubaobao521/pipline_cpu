`include "define.v"
module fetch_reg(
	//input
	input wire				rst,
	input wire				clk_i,
	input wire				F_bubble_i,
	input wire				F_stall_i,
	input wire[`INSTR_WIDTH - 1:0]		instr_i,
	input wire[`PC_WIDTH - 1:0]		F_PC_i,
	input wire[`PC_WIDTH - 1:0]		F_nPC_i,
	input wire				F_commit_i,
	input wire				F_train_predict_i,
	input wire 				F_train_vaild_i,
	input wire [`history_WIDTH - 1:0] 	F_train_global_history_i,
	input wire 				F_train_global_predict_i,
	input wire				F_train_local_predict_i,
	//output
	output reg				FD_train_local_predict_o,
	output reg				FD_train_global_predict_o,
	output reg[`history_WIDTH - 1:0]	FD_train_global_history_o,
	output reg[`INSTR_WIDTH - 1:0]		FD_instr_o,
	output reg[`PC_WIDTH - 1:0]		FD_PC_o,
	output reg[`PC_WIDTH - 1:0]		FD_nPC_o,
	output reg				FD_train_predict_o,
	output reg 				FD_train_vaild_o,
	output reg				FD_commit_o
);
	always @(posedge clk_i) begin
		if(F_bubble_i | rst) begin
			FD_instr_o			<=`nop_instr;
			FD_PC_o				<=`nop_PC;
			FD_nPC_o			<=`nop_nPC;
			FD_commit_o 			<=`nop_commit;
			FD_train_predict_o		<= 0;
			FD_train_vaild_o		<= 0;
			FD_train_global_history_o	<= 0;
			FD_train_global_predict_o	<= 0;
			FD_train_local_predict_o	<= 0;
		end
		else if(~F_stall_i)begin
			FD_instr_o				<=instr_i;
			FD_PC_o					<=F_PC_i;
			FD_nPC_o				<=F_nPC_i;
			FD_commit_o 				<=F_commit_i;
			FD_train_vaild_o			<=F_train_vaild_i;
			FD_train_predict_o			<=F_train_predict_i;
			FD_train_global_history_o		<=F_train_global_history_i;
			FD_train_global_predict_o		<=F_train_global_predict_i;
			FD_train_local_predict_o		<=F_train_local_predict_i;
		end
	end
endmodule
