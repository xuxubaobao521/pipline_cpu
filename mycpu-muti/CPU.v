`include "define.v"
module CPU(
	input wire clk,
	input wire rst,
	
	output wire 	[`PC_WIDTH - 1:0] 	cur_pc,
	output wire 				commit,
	output wire	[`PC_WIDTH - 1:0]	commit_pc,
	output wire				commit_taken,
	output wire				commit_branch,
	output wire				commit_global_taken,
	output wire				commit_local_taken,
	output wire	[`PC_WIDTH - 1:0]	commit_pre_pc,
	output wire 			commit_predict_jmp,
	output wire				commit_success_hit
);
	//********************************
	//control
	//********************************
	wire					PC_stall;
	wire					PC_bubble;
	wire					F_stall;
	wire					F_bubble;
	wire					D_stall;
	wire					D_bubble;
	wire 					E_stall;
	wire 					E_bubble;
	wire 					M_stall;
	wire 					M_bubble;
	//********************************
	//control
	//********************************
	//********************************
	//fetch
	//********************************
	//op
	wire [`OP_WIDTH - 1:0]     		F_epcode;
	wire [`STORE_WIDTH - 1:0]  		F_store_op;
	wire [`LOAD_WIDTH - 1:0]   		F_load_op;
	wire [`BRANCH_WIDTH - 1:0] 		F_branch_op;
	wire [`ALU_WIDTH - 1:0]			F_ALU_op;
	wire					F_sel_reg;
	wire [`PC_WIDTH - 1:0]     		F_PC;
	//data
	wire [`PC_WIDTH - 1:0]    		nPC;
	wire [`INSTR_WIDTH - 1:0]  		instr;
	wire [4:0]                 		F_rs1;
	wire [4:0]              		F_rs2;
	wire [`XLEN - 1:0]      		F_imme;
	//addr	
	wire					F_commit;
	wire                       		F_need_dstE;
	wire [4:0]                 		F_dstE;
	wire [`PC_WIDTH - 1:0]	   		F_sel_PC;
	wire 					F_commit;
	wire					mini_op_branch;
	wire					mini_op_jal;
	wire [`PC_WIDTH - 1:0]	   		mini_jal_jmp;
	wire [`PC_WIDTH - 1:0]			mini_branch_jmp;
	wire 					F_train_predict;
	wire 					F_train_vaild;
	wire [`history_WIDTH - 1:0]		F_train_global_history;
	wire 					F_train_local_predict;
	wire					F_train_global_predict;
	wire					F_success_hit;
	//********************************
	//fetch_reg
	//********************************
	//
	//op
	wire [`INSTR_WIDTH - 1:0]		FD_instr;
	wire [`PC_WIDTH - 1:0]     		FD_PC;
	wire [`PC_WIDTH - 1:0]     		FD_nPC;
	wire 					FD_commit;
	wire 					FD_train_predict;
	wire 					FD_train_vaild;
	wire [`history_WIDTH - 1:0]		FD_train_global_history;
	wire 					FD_train_local_predict;
	wire					FD_train_global_predict;
	wire					FD_success_hit;
	wire					FD_jal;
	//********************************
	//decode
	//********************************
	
	wire					D_sel_reg;
	wire [4:0]                 		D_rs1;
	wire [4:0]                 		D_rs2;
	wire                       		D_need_dstE;
	wire [4:0]                 		D_dstE;
	wire [`OP_WIDTH - 1:0]     		D_epcode;
	wire [`BRANCH_WIDTH - 1:0] 		D_branch_op;
	wire [`STORE_WIDTH - 1:0]  		D_store_op;
	wire [`LOAD_WIDTH - 1:0]		D_load_op;
	wire [`XLEN - 1:0]         		D_imme;
	wire [`ALU_WIDTH - 1:0]    		D_ALU_op;
	wire [`XLEN - 1:0] 			D_rs1_data;
	wire [`XLEN - 1:0] 			D_rs2_data;
	
	wire [`XLEN - 1:0] 			D_fwdA;
	wire [`XLEN - 1:0] 			D_fwdB;
	//********************************
	//decode reg
	//********************************
	wire [`OP_WIDTH - 1:0]     		DD_epcode;
	wire [`STORE_WIDTH - 1:0]  		DD_store_op;
	wire [`LOAD_WIDTH - 1:0]   		DD_load_op;
	wire [`BRANCH_WIDTH - 1:0] 		DD_branch_op;
	wire [`ALU_WIDTH - 1:0]    		DD_ALU_op;
	wire					DD_sel_reg;
	wire [`PC_WIDTH - 1:0]     		DD_PC;
	wire [`PC_WIDTH - 1:0]     		DD_nPC;
	wire					DD_commit;
	wire                       		DD_need_dstE;
	wire [4:0]                 		DD_dstE;
	wire [`XLEN - 1:0]			DD_rs1_data;
	wire [`XLEN - 1:0]			DD_rs2_data;
	wire [`XLEN - 1:0] 			DD_imme;
	wire [`INSTR_WIDTH - 1:0]		DD_instr;
	wire 					DD_train_predict;
	wire 					DD_train_vaild;
	wire [`history_WIDTH - 1:0]		DD_train_global_history;
	wire 					DD_train_local_predict;
	wire					DD_train_global_predict;
	wire					DD_success_hit;
	wire					DD_jal;
	//********************************
	//execute
	//********************************
	wire [`XLEN - 1:0]			E_valE;
	wire [`XLEN - 1:0]			E_jmp;
	wire 					E_train_taken;
	wire					E_train_local_taken;
	wire					E_train_global_taken;
	wire [`PC_WIDTH - 1:0]  		E_nPC;
	wire 					E_op_jalr;
	//********************************
	//execute reg
	//********************************
	wire [`STORE_WIDTH - 1:0]  		ED_store_op;
	wire [`LOAD_WIDTH - 1:0]   		ED_load_op;
	wire					ED_sel_reg;
	wire [`XLEN - 1:0]			ED_rs2_data;
	wire [`XLEN - 1:0]			ED_valE;
	wire                       		ED_need_dstE;
	wire [4:0]                 		ED_dstE;
	wire [`PC_WIDTH - 1:0]    		ED_jmp;
	wire [`PC_WIDTH - 1:0]     		ED_PC;
	wire [`PC_WIDTH - 1:0]     		ED_nPC;
	wire					ED_commit;
	wire [`INSTR_WIDTH - 1:0]		ED_instr;
	wire					ED_train_taken;
	wire 					ED_train_predict;
	wire 					ED_train_vaild;
	wire					ED_op_jalr;
	wire [`history_WIDTH - 1:0]		ED_train_global_history;
	wire					ED_train_local_taken;
	wire					ED_train_global_taken;
	wire 					ED_train_local_predict;
	wire					ED_train_global_predict;
	wire					ED_success_hit;
	wire					ED_jal;
	//********************************
	//memory
	//********************************
	wire [`XLEN - 1:0]        		M_valM;
	//********************************
	//memory_reg
	//********************************
	wire				   	MD_sel_reg;
	wire [`XLEN - 1:0]			MD_valM;
	wire [`XLEN - 1:0]			MD_valE;
	wire                       		MD_need_dstE;
	wire [4:0]                 		MD_dstE;
	wire [`PC_WIDTH - 1:0]     		MD_PC;
	wire [`PC_WIDTH - 1:0]     		MD_nPC;
	wire					MD_commit;
	wire [`INSTR_WIDTH - 1:0]		MD_instr;
	wire					MD_train_taken;
	wire 					MD_train_predict;
	wire 					MD_train_vaild;
	wire [`history_WIDTH - 1:0]		MD_train_global_history;
	wire					MD_train_local_taken;
	wire					MD_train_global_taken;
	wire 					MD_train_local_predict;
	wire					MD_train_global_predict;
	wire					MD_success_hit;
	wire					MD_jal;
	//********************************
	//write_back
	//********************************
	wire [`XLEN - 1:0]       		W_data;
	//********************************
	//hazard_control
	//********************************
	hazard_control hazard_control(
		.D_epcode_i			(D_epcode		),
		.DD_epcode_i			(DD_epcode		),
		.D_rs1_i			(D_rs1			),
		.D_rs2_i			(D_rs2			),
		.DD_dstE_i			(DD_dstE		),
		.DD_need_dstE_i			(DD_need_dstE		),
		.E_train_taken_i		(E_train_taken		),

		.PC_stall_o			(PC_stall		),
		.PC_bubble_o			(PC_stall		),
		.F_stall_o			(F_stall		),
		.F_bubble_o			(F_bubble		),
		.D_stall_o			(D_stall		),
		.D_bubble_o			(D_bubble		),
		.E_stall_o			(E_stall		),
		.E_bubble_o			(E_bubble		),
		.M_stall_o			(M_stall		),
		.M_bubble_o			(M_bubble		)
	);
	//********************************
	//hazard_control
	//********************************
	
	//********************************
	//fetch
	//********************************
	PC_reg PC(
		//in
		.rst				(rst			),
		.clk_i				(clk			),
		.PC_bubble_i			(PC_bubble		),
		.PC_stall_i			(PC_stall		),
		.nPC_i				(nPC			),
		//out
		.F_PC_o				(F_PC			)
	);
	PC_sel PC_sel(
		//in
		.ED_op_jalr_i			(ED_op_jalr		),
		.ED_train_vaild_i		(ED_train_vaild		),
		.ED_train_taken_i		(ED_train_taken		),
		.ED_jmp_i			(ED_jmp			),
		//out
		.F_PC_i				(F_PC			),
		.F_sel_PC_o			(F_sel_PC		)
	);
	assign cur_pc = F_sel_PC;
	PC_instr PC_instr(
		//in
		.F_PC_i				(F_sel_PC		),
		//out
		.instr_o			(instr			),
		.mini_jal_jmp_o			(mini_jal_jmp		),
		.mini_branch_jmp_o		(mini_branch_jmp	),
		.F_commit_o			(F_commit		),
		.F_train_vaild_o		(F_train_vaild		),
		.mini_op_branch_o		(mini_op_branch		),
		.mini_op_jal_o			(mini_op_jal		)
	);
	CBP CBP(
		//in
		.rst				(rst			),
		.clk_i				(clk			),
		.MD_PC_i			(MD_PC[`history_WIDTH - 1:0]),
    		.MD_train_global_history_i	(MD_train_global_history),
    		.MD_train_valid_i		(MD_train_vaild		),
    		.MD_train_predict_i		(MD_train_predict	),
    		.MD_train_taken_i		(MD_train_taken		),
		.MD_train_global_taken_i	(MD_train_global_taken	),
		.MD_train_global_predict_i	(MD_train_global_predict),
		.MD_train_local_predict_i	(MD_train_local_predict	),
		.MD_train_local_taken_i		(MD_train_local_taken	),
		
		
   		.ED_train_valid_i		(ED_train_vaild		),
		.ED_train_global_history_i	(ED_train_global_history),
    		.ED_train_global_predict_i	(ED_train_global_predict),
    		.ED_train_global_taken_i	(ED_train_global_taken	),
    		
    		.F_PC_i			(F_sel_PC[`history_WIDTH - 1:0]	),
    		.mini_op_branch_i		(mini_op_branch		),
		//out
		.F_train_predict_o		(F_train_predict	),
    		.F_train_global_history_o	(F_train_global_history	),
    		.F_train_local_predict_o	(F_train_local_predict	),
    		.F_train_global_predict_o	(F_train_global_predict	)
	);
	PC_next PC_next(
		//in
		.rst				(rst			),
		.clk_i				(clk			),
		.F_PC_i				(F_sel_PC		),
		.mini_op_branch_i		(mini_op_branch		),
		.mini_op_jal_i			(mini_op_jal		),
		.mini_jal_jmp_i			(mini_jal_jmp		),
		.mini_branch_jmp_i		(mini_branch_jmp	),
		.F_train_predict_i		(F_train_predict	),
		//out
		.nPC_o				(nPC			),
		.F_success_hit_o	(F_success_hit	)
	);
	fetch_reg fetch_reg(
		//input
		.rst				(rst			),
		.clk_i				(clk			),
		.F_stall_i			(F_stall		),
		.F_bubble_i			(F_bubble		),
		.instr_i			(instr			),
		.F_PC_i				(F_sel_PC		),
		.F_nPC_i			(nPC			),
		.F_commit_i			(F_commit		),
		.F_train_predict_i		(F_train_predict	),
		.F_train_vaild_i		(F_train_vaild		),
		.F_train_global_history_i	(F_train_global_history	),
    		.F_train_local_predict_i	(F_train_local_predict	),
    		.F_train_global_predict_i	(F_train_global_predict	),
			.F_success_hit_i			(F_success_hit			),
			.F_jal_i					(mini_op_jal			),
		//output
			.FD_jal_o					(FD_jal					),
			.FD_success_hit_o			(FD_success_hit			),
    		.FD_train_local_predict_o	(FD_train_local_predict	),
    		.FD_train_global_predict_o	(FD_train_global_predict),
		.FD_train_global_history_o	(FD_train_global_history),
		.FD_train_predict_o		(FD_train_predict	),
		.FD_train_vaild_o		(FD_train_vaild		),
		.FD_PC_o			(FD_PC			),
		.FD_nPC_o			(FD_nPC			),
		.FD_commit_o			(FD_commit		),
		.FD_instr_o			(FD_instr		)
	);
	
	//********************************
	//fetch
	//********************************
	
	
	//********************************
	//decode
	//********************************
	id id(
		//input
		.FD_instr_i			(FD_instr		),
		//output
		//OP
		.D_epcode_o			(D_epcode		),
		.D_branch_op_o			(D_branch_op		),
		.D_store_op_o			(D_store_op		),
		.D_load_op_o			(D_load_op		),
		.D_ALU_op_o			(D_ALU_op		),
		.D_need_dstE_o			(D_need_dstE		),
		.D_sel_reg_o			(D_sel_reg		),
		//data
		.D_rs1_o			(D_rs1			),
		.D_rs2_o			(D_rs2			),
		.D_imme_o			(D_imme			),
		//addr
		.D_dstE_o			(D_dstE			)
	);
	decode decode(
		//in
		.rst				(rst			),
		.clk_i				(clk			),
		.D_rs1_i			(D_rs1			),
		.D_rs2_i			(D_rs2			),
		.MD_need_dstE_i			(MD_need_dstE		),
		.MD_dstE_i			(MD_dstE		),
		.data_i				(W_data			),
		//out
		.D_rs1_data_o			(D_rs1_data		),
		.D_rs2_data_o			(D_rs2_data		)
	);
	fwd fwd(
		.D_rs1_i			(D_rs1			),
		.D_rs2_i			(D_rs2			),
		
		.D_rs1_data_i			(D_rs1_data		),
		.D_rs2_data_i			(D_rs2_data		),
			
		.DD_need_dstE_i			(DD_need_dstE		),
		.DD_dstE_i			(DD_dstE		),
		.E_valE_i			(E_valE			),

		.ED_need_dstE_i			(ED_need_dstE		),
		.ED_dstE_i			(ED_dstE		),
		.ED_sel_reg_i			(ED_sel_reg		),
		.ED_valE_i			(ED_valE		),
		.M_valM_i			(M_valM			),
	
		.MD_need_dstE_i			(MD_need_dstE		),
		.MD_dstE_i			(MD_dstE		),
		.W_data_i			(W_data			),

		.D_fwdA_o(D_fwdA),
		.D_fwdB_o(D_fwdB)
	);
	decode_reg decode_reg(
		//input
		.rst				(rst			),
		.clk_i				(clk			),
		.D_bubble_i			(D_bubble		),
		.D_stall_i			(D_stall		),
		.D_epcode_i			(D_epcode		),
		.D_store_op_i			(D_store_op		),
		.D_load_op_i			(D_load_op		),
		.D_branch_op_i			(D_branch_op		),
		.D_ALU_op_i			(D_ALU_op		),
		.D_sel_reg_i			(D_sel_reg		),
		.D_PC_i				(FD_PC			),
		.D_nPC_i			(FD_nPC			),
		.D_commit_i			(FD_commit		),
		.D_need_dstE_i			(D_need_dstE		),
		.D_dstE_i			(D_dstE			),
		.D_rs1_data_i			(D_fwdA			),
		.D_rs2_data_i			(D_fwdB			),
		.D_imme_i			(D_imme			),
		.D_instr_i			(FD_instr		),
		.D_train_predict_i		(FD_train_predict	),
		.D_train_vaild_i		(FD_train_vaild		),
		.D_train_global_history_i	(FD_train_global_history),
    		.D_train_local_predict_i	(FD_train_local_predict	),
    		.D_train_global_predict_i	(FD_train_global_predict),
			.D_success_hit_i			(FD_success_hit			),
			.D_jal_i					(FD_jal					),
		//output
			.DD_jal_o					(DD_jal					),
			.DD_success_hit_o			(DD_success_hit			),
    		.DD_train_local_predict_o	(DD_train_local_predict	),
    		.DD_train_global_predict_o	(DD_train_global_predict),
		.DD_train_global_history_o	(DD_train_global_history),
		.DD_instr_o			(DD_instr		),
		.DD_train_predict_o		(DD_train_predict	),
		.DD_train_vaild_o		(DD_train_vaild		),
		.DD_epcode_o			(DD_epcode		),
		.DD_store_op_o			(DD_store_op		),
		.DD_load_op_o			(DD_load_op		),
		.DD_branch_op_o			(DD_branch_op		),
		.DD_ALU_op_o			(DD_ALU_op		),
		.DD_sel_reg_o			(DD_sel_reg		),
		.DD_PC_o			(DD_PC			),
		.DD_nPC_o			(DD_nPC			),
		.DD_commit_o			(DD_commit		),
		.DD_need_dstE_o			(DD_need_dstE		),
		.DD_dstE_o			(DD_dstE		),
		.DD_rs1_data_o			(DD_rs1_data		),
		.DD_rs2_data_o			(DD_rs2_data		),
		.DD_imme_o			(DD_imme		)
	);
	//********************************
	//decode
	//********************************
	
	//********************************
	//execute
	//********************************
	execute execute(
		//in
		.DD_rs1_data_i			(DD_rs1_data		),
		.DD_rs2_data_i			(DD_rs2_data		),
		.DD_epcode_i			(DD_epcode		),
		.DD_branch_op_i			(DD_branch_op		),
		.DD_imme_i			(DD_imme		),
		.DD_nPC_i			(DD_nPC			),
		.DD_ALU_op_i			(DD_ALU_op		),
		.DD_PC_i			(DD_PC			),
		.DD_train_predict_i		(DD_train_predict	),
    		.DD_train_local_predict_i	(DD_train_local_predict	),
    		.DD_train_global_predict_i	(DD_train_global_predict),
		//out
		.E_op_jalr_o			(E_op_jalr		),
		.E_valE_o			(E_valE			),
		.E_jmp_o			(E_jmp			),
		.E_nPC_o			(E_nPC			),
		.E_train_local_taken_o		(E_train_local_taken	),
		.E_train_global_taken_o		(E_train_global_taken	),
		.E_train_taken_o		(E_train_taken		)
	);
	execute_reg execute_reg(
		//in
		.rst				(rst			),
		.clk_i				(clk			),
		.DD_dstE_i			(DD_dstE		),
		.DD_need_dstE_i			(DD_need_dstE		),
		.DD_store_op_i			(DD_store_op		),
		.DD_load_op_i			(DD_load_op		),
		.DD_sel_reg_i			(DD_sel_reg		),
		.DD_rs2_data_i			(DD_rs2_data		),
		.DD_PC_i			(DD_PC			),
		.DD_commit_i			(DD_commit		),
		.DD_instr_i			(DD_instr		),
		.E_bubble_i			(E_bubble		),
		.E_stall_i			(E_stall		),
		.E_nPC_i			(E_nPC			),
		.E_valE_i			(E_valE			),
		.E_jmp_i			(E_jmp			),
		.E_train_taken_i		(E_train_taken		),
		.DD_train_predict_i		(DD_train_predict	),
		.DD_train_vaild_i		(DD_train_vaild		),
		.E_op_jalr_i			(E_op_jalr		),
		.DD_train_global_history_i	(DD_train_global_history),
    		.DD_train_local_predict_i	(DD_train_local_predict	),
    		.DD_train_global_predict_i	(DD_train_global_predict),
    		.E_train_local_taken_i		(E_train_local_taken	),
    		.E_train_global_taken_i		(E_train_global_taken	),
			.DD_success_hit_i			(DD_success_hit			),
			.DD_jal_i					(DD_jal					),
		//output
			.ED_jal_o					(ED_jal					),
			.ED_success_hit_o			(ED_success_hit			),
		.ED_train_local_taken_o		(ED_train_local_taken	),
		.ED_train_global_taken_o	(ED_train_global_taken	),
    		.ED_train_local_predict_o	(ED_train_local_predict	),
    		.ED_train_global_predict_o	(ED_train_global_predict),
		.ED_train_global_history_o	(ED_train_global_history),
		.ED_op_jalr_o			(ED_op_jalr		),
		.ED_instr_o			(ED_instr		),
		.ED_PC_o			(ED_PC			),
		.ED_train_predict_o		(ED_train_predict	),
		.ED_train_vaild_o		(ED_train_vaild		),
		.ED_nPC_o			(ED_nPC			),
		.ED_commit_o			(ED_commit		),
		.ED_store_op_o			(ED_store_op		),
		.ED_need_dstE_o			(ED_need_dstE		),
		.ED_dstE_o			(ED_dstE		),
		.ED_load_op_o			(ED_load_op		),
		.ED_sel_reg_o			(ED_sel_reg		),
		.ED_jmp_o			(ED_jmp			),
		.ED_train_taken_o		(ED_train_taken		),
		.ED_rs2_data_o			(ED_rs2_data		),
		.ED_valE_o			(ED_valE		)
	);
	//********************************
	//execute
	//********************************
	memory memory(
		//input
		.clk_i				(clk			),
		.ED_store_op_i			(ED_store_op		),
		.ED_load_op_i			(ED_load_op		),
		.ED_valE_i			(ED_valE		),
		.ED_rs2_data_i			(ED_rs2_data		),
		//output
		.M_valM_o			(M_valM			)
	);
	memory_reg memory_reg(
		//input
		.rst				(rst			),
		.clk_i				(clk			),
		.M_bubble_i			(M_bubble		),
		.M_stall_i			(M_stall		),
		.ED_sel_reg_i			(ED_sel_reg		),
		.ED_valE_i			(ED_valE		),
		.M_valM_i			(M_valM			),
		.ED_need_dstE_i			(ED_need_dstE		),
		.ED_dstE_i			(ED_dstE		),
		.ED_PC_i			(ED_PC			),
		.ED_nPC_i			(ED_nPC			),
		.ED_commit_i			(ED_commit		),
		.ED_instr_i			(ED_instr		),
		.ED_train_taken_i		(ED_train_taken		),
		.ED_train_predict_i		(ED_train_predict	),
		.ED_train_vaild_i		(ED_train_vaild		),
		.ED_train_global_history_i	(ED_train_global_history),
    		.ED_train_local_predict_i	(ED_train_local_predict	),
    		.ED_train_global_predict_i	(ED_train_global_predict),
    		.ED_train_local_taken_i		(ED_train_local_taken	),
    		.ED_train_global_taken_i	(ED_train_global_taken	),
			.ED_success_hit_i			(ED_success_hit			),
			.ED_jal_i					(ED_jal					),
		//output
			.MD_jal_o					(MD_jal					),
			.MD_success_hit_o			(MD_success_hit			),
		.MD_train_local_taken_o		(MD_train_local_taken	),
		.MD_train_global_taken_o	(MD_train_global_taken	),
    		.MD_train_local_predict_o	(MD_train_local_predict	),
    		.MD_train_global_predict_o	(MD_train_global_predict),
		.MD_train_global_history_o	(MD_train_global_history),
		.MD_instr_o			(MD_instr		),
		.MD_train_taken_o		(MD_train_taken		),
		.MD_train_predict_o		(MD_train_predict	),
		.MD_train_vaild_o		(MD_train_vaild		),
		.MD_PC_o			(MD_PC			),
		.MD_nPC_o			(MD_nPC			),
		.MD_commit_o			(MD_commit		),
		.MD_need_dstE_o			(MD_need_dstE		),
		.MD_dstE_o			(MD_dstE		),
		.MD_sel_reg_o			(MD_sel_reg		),
		.MD_valM_o			(MD_valM		),
		.MD_valE_o			(MD_valE		)
	);
	//********************************
	//write_back
	//********************************
	write_back write_back(
		//input
		.MD_instr_i			(MD_instr		),
		.MD_sel_reg_i			(MD_sel_reg		),
		.MD_valM_i			(MD_valM		),
		.MD_valE_i			(MD_valE		),
		//output
		.W_data_o			(W_data			)
	);
	assign commit_pc 	= MD_PC;
	assign commit_pre_pc 	= MD_nPC;
	assign commit 		= MD_commit;
	assign commit_branch = MD_train_vaild;
	assign commit_taken = MD_train_taken & MD_train_vaild;
	assign commit_local_taken = MD_train_vaild & MD_train_local_taken;
	assign commit_global_taken = MD_train_vaild & MD_train_global_taken;
	assign commit_success_hit = MD_success_hit;
	assign commit_predict_jmp = MD_train_predict | MD_jal;
endmodule


