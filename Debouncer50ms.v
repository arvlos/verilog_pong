`timescale 1ns / 1ps

// Holds signal at 1 for 50 ms (a slight modification to the traditional debouncer)

module Debouncer50ms(signal, clk, debounced);
    input signal;
    input clk;
    output debounced;
	 
	reg [25:0] delay = 26'b0;
	reg [1:0] state = 2'b00;
	reg debounced = 1'b0;
	
	always @ (posedge clk) begin
		case (state)
			2'b00: begin
				if (signal) begin
					state = 2'b01;
				end
				debounced = 0;
				delay = 26'b0;
			end
			2'b01: begin
				debounced = 1;
				state = 2'b10;
			end
			2'b10: begin
				if (delay >= 5000000) begin
					state = 2'b00;
				end else begin
					delay = delay + 1;
				end
			end
		endcase
	end
endmodule
