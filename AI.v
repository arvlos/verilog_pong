`timescale 1ns / 1ps

`define	IDLE			0 //ball does not move (waiting for start of game)
`define	UP_LEFT		1
`define	UP_RIGHT		2
`define	DOWN_RIGHT	4
`define	DOWN_LEFT	8


// Sets position of AI paddle based on game state and ball position
// Randomly misses some of the time; doesn't always hit in center of paddle

module AI(comppos, ball_x, ball_y, clk, paddlewidth, gamestate, enabled, outofbounds);

	input [9:0] ball_x;
	input [8:0] ball_y;
	input clk;
	input [5:0] paddlewidth;
	input [3:0] gamestate;
	input enabled;
	input outofbounds;
	
	output [8:0] comppos;
	
	wire gs1_edge;
	wire gs2_edge;
	wire oob_edge;
	wire clock220;
	
	reg [8:0] aipos = 9'b011011100;
	reg hitreg = 1'b0;
	reg [1:0] noise = 2'b0;
	reg [6:0] count;
	reg debounced = 1'b0;
	
	PosedgeDetector p1(gs1_edge, clk, gamestate[0]);
	PosedgeDetector p2(gs2_edge, clk, gamestate[3]);
	PosedgeDetector p3(oob_edge, clk, outofbounds);
	
	//Random generation of whether or not to hit the ball, and where to hit it on the paddle
	always @ (posedge clk) begin
		if (gs1_edge || gs2_edge || oob_edge) begin
			if (count >= 100 && ~oob_edge) begin
				hitreg = 0; //miss ball
			end
			else begin
				hitreg = 1; //hit ball
			end
			if (count[0]) begin
				noise = 0; //hit in center
			end
			else begin
				noise = 1; //hit on edge
			end
		end
	end
	
	Clock220(clock220, clk);
	
	always @ (posedge clock220) begin
		count <= count + 1;
		if (ball_x < 320 && (gamestate == `UP_LEFT || gamestate == `DOWN_LEFT) && enabled && hitreg) begin 
			if (ball_y - paddlewidth/4 * noise  + 6 > aipos && aipos - (paddlewidth/2) <= 470 - paddlewidth) begin
				aipos <= aipos + 1;
			end
			else if (ball_y + paddlewidth/4 * noise - 6 < aipos && aipos - (paddlewidth/2) > 10) begin
				aipos <= aipos - 1;
			end
		end
		else if (ball_x < 320 && (gamestate == `UP_LEFT || gamestate == `DOWN_LEFT) && enabled && ~hitreg) begin
			if ((paddlewidth/2 + 10 > ball_y) || (ball_y - paddlewidth/2 - 10 > aipos && aipos - (paddlewidth/2) <= 470 - paddlewidth)) begin
				aipos <= aipos + 1;
			end
			else if (ball_y + paddlewidth/2 + 10 < aipos && aipos - (paddlewidth/2) > 10) begin
				aipos <= aipos - 1;
			end		
		end
		else begin
			if (240 > aipos && aipos - (paddlewidth/2) <= 470 - paddlewidth) begin
				aipos <= aipos + 1;
			end
			else if (240 < aipos && aipos - (paddlewidth/2) > 10) begin
				aipos <= aipos - 1;
			end		
		end
	end
	
	assign comppos = aipos - (paddlewidth / 2);

endmodule
