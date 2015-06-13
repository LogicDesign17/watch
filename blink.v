`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:14:08 06/13/2015 
// Design Name: 
// Module Name:    blink 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module blink(
    input on,
	input val,
	input clk,
    output out
    );

	reg [18:0] count;
	
	initial begin
		out = 0;
		count = 0;
	end
	
	always @(posedge clk) begin
		if (on & val) begin
			count = count + 1;
			if (count == 500000) begin
				count = 0;
				out = ~out;
			end
		end
		else begin
			out = val;
		end
	end

endmodule
