`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Boston University
// Engineers: Artem Losev, John Moore, Kevin Smith
// 
//
// Create Date:   15:31:06 11/28/2012 
// Module Name:   Main 
// Project Name: 	Pong Game (EC 311 Design Project)
// Target Devices: Spartan 6 XC6SLX16 CSG 324
// Tool versions: XILINX ISE 13.3
// Description: Reincarnation of the classic Pong game implemented using the FPGA and Verilog
//
//
// Revision 0.01 - File Created.
//				0.02 - Speed Increased After Each Collision with the paddle;
//							Borders Added.
//				0.03 - Random Initial Direction Added;
//							Additional Extensive Bug Fixes
//				0.04 - Added Score Display
//				0.05 - Added AI mode
//				0.06 - Added winner display on screen
//				0.07 - Added variable paddle size
//				0.08 - Added stochastic noise and random hit percentage to AI; added max ball speed and minimum paddle size;
//          0.09 - Added switch for variable ball speed; calibrated speeds, clocks, etc.
//				1.00 - The Demonstration Version !!!
//
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////


module Main(LED, AN, R, G, B, HS, VS, 
					reset, clk, i_0, i_1, i_2, i_3, AI_switch, invis_switch, paddlesize_switch, ballspeed_switch);

	input i_0, i_1, i_2, i_3, clk, reset;
	input AI_switch;
	input paddlesize_switch;
	input ballspeed_switch;
	input invis_switch;
	
	output [2:0] R, G;
	output [1:0] B;
	output HS;
	output VS;
	output [6:0] LED;
	output [3:0] AN;
	
	wire btn_0, btn_1, btn_2, btn_3;
	wire [8:0] count_1, count_0_player;
	wire [3:0] num_0, num_1;
	wire clk_new;
	wire [9:0] ball_x;
	wire [8:0] ball_y;
	wire ball_clk;
	wire [1:0] who_scored;
	wire coll_L, coll_R, coll_T, coll_B;
	wire outofbounds;
	wire [8:0] comppos;
	wire [1:0] winner;
	wire [5:0] variablepaddlewidth;
	wire [3:0] gamestate;
	reg [8:0] count_0;
	reg [5:0] paddlewidth;
	
	// Inputing the data to the VGA controller
	vga_display v0 (R, G, B, HS, VS, 
							reset, clk, invis_switch, count_0, count_1, 
								ball_x, ball_y, num_0, num_1, winner, paddlewidth);

	AI complayer(comppos, ball_x, ball_y, clk, paddlewidth, gamestate, AI_switch, outofbounds);
	
	always @ * begin
		if (AI_switch) begin
			count_0 = comppos;
		end else begin
			count_0 = count_0_player;
		end
		if (paddlesize_switch) begin
			if (variablepaddlewidth >= 16) begin
				paddlewidth = variablepaddlewidth;
			end else begin
				paddlewidth = 16;
			end
		end else begin
			paddlewidth = 40;
		end
	end
	
	// Debouncing the buttons from the input
	ButtonDebouncer d0 (btn_0, i_0, clk);
	ButtonDebouncer d1 (btn_1, i_1, clk);
	ButtonDebouncer d2 (btn_2, i_2, clk);
	ButtonDebouncer d3 (btn_3, i_3, clk);
	
	// Adjusting the position of the paddle
	ButtonCounter b0 (count_0_player, btn_0, btn_1, reset, clk, num_0, num_1, paddlewidth);
	ButtonCounter b1 (count_1, btn_2, btn_3, reset, clk, num_0, num_1, paddlewidth);
	
	
	// Clock Counter
	Clock_Counter c0 (count_clk, clk);
	
	// LED
	LED_Driver l0 (LED, AN, num_0, num_1, count_clk);
	
	// Keeps track of ball position and score
	GameFSM g0 (ball_x, ball_y, num_0, num_1, ball_clk, winner, variablepaddlewidth, gamestate, 
					clk, btn_0, btn_1, btn_2, btn_3, outofbounds, who_scored,
						coll_L, coll_T, coll_R, coll_B, reset, ballspeed_switch);
	
	//Detects colissions and scoring
	Collision c1(coll_L, coll_R, coll_T, coll_B, outofbounds, who_scored, 
						ball_x, ball_y, count_0, count_1, ball_clk, paddlewidth);
	
	
endmodule
