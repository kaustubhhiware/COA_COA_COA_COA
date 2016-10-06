`timescale 1ns / 1ps

module datapath(mplier,mpcand,sig,prd,cnt,out,status,clk
    );
	input [7:0] mplier,mpcand;
	input [2:0] sig;
	output [7:0] cnt;
	input clk;
	input [7:0] prd;
	output [15:0] out;
	output reg [2:0] status;
	reg [7:0] prdin,mplierin,cnt_in,mpcandin;
	wire [7:0] prdout,mplierout,cnt_out,mpcandout;
	reg plin,prd_load,mplier_load,pl_load,cnt_load,mpcand_load;
	reg [1:0] alu_sig;
	wire plout,lbout;
	reg [7:0] aluA,aluB;
	wire [7:0] alu_out,pout,mout,decout;
	//reg ;
	assign cnt = cnt_out;
	assign out = {prdout,mplierout};
	reg8 prd_mod(prdin,prd_load,prdout,clk);
	reg8 mplier_mod(mplierin,mplier_load,mplierout,clk);
	reg8 mpcand_mod(mpcandin,mpcand_load,mpcandout,clk);
	DFF pl(plin,pl_load,plout,clk);
	reg8 cnt_mod(cnt_in,cnt_load,cnt_out,clk);
	alu alu(aluA,aluB,alu_sig,alu_out,clk);
	ahiftrightby2 shr(prdout,mplierout,pout,mout,lbout);
	decrement dec (cnt_out,decout);
	always @ (sig) begin
		if ( sig[2] == 1'b0)
			begin
			alu_sig <= sig[1:0] ;
			aluA <= prdout;
			aluB <= mpcandout;
			prdin <= alu_out;
			prdin <= 1'b1;
			status <= {mplierout[1:0],plout};
			end
		else if (sig[1] == 1'b0)
		begin
			if(sig[0] == 1'b0)
			begin //100 load
				prdin <= prd;
				prd_load <= 1'b1;
				mplierin <= mplier;
				mplier_load <= 1'b1;
				cnt_in <= 8'b00001000;
				cnt_load <= 1'b1;
				mpcandin <= mpcand;
				mpcand_load <= 1'b1;
				plin <= 1'b0;
				pl_load <= 1'b1;
				status <= {mplierout[1:0],plout};
			end
			else begin //101 shift right and dec
				prdin <= pout;
				mplierin <=mout;
				plin <= lbout;
				prd_load <= 1'b1;
				mplier_load <= 1'b1;
				pl_load <= 1'b1;
				cnt_in <= decout;
				cnt_load <= 1'b1;
				status <= {mplierout[1:0],plout};
			end
		end
		else begin //11 
			if(sig[0] == 1'b0) begin //110
				
			end
			else begin //111
				
			end
		end
		
	end
endmodule

