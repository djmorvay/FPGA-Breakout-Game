//----------------------------------//
// Breakout Files
// vga_sync.v
// David J. Morvay
// ECEN 4856
// Fall 2020
// Reference for this file:
// "FPGA Prototyping by Verilog Examples"
//----------------------------------//

module vga_sync (clk, reset, Hsync, Vsync, video_on, p_tick, pixel_x, pixel_y);
input clk, reset;
output Hsync, Vsync, video_on, p_tick;
output [10:0] pixel_x, pixel_y;

wire clk, reset;
wire Hsync, Vsync, video_on, p_tick;
wire [10:0] pixel_x, pixel_y;

// constant declaration
// VGA 800-by-600 sync parameters
localparam HD = 800; // horizontal display area
localparam HF = 56 ; // h. front (left) border 
localparam HB = 64 ; // h. back (right) border 
localparam HR = 120 ; // h. retrace
localparam VD = 600; // vertical display area 
localparam VF = 37; // v . front (top) border
localparam VB = 23; // v. back (bottom) border 
localparam VR = 6; // v . retrace

// mod-2 counter
reg mod2_reg;
initial mod2_reg = 0;
wire mod2_next;

// sync counters
reg [10:0] h_count_reg, h_count_next;
reg [10:0] v_count_reg, v_count_next;

// output buffer
reg v_sync_reg, h_sync_reg;
wire v_sync_next, h_sync_next;

// signal signal
wire h_end, v_end, pixel_tick;

// registers
always @(posedge clk, posedge reset)
	if (reset) begin
		mod2_reg <= 1'b0;
		v_count_reg <= 0;
 		h_count_reg <= 0; 
		v_sync_reg <= 1'b0; 
		h_sync_reg <= 1'b0;
	end

	else begin
		mod2_reg <= mod2_next;
		v_count_reg <= v_count_next;
		h_count_reg <= h_count_next;
		v_sync_reg <= v_sync_next;
		h_sync_reg <= h_sync_next;
	end

// mod-2 circuit to generate 50 MHz enable tick
assign mod2_next = ~mod2_reg;
assign pixel_tick = mod2_reg;

// Status signals
// end of horizontal counter (1039)
assign h_end = (h_count_reg == (HD+HF+HB+HR-1));
// end of vertical counter (665)
assign v_end = (v_count_reg == (VD+VF+VB+VR-1));

// Next-state logic of horizontal sync counter
always @*
	if(pixel_tick)
		if (h_end)
			h_count_next = 0;
		else
			h_count_next = h_count_reg + 1;
	else 
		h_count_next = h_count_reg;

always @*
	if(pixel_tick & h_end)
		if (v_end)
			v_count_next = 0;
		else
			v_count_next = v_count_reg + 1;
	else 
		v_count_next = v_count_reg;

// horizontal and vertical sync, buffered to avoid glitch
// h_sync_next asserted between  863 and 982
assign h_sync_next = (h_count_reg >= (HD+HB) && h_count_reg <= (HD+HB+HR-1));
// v_sync_next asserted between  622 and 628
assign v_sync_next = (v_count_reg >= (VD+VB) && v_count_reg <= (VD+VB+VR-1));	

// video on/off
assign video_on = ((h_count_reg < HD) && (v_count_reg < VD));	

// Output
assign Hsync = h_sync_reg;
assign Vsync = v_sync_reg;
assign pixel_x = h_count_reg;
assign pixel_y = v_count_reg;
assign p_tick = pixel_tick;

endmodule
