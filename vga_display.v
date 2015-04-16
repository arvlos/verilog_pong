`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Boston University
// Engineer: Zafar M. Takhirov
//
// Modified by: John Moore, Artem Losev
// 
// Create Date:    12:59:40 04/12/2011 
// Design Name: EC311 Support Files
// Module Name:    vga_display 
// Project Name: Lab5 / Lab6 / Project
// Target Devices: xc6slx16-3csg324
// Tool versions: XILINX ISE 13.3
// Description: 
//
// Dependencies: vga_controller_640_60
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module vga_display(R, G, B, HS, VS, 
							rst, clk, invis_switch, count_0, count_1, 
								ball_x, ball_y, score0, score1, winner, paddlewidth);

	input rst;	// global reset
	input clk;	// 100MHz clk
	input [3:0] score0;
	input [3:0] score1;
	input [1:0] winner;
	input [5:0] paddlewidth;
	input invis_switch; 
	
	// Counts for adjusting the positions of the paddles
	input [8:0] count_0, count_1;
	
	// color outputs to show on display (current pixel)
	output reg [2:0] R, G;
	output reg [1:0] B;
	
	// Synchronization signals
	output HS;
	output VS;
	
	// Ball Coordinates
	input [9:0] ball_x;
	input [8:0] ball_y;
	
	// controls:
	wire [10:0] hcount, vcount;	// coordinates for the current pixel
	wire blank;	// signal to indicate the current coordinate is blank
	wire paddle_0;	// the paddles you want to display
	wire paddle_1;
	wire ball;
	wire frame_t, frame_b;
	
	/////////////////////////////////////////////////////
	// Begin clock division
	parameter N = 2;	// parameter for clock division
	reg clk_25Mhz;
	reg [N-1:0] count;
	always @ (posedge clk) begin
		count <= count + 1'b1;
		clk_25Mhz <= count[N-1];
	end
	// End clock division
	/////////////////////////////////////////////////////
	
	// Call driver
	vga_controller_640_60 vc(
		.rst(rst), 
		.pixel_clk(clk_25Mhz), 
		.HS(HS), 
		.VS(VS), 
		.hcounter(hcount), 
		.vcounter(vcount), 
		.blank(blank));
	
	reg [9:0] ssd_0_offset_x = 10;
	reg [9:0] ssd_0_offset_y = 20;
	reg num_0_A = 0;
	reg num_0_B = 0;
	reg num_0_C = 0;
	reg num_0_D = 0;
	reg num_0_E = 0;
	reg num_0_F = 0;
	reg num_0_G = 0;
	reg [6:0] num_0_all = 0;
	reg [9:0] ssd_w_offset_x = 150;
	reg [9:0] ssd_w_offset_y = 230;
	reg [9:0] ssd_i_offset_x = 180;
	reg [9:0] ssd_i_offset_y = 230;
	reg [9:0] ssd_n_offset_x = 190;
	reg [9:0] ssd_n_offset_y = 230;
	reg [9:0] ssd_1_offset_x = 620;
	reg [9:0] ssd_1_offset_y = 20;
	reg num_1_A = 0;
	reg num_1_B = 0;
	reg num_1_C = 0;
	reg num_1_D = 0;
	reg num_1_E = 0;
	reg num_1_F = 0;
	reg num_1_G = 0;
	reg [6:0] num_1_all = 0;
	
	wire ssd_0_A, ssd_0_B, ssd_0_C, ssd_0_D, ssd_0_E, ssd_0_F, ssd_0_G;
	wire ssd_w_1;
	wire ssd_w_2;
	wire ssd_w_3;
	wire ssd_w_4;
	wire ssd_i_1;
	wire ssd_n_1;
	wire ssd_n_2;
	wire ssd_n_3;	
	wire ssd_1_A, ssd_1_B, ssd_1_C, ssd_1_D, ssd_1_E, ssd_1_F, ssd_1_G;


	// Create paddles
	assign paddle_0 = ~blank & (hcount >= 30 & hcount <= 40 & vcount >= count_0 & vcount <= count_0 + paddlewidth);
	assign paddle_1 = ~blank & (hcount >= 600 & hcount <= 610 & vcount >= count_1 & vcount <= count_1 + paddlewidth);
	
	// Create the ball
	assign ball = ~blank & (hcount >= ball_x & hcount <= ball_x + 8 & vcount >= ball_y & vcount <= ball_y + 8);
	
	// Create the borders
	assign frame_t = ~blank & (hcount >= 0 & hcount <= 640 & vcount >= 0 & vcount <= 10);
	assign frame_b = ~blank & (hcount >= 0 & hcount <= 640 & vcount >= 470 & vcount <= 480);
	
	// Create the 7-seg on the left side of the screen
	assign ssd_0_A = ~blank & (hcount >= ssd_0_offset_x & hcount <= ssd_0_offset_x + 12 & vcount >= ssd_0_offset_y & vcount <= ssd_0_offset_y + 3) & ~num_0_A;
	assign ssd_0_B = ~blank & (hcount >= ssd_0_offset_x + 9 & hcount <= ssd_0_offset_x + 12 & vcount >= ssd_0_offset_y & vcount <= ssd_0_offset_y + 10) & ~num_0_B;
	assign ssd_0_C = ~blank & (hcount >= ssd_0_offset_x + 9 & hcount <= ssd_0_offset_x + 12 & vcount >= ssd_0_offset_y + 10 & vcount <= ssd_0_offset_y + 20) & ~num_0_C;
	assign ssd_0_D = ~blank & (hcount >= ssd_0_offset_x & hcount <= ssd_0_offset_x + 12 & vcount >= ssd_0_offset_y + 17 & vcount <= ssd_0_offset_y + 20) & ~num_0_D;
	assign ssd_0_E = ~blank & (hcount >= ssd_0_offset_x & hcount <= ssd_0_offset_x + 3 & vcount >= ssd_0_offset_y + 10 & vcount <= ssd_0_offset_y + 20) & ~num_0_E;
	assign ssd_0_F = ~blank & (hcount >= ssd_0_offset_x & hcount <= ssd_0_offset_x + 3 & vcount >= ssd_0_offset_y & vcount <= ssd_0_offset_y + 10) & ~num_0_F;
	assign ssd_0_G = ~blank & (hcount >= ssd_0_offset_x & hcount <= ssd_0_offset_x + 12 & vcount >= ssd_0_offset_y + 9 & vcount <= ssd_0_offset_y + 12) & ~num_0_G;
	
	// Create the 7-seg on the right side of the screen
	assign ssd_1_A = ~blank & (hcount >= ssd_1_offset_x & hcount <= ssd_1_offset_x + 12 & vcount >= ssd_1_offset_y & vcount <= ssd_1_offset_y + 3) & ~num_1_A;
	assign ssd_1_B = ~blank & (hcount >= ssd_1_offset_x + 9 & hcount <= ssd_1_offset_x + 12 & vcount >= ssd_1_offset_y & vcount <= ssd_1_offset_y + 10) & ~num_1_B;
	assign ssd_1_C = ~blank & (hcount >= ssd_1_offset_x + 9 & hcount <= ssd_1_offset_x + 12 & vcount >= ssd_1_offset_y + 10 & vcount <= ssd_1_offset_y + 20) & ~num_1_C;
	assign ssd_1_D = ~blank & (hcount >= ssd_1_offset_x & hcount <= ssd_1_offset_x + 12 & vcount >= ssd_1_offset_y + 17 & vcount <= ssd_1_offset_y + 20) & ~num_1_D;
	assign ssd_1_E = ~blank & (hcount >= ssd_1_offset_x & hcount <= ssd_1_offset_x + 3 & vcount >= ssd_1_offset_y + 10 & vcount <= ssd_1_offset_y + 20) & ~num_1_E;
	assign ssd_1_F = ~blank & (hcount >= ssd_1_offset_x & hcount <= ssd_1_offset_x + 3 & vcount >= ssd_1_offset_y & vcount <= ssd_1_offset_y + 10) & ~num_1_F;
	assign ssd_1_G = ~blank & (hcount >= ssd_1_offset_x & hcount <= ssd_1_offset_x + 12 & vcount >= ssd_1_offset_y + 9 & vcount <= ssd_1_offset_y + 12) & ~num_1_G;
	
	// The 'WIN' display
	
	// 'W'
	assign ssd_w_1 = (winner != 2'b0) & ~blank & (hcount >= ssd_w_offset_x & hcount <= ssd_w_offset_x + 5 & vcount >= ssd_w_offset_y & vcount <= ssd_w_offset_y + 26);
	assign ssd_w_2 = (winner != 2'b0) & ~blank & (hcount >= ssd_w_offset_x + 5 & hcount <= ssd_w_offset_x + 13 & vcount >= (-1 * hcount + ssd_w_offset_y + ssd_w_offset_x + 26) & vcount <= (-1 * hcount + ssd_w_offset_y + ssd_w_offset_x + 26 + 5));
	assign ssd_w_3 = (winner != 2'b0) & ~blank & (hcount >= ssd_w_offset_x + 13 & hcount <= ssd_w_offset_x + 21 & vcount >= (1 * hcount + ssd_w_offset_y - ssd_w_offset_x) & vcount <= (1 * hcount + ssd_w_offset_y - ssd_w_offset_x + 5));
	assign ssd_w_4 = (winner != 2'b0) & ~blank & (hcount >= ssd_w_offset_x + 21 & hcount <= ssd_w_offset_x + 26 & vcount >= ssd_w_offset_y & vcount <= ssd_w_offset_y + 26);
	
	// 'I'
	assign ssd_i_1 = (winner != 2'b0) & ~blank & (hcount >= ssd_i_offset_x & hcount <= ssd_i_offset_x + 5 & vcount >= ssd_i_offset_y & vcount <= ssd_i_offset_y + 26);

	// 'N'
	assign ssd_n_1 = (winner != 2'b0) & ~blank & (hcount >= ssd_n_offset_x & hcount <= ssd_n_offset_x + 5 & vcount >= ssd_n_offset_y & vcount <= ssd_n_offset_y + 26);
	assign ssd_n_2 = (winner != 2'b0) & ~blank & (hcount >= ssd_n_offset_x + 5 & hcount <= ssd_n_offset_x + 21 & vcount >= (1 * hcount + ssd_n_offset_y - ssd_n_offset_x - 5) & vcount <= (1 * hcount + ssd_n_offset_y - ssd_n_offset_x + 5));
	assign ssd_n_3 = (winner != 2'b0) & ~blank & (hcount >= ssd_n_offset_x + 21 & hcount <= ssd_n_offset_x + 26 & vcount >= ssd_n_offset_y & vcount <= ssd_n_offset_y + 26);
	
	
	// Create the 7-seg display on the screen
	always @ (posedge clk) begin
		case (score0)
			4'b0000: num_0_all = 7'b0000001;
			4'b0001: num_0_all = 7'b1001111;
			4'b0010: num_0_all = 7'b0010010;
			4'b0011: num_0_all = 7'b0000110;
			4'b0100: num_0_all = 7'b1001100;
			4'b0101: num_0_all = 7'b0100100;
			4'b0110: num_0_all = 7'b0100000;
			4'b0111: num_0_all = 7'b0001111;		
			4'b1000: num_0_all = 7'b0000000;
			4'b1001: num_0_all = 7'b0000100;
			default num_0_all = 7'b0000001;
		endcase
		case (score1)
			4'b0000: num_1_all = 7'b0000001;
			4'b0001: num_1_all = 7'b1001111;
			4'b0010: num_1_all = 7'b0010010;
			4'b0011: num_1_all = 7'b0000110;
			4'b0100: num_1_all = 7'b1001100;
			4'b0101: num_1_all = 7'b0100100;
			4'b0110: num_1_all = 7'b0100000;
			4'b0111: num_1_all = 7'b0001111;		
			4'b1000: num_1_all = 7'b0000000;
			4'b1001: num_1_all = 7'b0000100;
			default num_1_all = 7'b0000001;
		endcase
		num_0_A = num_0_all[6];
		num_0_B = num_0_all[5];
		num_0_C = num_0_all[4];
		num_0_D = num_0_all[3];
		num_0_E = num_0_all[2];
		num_0_F = num_0_all[1];
		num_0_G = num_0_all[0];
		num_1_A = num_1_all[6];
		num_1_B = num_1_all[5];
		num_1_C = num_1_all[4];
		num_1_D = num_1_all[3];
		num_1_E = num_1_all[2];
		num_1_F = num_1_all[1];
		num_1_G = num_1_all[0];
	end
	
	// Winner display blocks' coordinates
	always @ (winner) begin
		case (winner)
			2'b01: begin
				ssd_w_offset_x = 150;
				ssd_w_offset_y = 230;
				ssd_i_offset_x = 180;
				ssd_i_offset_y = 230;
				ssd_n_offset_x = 190;
				ssd_n_offset_y = 230;			
			end
			2'b10: begin
				ssd_w_offset_x = 424;
				ssd_w_offset_y = 230;
				ssd_i_offset_x = 454;
				ssd_i_offset_y = 230;
				ssd_n_offset_x = 464;
				ssd_n_offset_y = 230;				
			end
			2'b00: begin
				ssd_w_offset_x = 150;
				ssd_w_offset_y = 230;
				ssd_i_offset_x = 180;
				ssd_i_offset_y = 230;
				ssd_n_offset_x = 190;
				ssd_n_offset_y = 230;					
			end
		endcase
	end
	
	// Send colors
	always @ (posedge clk) begin
		if (paddle_0 || paddle_1) begin	// if you are within the valid region
			R = {invis_switch, invis_switch, invis_switch};
			G = {invis_switch, invis_switch, invis_switch};
			B = {invis_switch, invis_switch};
		end
		else if (ssd_n_1 || ssd_n_2 || ssd_n_3 || ssd_w_1 || ssd_w_2 || ssd_w_3 || ssd_w_4 || ssd_i_1 || ball || frame_t || frame_b || ssd_0_A || ssd_0_B || ssd_0_C || ssd_0_D || ssd_0_E || ssd_0_F || ssd_0_G|| ssd_1_A || ssd_1_B || ssd_1_C || ssd_1_D || ssd_1_E || ssd_1_F || ssd_1_G) begin
			R = 3'b111;
			G = 3'b111;
			B = 2'b11;
		end
		else begin	// if you are outside the valid region
			R = 0;
			G = 0;
			B = 0;
		end
	end

endmodule
