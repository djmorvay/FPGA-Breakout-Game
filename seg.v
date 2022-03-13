//----------------------------------//
// Breakout Files
// seg.v
// David J. Morvay
// ECEN 4856
// Fall 2020
// Reference for this file:
// Past Lab Assignment
//----------------------------------//

module seg(clk, count, reset_click, an, seg);
input clk;
input  [15:0] 	count;
input		reset_click;
output [3:0] 	an;
output [6:0] 	seg;

reg [3:0]	an;
reg [6:0]	seg;

reg   [39:0]                      counter;
always @(posedge clk)             
	if(reset_click)               counter     <= 0;
	else                          counter     <= counter + 1;
                                  
wire                              anode_clk    =  (counter[15:0] == 16'h8000);


always @(posedge clk)
        if(reset_click)       an <= 4'b0111;	
	     else if(anode_clk)   an <= {an[0],an[3:1]}; // rotate
	     else                 an <=  an;  

reg [3:0] cathode_select;

always @(an or count)
       case({an})
	      4'b0111:  cathode_select = count[15:12]; 
	      4'b1011:  cathode_select = count[11:8]; 
	      4'b1101:  cathode_select = count[7:4]; 
	      4'b1110:  cathode_select = count[3:0];
	      default:  cathode_select = 4'h0; 
      endcase


always @(cathode_select)
       case(cathode_select)
	       4'h0:  seg = 7'b1000_000;
	       4'h1:  seg = 7'b1111_001;
	       4'h2:  seg = 7'b0100_100;
	       4'h3:  seg = 7'b0110_000;
	       4'h4:  seg = 7'b0011_001;
	       4'h5:  seg = 7'b0010_010;
	       4'h6:  seg = 7'b0000_011;
	       4'h7:  seg = 7'b1111_000;
	       4'h8:  seg = 7'b0000_000;
	       4'h9:  seg = 7'b0011_000; 
	       4'ha:  seg = 7'b0001_000;
	       4'hb:  seg = 7'b0000_011; 
	       4'hc:  seg = 7'b1000_110; 
	       4'hd:  seg = 7'b0100_001; 
	       4'he:  seg = 7'b0000_110; 
	       4'hf:  seg = 7'b0001_110; 
     endcase
       
endmodule
