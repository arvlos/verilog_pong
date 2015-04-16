`timescale 1ns / 1ps

// A shift register to determine the initial random direction for the ball
// Serves to generate random one-hot encoding

module ShiftReg(Qout, clk);

	input clk;
	output [3:0] Qout;
	reg [3:0] Q = 4'b0001;

	always @ (posedge clk) begin
		Q[3]<=Q[0];
		Q[2]<=Q[3];
		Q[1]<=Q[2];
		Q[0]<=Q[1];
	end

	assign Qout = Q;

endmodule
