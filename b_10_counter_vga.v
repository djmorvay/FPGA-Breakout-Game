//----------------------------------//
// Breakout Files
// b_10_counter_vga.v
// David J. Morvay
// ECEN 4856
// Fall 2020
//----------------------------------//

module b_10_vga(clk, sw, num_out);
input clk;
input [15:0] sw;
output [15:0] num_out;

reg [3:0] ones, tens, hundreds, thousands;
initial ones = 0;
initial tens = 0;
initial hundreds = 0;
initial thousands = 0;
reg [15:0] num_out;

// Get initial input
// If the input number has changed,
// send it to the first stage for processing
reg [15:0] num_change;
initial num_change = 16'h0;
reg [15:0] num_in_reg;
reg tick_ones;
always @(posedge clk) begin
	if (num_change != sw) begin
		num_change <= sw;
		tick_ones <= 1;
	end
	else 
		tick_ones <= 0;
end

// Determine the value in the "tens place"
reg tick_tens;

wire sub_ones;
assign sub_ones = (num_in_reg >= 10);

wire ones_complete;
assign ones_complete = ~sub_ones;
		
// Follows the always block above			
always @(posedge clk) begin
	// New input, store the number in num_in_next.
	if (tick_ones == 1) begin
		num_in_reg <= sw;
		tick_tens <= 0;
	end

	// No new number but the number is greater than 10
	else if ((sub_ones == 1) && (tick_ones == 0)) begin
		num_in_reg <= num_in_reg - 10;
		tick_tens <= 1;
	end 
	
	else
		tick_tens <= 0;
end

reg hold;
always @(posedge clk) begin
	if (ones_complete)
		hold <= 1;
	else
		hold <= 0;
end

// Store the digit in the ones place
always @(posedge clk) begin
	if ((ones_complete) && (num_in_reg < 10))
		ones = num_in_reg[3:0];
end

// Determine the "tenths" place
reg [3:0] tens_next;
initial tens_next = 0;
reg [3:0] tens_check;
initial tens_check = 0;
always @(posedge clk) begin
	// If tens needs to be increased but less than 9,
	// increase tens place by one.
	if ((tick_tens == 1) && (tens_next < 9) && (tick_ones == 0))
		tens_check = tens_check + 1;

	// If tens place needs to be increased but at 9,
	// add one to hundreds place and decrease tens to 0.
	else if ((tick_tens == 1) && (tens_next == 9) && (tick_ones == 0)) 
		tens_check = 0;

	else if (tick_ones == 1)
		tens_check = 0;
end

wire tick_hundreds;
assign tick_hundreds = ((tick_tens == 1) && (tens_next == 9) && (tick_ones == 0));

// Buffer
always @* begin
	tens_next = tens_check;
end

// Set tens
always @* begin
	tens = tens_next;
end

// Determine the "hundredths" place
reg [3:0] hundreds_next;
initial hundreds_next = 0;
reg [3:0] hundreds_check;
initial hundreds_check = 0;

always @(posedge clk) begin
	// If tens needs to be increased but less than 9,
	// increase tens place by one.
	if ((tick_hundreds == 1) && (hundreds_next < 9) && (tick_ones == 0))
		hundreds_check = hundreds_check + 1;

	// If tens place needs to be increased but at 9,
	// add one to hundreds place and decrease tens to 0.
	else if ((tick_hundreds == 1) && (hundreds_next == 9) && (tick_ones == 0)) 
			hundreds_check = 0;

	else if (tick_ones == 1)
		hundreds_check = 0;
end

wire tick_thousands;
assign tick_thousands = ((tick_hundreds == 1) && (hundreds_next == 9) && (tick_ones == 0));

// Buffer
always @* begin
	hundreds_next = hundreds_check;
end

// Set hundreds
always @* begin
	hundreds = hundreds_next;
end

// Determine the "thousands" place
reg [3:0] thousands_next;
initial thousands_next = 0;
reg [3:0] thousands_check;
initial thousands_check = 0;
always @(posedge clk) begin
	// If thousands needs to be increased but less than 9,
	// increase thousands place by one.
	if ((tick_thousands == 1) && (thousands_next < 9) && (tick_ones == 0)) 
		thousands_check = thousands_check + 1;

	// If thousands place needs to be increased but at 9,
	// decrease thousands to 0.
	else if ((tick_thousands == 1) && (thousands_next == 9) && (tick_ones == 0))  
		thousands_check = 0;

	else if (tick_ones == 1)
		thousands_check = 0;
end	

// Buffer
always @* begin
	thousands_next = thousands_check;
end

// Set thousands
always @* begin
	thousands = thousands_next;
end		

// Output buffer
reg done;
always @(posedge clk) begin
	if ((tick_ones == 0) && (hold == 1) && (num_in_reg < 10))
		done <= 1;
	else
		done <= 0;
end

always @(posedge clk) begin
	if (done)
		num_out = {thousands, hundreds, tens, ones};
end

endmodule
