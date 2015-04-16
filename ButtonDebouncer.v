`timescale 1ns / 1ps

//Debouncer for the main control buttons

module ButtonDebouncer(debounced, signal, clk);

    input signal;
    input clk;
    output debounced;
	 
	reg [25:0] delay =26'b0;
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
				debounced = 0;
				if (delay >= 454545) begin
					state = 2'b00;
				end else begin
					delay = delay + 1;
				end
			end
		endcase
	end
endmodule
