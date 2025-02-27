			`include "define.v"
module memory_reg(
	//input
	input wire							rst,
	input wire							clk_i,
	input wire							ED_sel_reg_i,
	input wire [`XLEN - 1:0]			ED_valE_i,
	input wire [`XLEN - 1:0]			M_valM_i,
	input wire                      	ED_need_dstE_i,
	input wire [4:0]                	ED_dstE_i,
	input wire [`PC_WIDTH - 1:0]		ED_PC_i,
	input wire [`PC_WIDTH -1:0]			ED_nPC_i,
	input wire 							ED_commit_i,
	input wire [`INSTR_WIDTH - 1:0]		ED_instr_i,
	input wire							ED_train_predict_i,
	input wire 							ED_train_vaild_i,
	input wire 							ED_train_taken_i,
	input wire [`history_WIDTH - 1:0] 	ED_train_global_history_i,
	input wire 							ED_train_global_predict_i,
	input wire							ED_train_local_predict_i,
	input wire							ED_train_global_taken_i,
	input wire							ED_train_local_taken_i,
	input wire							ED_success_hit_i,
	input wire							ED_jal_i,
	input wire							execute_vaild_i,
	input wire							memory_ready_i,
	input wire							write_back_allow_in_i,
	input wire 							ED_need_CSR_i,
	input wire [`CSR_number_WIDTH - 1:0]ED_csr_addr_i,
	input wire [`CSR_WIDTH - 1:0]	  	ED_csr_op_i,
	input wire [`XLEN - 1:0]			ED_csr_valE_i,
	//output
	output reg [`XLEN - 1:0]			MD_csr_valE_o,
	output reg 							MD_need_CSR_o,
	output reg [`CSR_number_WIDTH - 1:0]MD_csr_addr_o,
	output reg [`CSR_WIDTH - 1:0]	  	MD_csr_op_o,
	output reg							memory_vaild_o,
	output reg							MD_jal_o,
	output reg							MD_train_local_predict_o,
	output reg							MD_train_global_predict_o,
	output reg[`history_WIDTH - 1:0]	MD_train_global_history_o,
	output reg							MD_train_global_taken_o,
	output reg							MD_train_local_taken_o,
	output reg [`INSTR_WIDTH - 1:0]		MD_instr_o,
	output reg							MD_sel_reg_o,
	output reg [`XLEN - 1:0]			MD_valM_o,
	output reg [`XLEN - 1:0]			MD_valE_o,
	output reg                     		MD_need_dstE_o,
	output reg [4:0]                	MD_dstE_o,
	output reg							MD_train_predict_o,
	output reg 							MD_train_vaild_o,
	output reg 							MD_train_taken_o,
	output reg							MD_success_hit_o,
	output reg [`PC_WIDTH - 1:0]		MD_PC_o,
	output reg [`PC_WIDTH -1:0]			MD_nPC_o,
	output reg 							MD_commit_o
);
	always @(posedge clk_i) begin
		if(rst | (~execute_vaild_i & write_back_allow_in_i))begin
			memory_vaild_o				<= 0;
			MD_sel_reg_o 				<= 0;
			MD_valM_o					<= 0;
			MD_valE_o					<= 0;
			MD_need_dstE_o				<= 0;
			MD_dstE_o					<= 0;
			MD_PC_o						<= `nop_PC;
			MD_nPC_o					<= `nop_nPC;
			MD_commit_o					<= `nop_commit;
			MD_instr_o					<= `nop_instr;
			MD_train_taken_o			<= 0;
			MD_train_vaild_o			<= 0;
			MD_train_predict_o			<= 0;
			MD_train_global_history_o	<= 0;
			MD_train_global_predict_o	<= 0;
			MD_train_local_predict_o	<= 0;
			MD_train_global_taken_o 	<= 0;
			MD_train_local_taken_o 		<= 0;
			MD_success_hit_o			<= 0;
			MD_jal_o					<= 0;
			MD_csr_op_o					<= 0;
			MD_need_CSR_o				<= 0;
			MD_csr_addr_o				<= 0;
			MD_csr_valE_o				<= 0;
		end
		else if(memory_ready_i & write_back_allow_in_i)begin
			memory_vaild_o				<= execute_vaild_i;
			MD_sel_reg_o 				<= ED_sel_reg_i;
			MD_valM_o					<= M_valM_i;
			MD_valE_o					<= ED_valE_i;
			MD_need_dstE_o				<= ED_need_dstE_i;
			MD_dstE_o					<= ED_dstE_i;
			MD_PC_o						<= ED_PC_i;
			MD_nPC_o					<= ED_nPC_i;
			MD_commit_o					<= ED_commit_i;
			MD_instr_o					<= ED_instr_i;
			MD_train_taken_o			<= ED_train_taken_i;
			MD_train_vaild_o			<= ED_train_vaild_i;
			MD_train_predict_o			<= ED_train_predict_i;
			MD_train_global_history_o	<= ED_train_global_history_i;
			MD_train_global_predict_o	<= ED_train_global_predict_i;
			MD_train_local_predict_o	<= ED_train_local_predict_i;
			MD_train_global_taken_o 	<= ED_train_global_taken_i;
			MD_train_local_taken_o 		<= ED_train_local_taken_i;
			MD_success_hit_o			<= ED_success_hit_i;
			MD_jal_o					<= ED_jal_i;
			MD_csr_op_o					<= ED_csr_op_i;
			MD_need_CSR_o				<= ED_need_CSR_i;
			MD_csr_addr_o				<= ED_csr_addr_i;
			MD_csr_valE_o				<= ED_csr_valE_i;
		end
		else if(~memory_ready_i & write_back_allow_in_i) begin
			memory_vaild_o				<= 0;
			MD_sel_reg_o 				<= 0;
			MD_valM_o					<= 0;
			MD_valE_o					<= 0;
			MD_need_dstE_o				<= 0;
			MD_dstE_o					<= 0;
			MD_PC_o						<= `nop_PC;
			MD_nPC_o					<= `nop_nPC;
			MD_commit_o					<= `nop_commit;
			MD_instr_o					<= `nop_instr;
			MD_train_taken_o			<= 0;
			MD_train_vaild_o			<= 0;
			MD_train_predict_o			<= 0;
			MD_train_global_history_o	<= 0;
			MD_train_global_predict_o	<= 0;
			MD_train_local_predict_o	<= 0;
			MD_train_global_taken_o 	<= 0;
			MD_train_local_taken_o 		<= 0;
			MD_success_hit_o			<= 0;
			MD_jal_o					<= 0;
			MD_csr_op_o					<= 0;
			MD_need_CSR_o				<= 0;
			MD_csr_addr_o				<= 0;
			MD_csr_valE_o				<= 0;
		end
	end
endmodule
