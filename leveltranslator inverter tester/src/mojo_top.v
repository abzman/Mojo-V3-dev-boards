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
    output[7:0]enable_bit, // Outputs to the 8 chip enables
    input[55:0]data_bit, // Inputs from the 56 data pins
	 output[7:0]debug_bit // Outputs to 8 data pins
    );

wire rst = ~rst_n; // make reset active high

// these signals should be high-z when not used
assign spi_miso = 1'bz;
assign avr_rx = 1'bz;
assign spi_channel = 4'bzzzz;

assign enable_bit[7:0] = ~0; //enable all 64 bits of level translators

//(* keep_hierarchy = "yes" *) chip_checker chip_checker (

wire clk_hs;

mydcm mydcm (
  .CLK_IN1(clk),
  // Clock out ports
  .CLK_OUT1(clk_hs)
 );
 
chip_checker chip_checker (
    .clk(clk_hs),
	 .rst(rst),
	 .chip_pins(data_bit[19:0]),
	 .led(led),
	 .debug(debug_bit)
	 );
	 
endmodule