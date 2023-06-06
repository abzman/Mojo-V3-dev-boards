module message_rom (
    input clk,
    input [3:0] addr,
    output reg [7:0] data
  );
 
  wire [7:0] rom_data [9:0];
 
  assign rom_data[0] = "D";
  assign rom_data[1] = "a";
  assign rom_data[2] = "t";
  assign rom_data[3] = "a";
  assign rom_data[4] = ":";
  assign rom_data[5] = " ";
  assign rom_data[6] = "0";
  assign rom_data[7] = "x";
  assign rom_data[8] = "\n";
  assign rom_data[9] = "\r";
 
  reg [7:0] data_d;
 
  always @(*) begin
    if (addr > 4'd9)
      data_d = "@";
    else
      data_d = rom_data[addr];
  end
 
  always @(posedge clk) begin
    data <= data_d;
  end
 
endmodule