`timescale 1ns / 1ps

//Adds 2 states of clock

module Clock_Counter(count_o, clk);
	
	input clk;
	output reg count_o;
	
	reg [13:0] count;
	
	always @ (posedge clk) begin
		count <= count + 1'b1;
		if (count <= 8192)
			count_o <= 1'b0;
		else
			count_o <= 1'b1;
	end
endmodule
