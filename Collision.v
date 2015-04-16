`timescale 1ns / 1ps

// Calculating the collision properties

module Collision(coll_L, coll_R, coll_T, coll_B, reset, score, 
						x, y, paddle_0, paddle_1, clk, paddlewidth);
    
	input [9:0] x;
	input [8:0] y;
	input [8:0] paddle_0, paddle_1;
	input clk;
	input [5:0] paddlewidth;
	
	output reg coll_L, coll_R, coll_T, coll_B, reset;
	output reg [1:0] score;
	
	always @ (posedge clk) begin
		if (y >= 10 && y <= (480 - 8 - 10) && x >= 40 && x <= (600 - 8)) begin   // Determine if the ball is in criticle are, ie. near a wall or paddle.
			coll_L <= 0;
			coll_R <= 0;
			coll_T <= 0;
			coll_B <= 0;
			reset <= 0;
			score <= 0;
		end
		else begin		//If the ball is in a criticle position:
			if (y <= 10) begin		//If near the ball is at the top set coll_T ==1
				coll_L <= 0;
				coll_R <= 0;
				coll_T <= 1;
				coll_B <= 0;
				reset <= 0;
				score <= 0;
			end
			else if ( y >= (480 - 8 - 10)) begin	//If near the ball is at the botom set coll_B ==1
				coll_L <= 0;
				coll_R <= 0;
				coll_T <= 0;
				coll_B <= 1;
				reset <= 0;
				score <= 0;
			end
			else if (x <= 40) begin	
				if ((y + 8) >= paddle_0 && (y) <= paddle_0 + paddlewidth) begin	//If ball passes the left paddle
					coll_L <= 1;
					coll_R <= 0;
					coll_T <= 0;
					coll_B <= 0;
					reset <= 0;
					score <= 0;
				end
				else begin
					coll_L <= 0;
					coll_R <= 0;
					coll_T <= 0;
					coll_B <= 0;
					reset <= 1;
					score <= 2;		//gives a point to player 2 "10"					
				end
			end
			else if (x >= (600 - 8)) begin
				if ((y + 8) >= paddle_1 && (y) <= paddle_1 + paddlewidth) begin
					coll_L <= 0;
					coll_R <= 1;
					coll_T <= 0;
					coll_B <= 0;
					reset <= 0;
					score <= 0;	
				end
				else begin
					coll_L <= 0;
					coll_R <= 0;
					coll_T <= 0;
					coll_B <= 0;
					reset <= 1;
					score <= 1;		//gives a point to player 1 "01"						
				end
			end
		end
	end
endmodule
