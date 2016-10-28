`timescale 1ns / 1ps

module controller(operationcode, wpc, rpc, rm, wmem, wmar, rmar, 
wmdr, rmdr, in_mdr1, in_mdr2, out_mdr1, out_mdr2, wir, inReg, wReg,
rReg,wt, rt, rc1, aluOp, ldF, state, next_state);

	input [4:0] state;
	output [4:0] next_state;
	input [6:0]operationcode;
	output wpc, rpc, rm, wmem, wmar, rmar, wmdr, rmdr;
	output in_mdr1, in_mdr2, out_mdr1, out_mdr2, wir,  wReg, rReg,wt;
	output rt, rc1, ldF;
	output [1:0] inReg1, inReg2;
	output [2:0] aluOp;

	assign wpc = 1'b0;
	assign rpc= 1'b0;
	assign rm= 1'b0;
	assign wmem= 1'b0; 
	assign wmar = 1'b0; 
	assign rmar= 1'b0; 
	assign wmdr= 1'b0; 
	assign rmdr= 1'b0;
	assign in_mdr1= 1'bz; 
	assign in_mdr2= 1'bz; 
	assign out_mdr1= 1'bz; 
	assign out_mdr2= 1'bz; 
	assign wir = 1'b0; 
	assign inReg = 2'b00;
	assign wReg= 1'b0; 
	assign rReg= 1'b0;
	assign wt= 1'b0; 
	assign rt= 1'b0; 
	assign rc1 = 1'b0; 
	assign aluOp = 3'b101;
	assign ldF = 1'b0;

	always@(*)
	begin
		casex(state)
		5'b00000:

			rpc = 1'b1;rm = 1'b1;
			wir = 1'b1;wt = 1'b1;
			next_state = 5'b00001;

		5'b00001:

			rc1 = 1'b1;rt = 1'b1;
			aluOp = '3'b000;
			wpc = 1'b1;
			always@(operationcode)
			begin
				casex(operationcode[6:5])

				2'b00 :
					begin
					if(operationcode[4:1] == 4'b1110)
						next_state = 5'b10001;
					else
						next_state = 5'b00100;
					end

				2'b01 :
					if(operationcode[4:2] == 3'b000 or operationcode[4:2] = 3'b111)
						next_state = 5'b00010;
					else 
						next_state = 5'b00100;

				2'b10 :
					next_state = 5'b10001;

				2'b11 :
					begin
					if(operationcode[0] == 1'b0)
						next_state = 5'b11000;
					else 
						next_state = 5'b11100;
					end
			end 

		5'b00010:

			inReg  = 2'b00;	rReg = 1'b1;
			wt  = 1'b1;
			always@(operationcode)
			begin 
			if(operationcode[4:2] == 111)
				next_state = 5'b00011;
			else 
				next_state = 5'b01101;
			end

		5'b00011:

			inReg = 2'b01;	rReg = 1'b1;
			aluOp = 3'b000;
			wReg = 1'b1;
			next_state =5'b00000;

		5'b00100:

			in_mdr2 = 1'b1;rpc =1'b1;rm = 1'b1;
			wmdr =1'b1;
			next_state = 5'b00101;

		5'b00101:

			inReg = 2'b01;rReg =1'b1;
			wt = 1'b1;
			always@(operationcode)
			begin
			if(operationcode[6:5] == 01)
				next_state = 5'b00110;
			else
				next_state = 5'b01011;
			end 

		5'b00110:

			rt =1'b1;rmdr = 1'b1;
			wmar 1'b1; out_mdr1 = 1'b1;
			aluOp = 3'b000;

		5'b00111:

			in_mdr2 = 1'b1;rmar = 1'b1;rm =1'b1;
			wmdr =1'b1;
			next_state = 5'b01000;

		5'b01000:

			inReg = 2'b00; rReg = 1'b1;
			wt =1'b1;
			next_state = 5'b01001;

		5'b01001:

			rmdr =1'b1;
			out_mdr1 =1'b1;
			aluOp = 3'b000;
			rt =1'b1;
			wReg = 1'b1;
			next_state = 5'b00000;

		5'b01010:

			rmdr =1'b1;
			out_mdr1 = 1'b1;
			wmar =1'b1;
			
		5'b01011:

			rpc = 1'b1;
			wmar =1'b1;
			always@(operationcode)
			begin
			if(operationcode[6:5] == 2'b00)
				begin
				if(operationcode[1] == 1'b0)
					next_state = 5'b10101;
				else 
					next_state = 5'b10110;
				end
			else
				next_state = 5'b01100;
			end

		5'b01100:

			in_mdr2 = 1'b1;rmar =1'b1; rm = 1'b1;
			wmdr =1'b1;
			always@(operationcode)
			begin
			if(operationcode[6:5] == 2'b01)
				begin
				if(operationcode[4:2] == 3'b000)
					next_state = 5'b00010;
				else 
					next_state = 5'b01101;
				end
			else
				begin
				if(operationcode[6:1] == 5'b00100)
					next_state = 5'b01010;
				else
					next_state = 5'b10010;
				end
			end

		5'b01101:
			in_mdr1 = 1'b1;rmdr = 1'b1; rt = 1'b1;
			wmdr = 1'b1;
			aluOp = 3'b000;
			next_state = 5'b01110;

		5'b01110:

			inReg = 2'b01; rReg = 1'b1;
			wt =1'b1;
			next_state = 5'b01111;

		5'b01111:

			rmdr =1'b1; rt = 1'b1;
			wmar =1'b1;
			aluOp = 3'b000;
			out_mdr1 = 1'b1;
			always@(operationcode)
			begin
			if(operationcode[6:5] == 2'b00)
				begin
				if(operationcode[4:2]== 3'b001)
					begin
					if(operationcode[1] == 1'b0)
						next_state = 5'b01100;
					else 
						next_state = 5'b11010;
					end
				else
					next_state = 5''b10011;
				end
			else
				next_state = 5'b10000;
			end

		5'b10000:

			
			in_mdr2 =1'b1;inReg = 2'b00;rm = 1'b1;rmar =1'b1;rReg = 1'b1;
			wt = 1'b1;	wmdr =1'b1;
			always@(operationcode)
			begin
			if(operationcode[6:2] == 5'b01100)
				next_state = 5'b01010;
			else 
				next_state = 5'b01001;
			end

		5'b10001:

			inReg = 2'b01;in_mdr1 = 1'b1;rReg =1'b1;
			wmdr =1'b1;
			next_state = 5'b10010;

		5'b10010:

			rmdr = 1'b1;
			wReg = 1'b1;
			out_mdr1 = 1'b1;
			next_state =5'b00000;

		5'b10011:

			rmar =1'b1;
			wt =1'b1;
			next_state = 5'b10100;

		5'b10100:

			inReg = 2'b01; rt =1'b1; rReg = 1'b1;
			wmar =1'b1;
			aluOp = 3'b000;
			next_state = 5'b01100;

		5'b10101:

			inReg = 2'b01; rmar =1'b1; rm = 1'b1; rt =1'b1;	rReg = 1'b1;
			wmdr = 1'b1;
			next_state = 5'b00000;

		5'b10110:
			in_mdr2 = 1'b1; rmar 1'b1; rm =1'b1;
			wmdr = 1'b1;
			always@(*)
			begin
				if(operationcode[6] == 1)
					next_state = 5'b11001;
				else 
					next_state = 5'b10111;
			end

		5'b10111:
			inReg = 2'b00; rReg = 1'b1;
			wt =1'b1;
			next_state = 5'b00000;

		5'b11000:
			
			rpc = 1'b1;
			wt = 1'b1; wmar = 1'b1;
			next_state = 5'b10110;

		5'b11001:

			
			rmdr =1'b1; rt = 1'b1;
			wpc = 1'b1; out_mdr1 = 1'b1;
			aluOp = 3'b000;
			next_state = 5'b11101;

		5'b11010:
			
			in_mdr1 = 1'b1; inReg = 2'b01; rReg = 1'b1;
			wmdr = 1'b1;

		5'b11011:

			rmdr = 1'b1; rmar = 1'b1;
			wmem = 1'b1; out_mdr2 = 1'b1;
			next_state = 5'b0000;

		5'b11100:

			inReg = 2'b00; rReg =1'b1;
			wpc =1'b1;
			next_state = 5'b00000;

		5'b11101:
			
			rpc = 1'b1;
			wt = 1'b1;
			next_state = 5'b11110;

		5'b11110:
			rc1 =1'b1; rt = 1'b1;
			wReg = 1'b1;
			aluOp = 3'b000;
			next_state = 5'b00000;
		end

endmodule