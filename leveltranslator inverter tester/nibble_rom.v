module nibble_rom (
    input clk,
    input [3:0] addr,
    output reg [7:0] data
  );
 
  wire [7:0] rom_data [15:0];
 
  assign rom_data[0] = "0";
  assign rom_data[1] = "1";
  assign rom_data[2] = "2";
  assign rom_data[3] = "3";
  assign rom_data[4] = "4";
  assign rom_data[5] = "5";
  assign rom_data[6] = "6";
  assign rom_data[7] = "7";
  assign rom_data[8] = "8";
  assign rom_data[9] = "9";
  assign rom_data[10] = "A";
  assign rom_data[11] = "B";
  assign rom_data[12] = "C";
  assign rom_data[13] = "D";
  assign rom_data[14] = "E";
  assign rom_data[15] = "F";
 
  reg [7:0] data_d;
 
  always @(*) begin
    if (addr > 4'd15)
      data_d = "?";
    else
      data_d = rom_data[addr];
  end
 
  always @(posedge clk) begin
    data <= data_d;
  end
 
endmodule