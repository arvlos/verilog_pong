`timescale 1ns / 1ps

//Clock for AI paddle

module Clock220(clock_out, clock_in);

    input clock_in;
    output clock_out;

	 reg c_out = 1'b0;
	 reg [25:0] count = 26'b0;
	 always @ (posedge clock_in) begin
			count <= count + 1'b1;
			if (count >= 227272) begin //same speed as human paddle
				c_out <= c_out + 1'b1;
				count <= 26'b0;
			end
	end
	assign clock_out = c_out;
endmodule

