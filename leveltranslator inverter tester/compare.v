`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:54:29 04/11/2022 
// Design Name: 
// Module Name:    compare 
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
module compare#(parameter WIDTH=1)(
	input clk,
	input [WIDTH-1:0] a,
	input [WIDTH-1:0] b,
	output [WIDTH-1:0] diff
	);

reg [WIDTH-1:0] a_buf;
reg [WIDTH-1:0] b_buf;

always @(posedge clk) 
begin
	a_buf <= a;
	b_buf <= b;
end

assign diff = a_buf ^ b_buf;

endmodule
