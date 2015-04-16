`timescale 1ns / 1ps

//LED Driver for the Pong Project

module LED_Driver(LED, AN, num_0, num_1, count);
 
	input count;
	input [3:0] num_0, num_1;
	output reg [6:0] LED;
	output reg [3:0] AN;
	reg [3:0] led_num;
		
		
	// Switching between LEDs
	always @ * begin
		case (count)
			1'b0: begin
				led_num <= num_0;
				AN = 4'b0111;
			end
						
			1'b1: begin
				led_num <= num_1;
				AN = 4'b1110;
			end
		endcase
	end
	

	// Driver
	always @ * begin
		case (led_num)
			4'b0000: LED = 7'b0000001;
			4'b0001: LED = 7'b1001111;
			4'b0010: LED = 7'b0010010;
			4'b0011: LED = 7'b0000110;
			4'b0100: LED = 7'b1001100;
			4'b0101: LED = 7'b0100100;
			4'b0110: LED = 7'b0100000;
			4'b0111: LED = 7'b0001111;		
			4'b1000: LED = 7'b0000000;
			4'b1001: LED = 7'b0000100;
			default LED = 7'b0000001;
		endcase
	end
	
endmodule
