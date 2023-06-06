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
    input[63:0]data_bit // Outputs to the 64 data pins
    );

wire rst = ~rst_n; // make reset active high

// these signals should be high-z when not used
assign spi_miso = 1'bz;
assign avr_rx = 1'bz;
assign spi_channel = 4'bzzzz;

reg trigger = 1'b0;
reg trigger_last = 1'b0;
assign led[7:1] = data_bit[7:1]; //LEDs show what's on the first 8 bits of level shifter
assign led[0] = trigger_last; //see if the statement above is working
assign enable_bit[7:0] = ~0; //enable all 64 bits of level translators

//set data_bit[8] as input trigger
//on rising edge, output 8 data bits to serial

always @(posedge clk) begin
	if(data_bit[8] && (trigger_last == 0)) begin
		trigger = ~0;
	end
	else begin
		trigger = 0;
	end
	trigger_last = data_bit[8];
end

wire [7:0] transmit_data;
assign transmit_data[7:0] = data_bit[7:0]; //set up data bus

wire [7:0] tx_data;
wire new_tx_data;
wire tx_busy;
wire [7:0] rx_data;
wire new_rx_data;
 
avr_interface avr_interface (
    .clk(clk),
    .rst(rst),
    .cclk(cclk),
    .spi_miso(spi_miso),
    .spi_mosi(spi_mosi),
    .spi_sck(spi_sck),
    .spi_ss(spi_ss),
    .spi_channel(spi_channel),
    .tx(avr_rx), // FPGA tx goes to AVR rx
    .rx(avr_tx),
    .channel(4'd15), // invalid channel disables the ADC
    .new_sample(),
    .sample(),
    .sample_channel(),
    .tx_data(tx_data),
    .new_tx_data(new_tx_data),
    .tx_busy(tx_busy),
    .tx_block(avr_rx_busy),
    .rx_data(rx_data),
    .new_rx_data(new_rx_data)
    );

message_printer helloWorldPrinter (
    .clk(clk),
    .rst(rst),
    .tx_data(tx_data),
    .new_tx_data(new_tx_data),
    .tx_busy(tx_busy),
    .rx_data(rx_data),
    .new_rx_data(new_rx_data),
    .transmit_data(transmit_data),
    .trigger(trigger)
    );

endmodule