`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:14:26 04/05/2022 
// Design Name: 
// Module Name:    chip_checker 
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
module chip_checker(
    input clk,
	 input rst,
    input [19:0] chip_pins,
	 output [7:0] led,
	 output [7:0] debug
    );

wire [5:0] model_output_pins;
wire [5:0] diff;

TTL7404 ttl7404 (
	 .a(chip_pins[5:0]),
	 .y(model_output_pins)
	 );

compare#(6) compare (
	.clk(clk),
	.a(chip_pins[11:6]),
	.b(model_output_pins),
	.diff(diff[5:0])
	);

count#(6, 3) count (
	.clk(clk),
	.rst(rst),
	.diff(diff[5:0]),
	.flag(led[5:0])
	);

assign debug[5:0] = diff[5:0];

assign led[7:6] = 2'b00;
assign debug[7:6] = 2'b00;

endmodule
