module message_printer (
    input clk,
    input rst,
    output [7:0] tx_data,
    output reg new_tx_data,
    input tx_busy,
    input [7:0] rx_data,
    input new_rx_data,
	 
    input [7:0] transmit_data,
    input trigger
  );
 
  localparam STATE_SIZE = 2;
  localparam IDLE = 0,
    PRINT_MESSAGE = 1,
    PRINT_DATA = 2,
    PRINT_SUFFIX = 3;
 
  localparam MESSAGE_LEN = 8;
  localparam DATA_LEN = 2;
  localparam SUFFIX_LEN = 2;
 
  reg [STATE_SIZE-1:0] state_d, state_q;
  reg [DATA_LEN-1:0] digit_d, digit_q;
 
  reg [3:0] addr_d, addr_q, data_high, data_low;
  wire [7:0] number_data, rom_data, addr_num;
  
  reg trigger_prev = 1'b0;
  
  reg s = 1'b0;

  m21 text_multiplexer(.Y(tx_data), .D0(rom_data), .D1(number_data), .S(s));
  m21 number_multiplexer(.Y(addr_num), .D0(data_low), .D1(data_high), .S(digit_q));
  
  message_rom message_rom (
  .clk(clk),
  .addr(addr_q),
  .data(rom_data)
  );
  nibble_rom nibble_rom (
  .clk(clk),
  .addr(addr_num),
  .data(number_data)
  );
 
  always @(*) begin
    state_d = state_q; // default values
    addr_d = addr_q;   // needed to prevent latches
    digit_d = digit_q;
    new_tx_data = 1'b0;
 
    case (state_q)
      IDLE: begin
        addr_d = 4'd0;
        digit_d = 4'd0;
        if (trigger) 
		  begin//oneshot
          state_d = PRINT_MESSAGE;
			 data_high = transmit_data[7:4];
			 data_low = transmit_data[3:0];
		  end
      end
      PRINT_MESSAGE: begin
        if (!tx_busy) begin
          new_tx_data = 1'b1;
          addr_d = addr_q + 1'b1;
          if (addr_q == MESSAGE_LEN-1)
            state_d = PRINT_DATA;
        end
      end
      PRINT_DATA: begin
        if (!tx_busy) begin
			 new_tx_data = 1'b1;
			 digit_d = digit_q + 1'b1;
			 if (digit_q == DATA_LEN-1)
            state_d = PRINT_SUFFIX;
        end
      end
      PRINT_SUFFIX: begin
        if (!tx_busy) begin
          new_tx_data = 1'b1;
          addr_d = addr_q + 1'b1;
          if (addr_q == (MESSAGE_LEN + SUFFIX_LEN) -1)
            state_d = IDLE;
        end
      end
      default: state_d = IDLE;
    endcase
  end
 
  always @(posedge clk) begin
    if (rst) begin
      state_q <= IDLE;
      digit_q <= 0;
    end else begin
      state_q <= state_d;
      digit_q <= digit_d;
    end
    addr_q <= addr_d;
	 if (state_q == PRINT_DATA) begin
		s <= 1'b1;
	 end else begin
		s <= 1'b0;
	 end
  end
 
endmodule