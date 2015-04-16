`timescale 1ns / 1ps

//The Counter to track the position of the paddles

module ButtonCounter(countout, btn_0, btn_1, reset, clk, num_0, num_1, paddlewidth);

	input btn_0, btn_1, reset, clk;
	input [3:0] num_0, num_1;
	output [8:0] countout;	
	reg [8:0] count = 9'b011011100;
	wire btn_0_edge, btn_1_edge;
	input [5:0] paddlewidth;
	wire reset_debounced;
	
	PosedgeDetector p1(btn_0_edge, clk, btn_0);
	PosedgeDetector p2(btn_1_edge, clk, btn_1);
	Debouncer250ms d1(reset_debounced, reset, clk);
	
	always @ (posedge clk) begin
		if (reset_debounced || num_0 > 8 || num_1 > 8) begin
			count <= 9'b011011100;
		end else if (btn_0_edge && count >= 10 && count <= 470 - paddlewidth) begin
			count <= count + 9'b111111111;
		end else if (btn_1_edge && count <= 470 - paddlewidth && count >= 10) begin
			count <= count + 9'b000000001;
		end else if (count < 10) begin
			count <= 10;
		end else if (count > 470 - paddlewidth) begin
			count <= 470 - paddlewidth;
		end else begin
			count <= count;
		end
	end
	
	assign countout = count;

endmodule
