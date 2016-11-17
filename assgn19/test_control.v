`timescale 1ns / 1ps

module test_alu_control;
	// Inputs
	reg [15:0] ALUSrc1;
	reg [15:0] ALUSrc2;
	reg [2:0] ALUCtrl;
	// Outputs
	wire [15:0] ALUResult;
	wire Zero;
	// Instantiate the Unit Under Test (UUT)
	ALU_Core uut (
		.ALUSrc1(ALUSrc1), 
		.ALUSrc2(ALUSrc2), 
		.ALUCtrl(ALUCtrl), 
		.ALUResult(ALUResult), 
		.Zero(Zero)
	);
	initial begin
		// Initialize Inputs
		ALUSrc1 = 16'b0000000000001100;
		ALUSrc2 = 16'b1000000000001010;
		ALUCtrl = 0;//and
		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		ALUSrc1 = 16'b0000000000001100;
		ALUSrc2 = 16'b0000000000001010;
		ALUCtrl = 3'b111;//slt
		
		#100;
		ALUSrc1 = 16'b0000000000001100;
		ALUSrc2 = 16'b0000000000001010;
		ALUCtrl = 3'b110;//sub
		
		#100;

	end
endmodule


module test_control;

	// Inputs
	reg [31:0] inst;

	// Outputs
	wire [4:0] controlALU;
	wire writeOut;
	wire [1:0] RegWrite;
	wire AluOP;
	wire readDataMem;
	wire writeDataMem;
	wire [1:0] sizeDataMem;
	wire jal;
	wire jalr;

	// Instantiate the Unit Under Test (UUT)
	controller uut (
		.inst(inst),	
		.controlALU(controlALU), 
		.writeOut(writeOut), 
		.RegWrite(RegWrite), 
		.AluOP(AluOP), 
		.readDataMem(readDataMem), 
		.WriteDataMem(writeDataMem), 
		.sizeDataMem(sizeDataMem), 
		.jal(jal), 
		.jalr(jalr) 
	);
	
	reg [31:0] test [9:0];
	integer i;
	
	initial begin
		// Initialize Inputs
		inst = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here	
		test[0] = 32'h80000037;// lui
		test[1] = 32'h80000017;// alu pc
		test[2] = 32'h8020006F;// jal
		test[3] = 32'h80000067;// jalr
		test[4] = 32'h800000E3;// beq
		test[5] = 32'h80000003;// lb
		test[6] = 32'h80000823;// sb
		test[7] = 32'h80003013;// alu i tpye
		test[8] = 32'h41005013;// shift
		test[9] = 32'h00000000;// null state
		
		$display ("Output for control signals \n");
		
		// test individually for each test case				
		for(i=0; i<10; i = i+1) begin
			inst = test[i];
			//delay
			#5;
			$display ("Input Instruction : %x \n\
controlALU : %b, writeOut : %b, RegWrite : %b, AluOP : %b, readDataMem : %b, \
writeDataMem : %b, sizeDataMem : %b, jal : %b, jalr : %b\n", inst, controlALU, writeOut, 
				RegWrite, AluOP, readDataMem, writeDataMem, sizeDataMem, jal, jalr);
		end
	end
endmodule

