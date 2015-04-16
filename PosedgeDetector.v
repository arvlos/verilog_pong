`timescale 1ns / 1ps

// Posedge detector to deal with 'several posedges in the always block' error

module PosedgeDetector(edgeout, clk, signal);

	input clk;
	input signal;
	
	output edgeout;
	
	wire signal;
	wire edgeout;
	reg signal_d;
 
	always @ (posedge clk) begin
		signal_d <= signal;
	end
	
	assign edgeout = signal & (~signal_d);

endmodule
