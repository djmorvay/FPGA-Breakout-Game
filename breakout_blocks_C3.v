//----------------------------------//
// Breakout Files
// breakout_blocks_C3.v
// David J. Morvay
// ECEN 4856
// Fall 2020
//----------------------------------//
module breakout_blocks_C3 (clk, reset, pix_x, pix_y, ball_x_r, ball_x_l, ball_y_t, ball_y_b, moveU, moveD, moveL, moveR, C3_count, C3_ON);
input clk, reset;
input [10:0] pix_x, pix_y, ball_x_r, ball_x_l, ball_y_t, ball_y_b;
output moveU, moveD, moveL, moveR;
output [5:0] C3_count;
output C3_ON;

// Top, bottom, left, right side of block registers
reg moveU, moveD, moveL, moveR;
reg b0R, b0L, b0D;
reg b1R, b1L, b1U, b1D;
reg b2R, b2L, b2U, b2D;
reg b3R, b3L, b3U, b3D;
reg b4R, b4L, b4U, b4D;
reg b5R, b5L, b5U, b5D;
reg b6R, b6L, b6U, b6D;
reg b7R, b7L, b7U;

reg [7:0] blocks_C3;
initial blocks_C3 = 8'b11111111;

// Signals to turn blocks on
assign block_C3_R0 = ((4 <= pix_y) && (76 >= pix_y) && (80 <= pix_x) && (95 >= pix_x) && (blocks_C3[0] == 1));
assign block_C3_R1 = ((78 <= pix_y) && (150 >= pix_y) && (80 <= pix_x) && (95 >= pix_x) && (blocks_C3[1] == 1));
assign block_C3_R2 = ((152 <= pix_y) && (224 >= pix_y) && (80 <= pix_x) && (95 >= pix_x) && (blocks_C3[2] == 1));
assign block_C3_R3 = ((226 <= pix_y) && (298 >= pix_y) && (80 <= pix_x) && (95 >= pix_x) && (blocks_C3[3] == 1));
assign block_C3_R4 = ((300 <= pix_y) && (372 >= pix_y) && (80 <= pix_x) && (95 >= pix_x) && (blocks_C3[4] == 1));
assign block_C3_R5 = ((374 <= pix_y) && (446 >= pix_y) && (80 <= pix_x) && (95 >= pix_x) && (blocks_C3[5] == 1));
assign block_C3_R6 = ((448 <= pix_y) && (520 >= pix_y) && (80 <= pix_x) && (95 >= pix_x) && (blocks_C3[6] == 1));
assign block_C3_R7 = ((522 <= pix_y) && (595 >= pix_y) && (80 <= pix_x) && (95 >= pix_x) && (blocks_C3[7] == 1));

// x - Parameters for this column of blocks
localparam right_border = 95;
localparam right_border_in = 92;
localparam left_border = 80;
localparam left_border_in = 83;
localparam right_ext = 102;
localparam left_ext = 73;

// Counters for score
reg counter0, counter1, counter2, counter3, counter4, counter5, counter6, counter7;

// Board reset
// If a block has been hit, it will turn off the block, and increment the score
always @(posedge clk)
	if (reset) begin
		blocks_C3 = 8'b11111111;
		counter0 = 0; counter1 = 0; counter2 = 0; counter3 = 0;
		counter4 = 0; counter5 = 0; counter6 = 0; counter7 = 0; 
	end
	else if (b0R || b0L || b0D) begin
		counter0 = 1;
		blocks_C3[0] = 0;
	end
	else if (b1R || b1L || b1U || b1D) begin
		counter1 = 1;
		blocks_C3[1] = 0;
	end
	else if (b2R || b2L || b2U || b2D) begin
		counter2 = 1;
		blocks_C3[2] = 0;
	end
	else if (b3R || b3L || b3U || b3D) begin
		counter3 = 1;
		blocks_C3[3] = 0;
	end
	else if (b4R || b4L || b4U || b4D) begin
		counter4 = 1;
		blocks_C3[4] = 0;
	end
	else if (b5R || b5L || b5U || b5D) begin
		counter5 = 1;
		blocks_C3[5] = 0;
	end
	else if (b6R || b6L || b6U || b6D) begin
		counter6 = 1;
		blocks_C3[6] = 0;
	end
	else if (b7R || b7L || b7U) begin
		counter7 = 1;
		blocks_C3[7] = 0;
	end
	
// If any block is hit, the signal is sent here to
// determine the direction the ball should be redirected.
always @(posedge clk)
	if (b0R || b1R || b2R || b3R || b4R || b5R || b6R || b7R)
		moveR = 1;
	else
		moveR = 0;

always @(posedge clk)
	if (b0L || b1L || b2L || b3L || b4L || b5L || b6L || b7L)
		moveL = 1;
	else
		moveL = 0;

always @(posedge clk)
	if (b1U || b2U || b3U || b4U || b5U || b6U || b7U)
		moveU = 1;
	else
		moveU = 0;

always @(posedge clk)
	if (b0D || b1D || b2D || b3D || b4D || b5D || b6D)
		moveD = 1;
	else
		moveD = 0;


// Always block for right of block hits.
// If the ball hits the right side of a block,
// it will bounce off towards to right direction.
always @(posedge clk)
	if ((ball_x_l <= right_border) && (ball_x_l >= right_border_in) && (ball_y_t >= 0) && (ball_y_t <= 76) && (blocks_C3[0] == 1)) 
		b0R = 1;
	
	else if ((ball_x_l <= right_border) && (ball_x_l >= right_border_in) && (ball_y_b >= 78) && (ball_y_t <= 150) && (blocks_C3[1] == 1))
		b1R = 1;

	else if ((ball_x_l <= right_border) && (ball_x_l >= right_border_in) && (ball_y_b >= 152) && (ball_y_t <= 224) && (blocks_C3[2] == 1))
		b2R = 1;

	else if ((ball_x_l <= right_border) && (ball_x_l >= right_border_in) && (ball_y_b >= 226) && (ball_y_t <= 298) && (blocks_C3[3] == 1))
		b3R = 1;

	else if ((ball_x_l <= right_border) && (ball_x_l >= right_border_in) && (ball_y_b >= 300) && (ball_y_t <= 372) && (blocks_C3[4] == 1))
		b4R = 1;

	else if ((ball_x_l <= right_border) && (ball_x_l >= right_border_in) && (ball_y_b >= 374) && (ball_y_t <= 446) && (blocks_C3[5] == 1))
		b5R = 1;

	else if ((ball_x_l <= right_border) && (ball_x_l >= right_border_in) && (ball_y_b >= 448) && (ball_y_t <= 520) && (blocks_C3[6] == 1))
		b6R = 1;

	else if ((ball_x_l <= right_border) && (ball_x_l >= right_border_in) && (ball_y_b >= 522) && (ball_y_b <= 599) && (blocks_C3[7] == 1))
		b7R = 1;
	
	else 
		begin
			b0R = 0; b1R = 0; b2R = 0; b3R = 0; b4R = 0; b5R = 0; b6R = 0; b7R = 0;
		end			

// Always block for left side hits
// If the ball hits the left side of a block,
// it will bounce back in the left direction.
always @(posedge clk)
	if ((ball_x_r <= left_border_in) && (ball_x_r >= left_border) && (ball_y_t >= 0) && (ball_y_t <= 76) && (blocks_C3[0] == 1)) 
		b0L = 1;
	
	else if ((ball_x_r <= left_border_in) && (ball_x_r >= left_border) && (ball_y_b >= 78) && (ball_y_t <= 150) && (blocks_C3[1] == 1))
		b1L = 1;

	else if ((ball_x_r <= left_border_in) && (ball_x_r >= left_border) && (ball_y_b >= 152) && (ball_y_t <= 224) && (blocks_C3[2] == 1))
		b2L = 1;

	else if ((ball_x_r <= left_border_in) && (ball_x_r >= left_border) && (ball_y_b >= 226) && (ball_y_t <= 298) && (blocks_C3[3] == 1))
		b3L = 1;

	else if ((ball_x_r <= left_border_in) && (ball_x_r >= left_border) && (ball_y_b >= 300) && (ball_y_t <= 372) && (blocks_C3[4] == 1))
		b4L = 1;

	else if ((ball_x_r <= left_border_in) && (ball_x_r >= left_border) && (ball_y_b >= 374) && (ball_y_t <= 446) && (blocks_C3[5] == 1))
		b5L = 1;

	else if ((ball_x_r <= left_border_in) && (ball_x_r >= left_border) && (ball_y_b >= 448) && (ball_y_t <= 520) && (blocks_C3[6] == 1))
		b6L = 1;

	else if ((ball_x_r <= left_border_in) && (ball_x_r >= left_border) && (ball_y_b >= 522) && (ball_y_b <= 599) && (blocks_C3[7] == 1))
		b7L = 1;
	else 
		begin
			b0L = 0; b1L = 0; b2L = 0; b3L = 0; b4L = 0; b5L = 0; b6L = 0; b7L = 0;
		end	

// Always block for bottom side hits
// If the ball hits the bottom side of a block,
// it will bounce back in the down direction.
always @(posedge clk)
	if ((ball_x_r <= right_ext) && (ball_x_l >= left_ext) && (ball_y_t <= 76) && (ball_y_t >= 73) && (blocks_C3[0] == 1))
		b0D = 1;

	else if ((ball_x_r <= right_ext) && (ball_x_l >= left_ext) && (ball_y_t <= 150) && (ball_y_t >= 147) && (blocks_C3[1] == 1))
		b1D = 1;

	else if ((ball_x_r <= right_ext) && (ball_x_l >= left_ext) && (ball_y_t <= 224) && (ball_y_t >= 221) && (blocks_C3[2] == 1))
		b2D = 1;

	else if ((ball_x_r <= right_ext) && (ball_x_l >= left_ext) && (ball_y_t <= 298) && (ball_y_t >= 295) && (blocks_C3[3] == 1))
		b3D = 1;

	else if ((ball_x_r <= right_ext) && (ball_x_l >= left_ext) && (ball_y_t <= 372) && (ball_y_t >= 369) && (blocks_C3[4] == 1))
		b4D = 1;

	else if ((ball_x_r <= right_ext) && (ball_x_l >= left_ext) && (ball_y_t <= 446) && (ball_y_t >= 443) && (blocks_C3[5] == 1))
		b5D = 1;

	else if ((ball_x_r <= right_ext) && (ball_x_l >= left_ext) && (ball_y_t <= 520) && (ball_y_t >= 517) && (blocks_C3[6] == 1))
		b6D = 1;
	
	else 
		begin
			b0D = 0; b1D = 0; b2D = 0; b3D = 0; b4D = 0; b5D = 0; b6D = 0; 
		end	

// Always block for top side hits
// If the ball hits the top side of a block,
// it will bounce back in the up direction.
always @(posedge clk)
	if ((ball_x_r <= right_ext) && (ball_x_l >= left_ext) && (ball_y_b >= 78) && (ball_y_b <= 81) && (blocks_C3[1] == 1))
		b1U = 1;

	else if ((ball_x_r <= right_ext) && (ball_x_l >= left_ext) && (ball_y_b >= 152) && (ball_y_b <= 155) && (blocks_C3[2] == 1))
		b2U = 1;

	else if ((ball_x_r <= right_ext) && (ball_x_l >= left_ext) && (ball_y_b >= 226) && (ball_y_b <= 229) && (blocks_C3[3] == 1))
		b3U = 1;

	else if ((ball_x_r <= right_ext) && (ball_x_l >= left_ext) && (ball_y_b >= 300) && (ball_y_b <= 303) && (blocks_C3[4] == 1))
		b4U = 1;

	else if ((ball_x_r <= right_ext) && (ball_x_l >= left_ext) && (ball_y_b >= 374) && (ball_y_b <= 377) && (blocks_C3[5] == 1))
		b5U = 1;

	else if ((ball_x_r <= right_ext) && (ball_x_l >= left_ext) && (ball_y_b >= 448) && (ball_y_b <= 451) && (blocks_C3[6] == 1))
		b6U = 1;

	else if ((ball_x_r <= right_ext) && (ball_x_l >= left_ext) && (ball_y_b >= 522) && (ball_y_b <= 525) && (blocks_C3[7] == 1))
		b7U = 1;
	
	else 
		begin
			b1U = 0; b2U = 0; b3U = 0; b4U = 0; b5U = 0; b6U = 0; b7U = 0; 
		end	

// Signal sent to turn on a block
assign C3_ON = block_C3_R0 || block_C3_R1 || block_C3_R2 || block_C3_R3 || block_C3_R4 || block_C3_R5 || block_C3_R6 || block_C3_R7;

// Counter to determine score from the number of blocks hit
reg [3:0] C3_count_small;
always @(posedge clk) begin
		C3_count_small <= (counter0 + counter1 + counter2 + counter3 + counter4 + counter5 + counter6 + counter7);
end

// Score multipled to appropriate amount for the respectice column
reg [5:0] C3_count;
always @(posedge clk) begin
	C3_count <= C3_count_small * 4;
end
		
endmodule
