module mojo_top(
    // 50MHz clock input
    input clk,
    // Input from reset button (active low)
    input rst_n,
    // cclk input from AVR, high when AVR is ready
    input cclk,
    // Outputs to the 8 onboard LEDs
    output[7:0]led,
    // AVR SPI connections
    output spi_miso,
    input spi_ss,
    input spi_mosi,
    input spi_sck,
    // AVR ADC channel select
    output [3:0] spi_channel,
    // Serial connections
    input avr_tx, // AVR Tx => FPGA Rx
    output avr_rx, // AVR Rx => FPGA Tx
    input avr_rx_busy, // AVR Rx buffer full
	 
    // Outputs to the 8 chip enables
    output[7:0]enable_bit,
    // Outputs to the 64 data pins
    output[63:0]data_bit
    );

wire rst = ~rst_n; // make reset active high

// these signals should be high-z when not used
assign spi_miso = 1'bz;
assign avr_rx = 1'bz;
assign spi_channel = 4'bzzzz;


assign led[6:0] = 7'b0;
assign led[7] = rst;

assign enable_bit[7:0] = 8'b1;
assign data_bit[0] = rst;
assign data_bit[1] = ~rst;
assign data_bit[63:2] = 62'b0;
  
  
always @(*) begin

end
  

endmodule