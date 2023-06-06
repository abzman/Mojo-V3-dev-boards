`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:57:04 04/11/2022 
// Design Name: 
// Module Name:    count 
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
module count#(parameter WIDTH = 1, THRESHOLD = 3)(
	input clk,
	input rst,
	input [WIDTH-1:0] diff,
	output reg [WIDTH-1:0] flag
	);

reg [7:0] counter [WIDTH-1:0];

always @(posedge clk) 
begin:B1
	integer i;
	if (rst == 1'b1) begin
		for(i=0; i<WIDTH; i = i + 1) begin
			counter[i] <= 0;
		end
		flag <= 0;
	end
	else
	begin
		for(i=0; i<WIDTH; i = i + 1) begin
			if (counter[i] < THRESHOLD) // not really needed, we don't care about overflow
				//counter[i] <= ((counter[i] + 1) & diff[i]);
				if (diff[i]) begin
					counter[i] <= (counter[i] + 1);
					if ((counter[i] + 1) >= THRESHOLD)
						flag[i] <= 1'b1;
				end
				else
					counter[i] <= 0;
			//if (((counter[i] + 1) & diff[i]) >= THRESHOLD)
			//	flag[i] <= 1'b1;
			//if (counter[i] >= THRESHOLD)
			//	flag[i] <= 1'b1;
			//else
			//	counter[i] <= ((counter[i] + 1) & diff[i]);
		end
	end
end

endmodule
