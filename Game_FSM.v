`timescale 1ns / 1ps

// THe controlling module for most of the game processes

`define	IDLE			0 //ball does not move (waiting for start of game)
`define	UP_LEFT		1
`define	UP_RIGHT		2
`define	DOWN_RIGHT	4
`define	DOWN_LEFT	8


module GameFSM(ballX, ballY, score1, score2, ballclockout, winner, paddlewidth, gamestate, 
						clk, button0, button1, button2, button3, outofbounds, whoscored,
							coll_L, coll_T, coll_R, coll_B, reset, varyballspeed);
	input clk;
	input button0;
	input button1;
	input button2;
	input button3;
	input outofbounds;
	input [1:0] whoscored;
	input coll_L;
	input coll_T;
	input coll_R;
	input coll_B;
	input reset;
	input varyballspeed;
	
	output [9:0] ballX;
	output [8:0] ballY;
	output [3:0] score1;
	output [3:0] score2;
	output ballclockout;
	output [1:0] winner;
	output [5:0] paddlewidth;
	output [3:0] gamestate;
	
	reg [3:0] score1reg = 4'b0;
	reg [3:0] score2reg = 4'b0;
	reg [3:0] state = 4'b0;
	wire ballclock;
	reg startgamereg = 1'b0;
	reg [9:0] ballXreg = 10'b0;
	reg [8:0] ballYreg = 9'b0;
	reg stopgame = 1'b0;	
	reg [10:0] hz =  150;
	reg gameover = 1'b0;
	wire startgame;
	wire outofbounds_debounced;
	wire [3:0] Qout;
	reg [1:0] winnereg = 2'b00;
	reg [5:0] paddlewidthreg = 40;
	reg [10:0] hzreg = 150;
	
	GameClockDivider CD(ballclock, clk, hzreg);
	
	Debouncer250ms D(startgame, startgamereg, clk);
	Debouncer500ms OOB(outofbounds_debounced, outofbounds, clk);
	ShiftReg r1 (Qout, ballclock);
	
	always @ (button0 or button1 or button2 or button3 or state) begin
		if (state == `IDLE && (button0 || button1 || button2 || button3) && gameover == 1'b0) begin //a paddle was moved, so set startgame to 1 (only important if state is IDLE) 
			startgamereg = 1'b1;
		end 
		else begin
			startgamereg = 1'b0;
		end
	end
	
	always @ (varyballspeed) begin
		if (varyballspeed && hz <= 250) begin
			hzreg = hz;
		end
		else if (varyballspeed) begin
			hzreg = 250;
		end
		else begin
			hzreg =  150;
		end
	end
		
	always @ (posedge ballclock or posedge outofbounds_debounced or posedge reset) begin
		if (reset) begin
			score1reg <= 0;
			score2reg <= 0;
			gameover = 1'b0;
			stopgame = 1'b0;
			hz <=  150;
			state = `IDLE;
			winnereg = 2'b00;
			paddlewidthreg <= 40;
		end
		else if (gameover == 1'b1) begin
			stopgame = 1'b1;
			hz <= 150;
			state = `IDLE;
			ballXreg <= 316; //640/2 = 320 (center of screen), minus 4 (half of width of ball) gives top left coordinate of ball
			ballYreg <= 236; //again, relative to top left
			if (score1reg > 8) begin
				winnereg = 2'b01;
			end
			else if (score2reg > 8) begin
				winnereg = 2'b10;
			end
		end
		else if (outofbounds_debounced) begin //collision detector says someone scored, so stop game on next ballclock posedge
			stopgame = 1'b1;
			if (score1reg > 8) begin
				winnereg = 2'b01;
			end
			else if (score2reg > 8) begin
				winnereg = 2'b10;
			end
		end 
		else begin
			if (score1reg > 8) begin
				winnereg = 2'b01;
			end
			else if (score2reg > 8) begin
				winnereg = 2'b10;
			end
			if (stopgame == 1'b1) begin //somebody scored!
				stopgame = 1'b0;
				if (whoscored[0] == 1'b1 && score1reg < 9 && gameover == 1'b0) begin
					score1reg <= score1reg + 1;
					if (paddlewidthreg >= 18) begin
						paddlewidthreg <= paddlewidthreg - 2;
					end
				end 
				else if (whoscored[1] == 1'b1 && score1reg < 9 && gameover == 1'b0) begin
					score2reg <= score2reg + 1;
					if (paddlewidthreg >= 18) begin
						paddlewidthreg <= paddlewidthreg - 2;
					end
				end
				if (score1reg > 8 || score2reg > 8) begin
					gameover = 1'b1;
				end
				ballXreg <= 316; //640/2 = 320 (center of screen), minus 4 (half of width of ball) gives top left coordinate of ball
				ballYreg <= 236; //again, relative to top left
				state = `IDLE;
			end 
			else begin
				case (state)
						`IDLE: begin //ball is waiting for game to begin
							//Center ball on screen
							ballXreg <= 316; //640/2 = 320 (center of screen), minus 4 (half of width of ball) gives top left coordinate of ball
							ballYreg <= 236; //again, relative to top left
							if (startgame == 1'b1 && gameover == 1'b0 && score1reg < 9 && score2reg < 9) begin //a paddle was moved since the last score, so start moving ball
								state = Qout; //random first position
							end 
							else begin
								state = `IDLE;
							end
						end
						`UP_LEFT: begin
							ballXreg <= ballXreg - 2;
							ballYreg <= ballYreg - 1;
							if (coll_T) begin
								state = `DOWN_LEFT;
							end 
							else if (coll_L) begin
								state = `UP_RIGHT;
								hz <= hz + 10;
							end 
							else begin
								state = `UP_LEFT;
							end							
						end
						`UP_RIGHT: begin
							ballXreg <= ballXreg + 2;
							ballYreg <= ballYreg - 1;
							state = `UP_RIGHT;
							if (coll_T) begin
								state = `DOWN_RIGHT;
							end 
							else if (coll_R) begin
								state = `UP_LEFT;
								hz <= hz + 10;
							end 
							else begin
								state = `UP_RIGHT;
							end							
						end
						`DOWN_RIGHT: begin
							ballXreg <= ballXreg + 2;
							ballYreg <= ballYreg + 1;
							state = `DOWN_RIGHT;
							if (coll_B) begin
								state = `UP_RIGHT;
							end 
							else if (coll_R) begin
								state = `DOWN_LEFT;
								hz <= hz + 10;
							end 
							else begin
								state = `DOWN_RIGHT;
							end							
						end				
						`DOWN_LEFT: begin
							ballXreg <= ballXreg - 2;
							ballYreg <= ballYreg + 1;
							state = `DOWN_LEFT;
							if (coll_B) begin
								state = `UP_LEFT;
							end 
							else if (coll_L) begin
								state = `DOWN_RIGHT;
								hz <= hz + 10;
							end 
							else begin
								state = `DOWN_LEFT;
							end							
						end			
				endcase
			end
		end
	end
	
	assign ballX = ballXreg;
	assign ballY = ballYreg;
	assign score1 = score1reg;
	assign score2 = score2reg;
	assign ballclockout = ballclock;
	assign winner = winnereg;
	assign paddlewidth = paddlewidthreg;
	assign gamestate = state;
	
endmodule
