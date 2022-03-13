//----------------------------------//
// Breakout Files
// breakout_top_an.v
// David J. Morvay
// ECEN 4856
// Fall 2020
//----------------------------------//

module breakout_top_an (clk, btnC, btnU, btnD, Hsync, Vsync, vgaRed, vgaGreen, vgaBlue, an, seg);
input clk, btnC, btnU, btnD;
output Hsync, Vsync;
output [3:0] vgaRed, vgaGreen, vgaBlue;
output [3:0] an;
output [6:0] seg;

// signals
wire [10:0] pixel_x, pixel_y;
wire video_on, pixel_tick;
reg [3:0] vgaRed_reg, vgaGreen_reg, vgaBlue_reg;
wire [3:0] vgaRed_next, vgaGreen_next, vgaBlue_next;
wire [15:0] score;
//----------------------- BODY ---------------------------//
// VGA Sync Circuit
vga_sync sync_unit(.clk(clk), .reset(btnC), .Hsync(Hsync), .Vsync(Vsync), .video_on(video_on), .p_tick(pixel_tick), .pixel_x(pixel_x), .pixel_y(pixel_y));

// Graphic Generator
breakout_graph_animate breakout_graph_an_unit(
	.clk(clk), 
	.reset(btnC), 
	.btnU(btnU), 
	.btnD(btnD), 
	.video_on(video_on), 
	.pix_x(pixel_x), 
	.pix_y(pixel_y), 
	.vgaRed(vgaRed_next), 
	.vgaGreen(vgaGreen_next), 
	.vgaBlue(vgaBlue_next),
	.score(score));

// Seven segment display
b_10 b_10_counter(.clk(clk), .btnC(btnC), .sw(score), .an(an), .seg(seg));

// RBG Buffer
always @(posedge clk)
	if (pixel_tick) begin
		vgaRed_reg <= vgaRed_next;
		vgaGreen_reg <= vgaGreen_next;
		vgaBlue_reg <= vgaBlue_next;	
	end

// Output 
assign vgaRed = vgaRed_reg;
assign vgaGreen = vgaGreen_reg;
assign vgaBlue = vgaBlue_reg;

endmodule
