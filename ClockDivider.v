`timescale 1ns / 1ps

//Variable game clock divider

module GameClockDivider(clock_out, clock_in, hz);

	 input [10:0] hz;
    input clock_in;

    output clock_out;

	 reg c_out = 1'b0;
	 reg [28:0] count = 29'b0;
	 always @ (posedge clock_in) begin
			count <= count + 1'b1;
			if (count >= 100000000 / hz) begin
				c_out <= c_out + 1'b1;
				count <= 29'b0;
			end
	end
	
	assign clock_out = c_out;

endmodule
