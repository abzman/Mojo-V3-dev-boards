module m21 (
    input [7:0] D0,
    input [7:0] D1,
    input S,
    output reg [7:0] Y
  );
 
 always @(S)
	begin

	if(S) 
	Y= D1;
	else
	Y=D0;

	end

endmodule