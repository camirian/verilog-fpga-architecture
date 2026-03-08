`timescale 1ns / 1ps

module spi_master (
    input wire clk,          // System clock
    input wire rst_n,        // Active low reset
    input wire start,        // Start transmission
    input wire [7:0] data_in,// Data to transmit
    output reg mosi,         // Master Out Slave In
    output reg sclk,         // SPI Clock
    output reg cs_n,         // Chip Select (Active Low)
    output reg ready         // Ready for new data
);

    // SPI Mode 0: CPOL=0, CPHA=0
    
    // State Machine encoding
    localparam IDLE  = 2'b00;
    localparam SHIFT = 2'b01;
    localparam DONE  = 2'b10;

    reg [1:0] state;
    reg [2:0] bit_cnt;  // 8 bits to shift (0 to 7)
    reg [7:0] shift_reg;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            mosi <= 1'b0;
            sclk <= 1'b0;
            cs_n <= 1'b1;
            ready <= 1'b1;
            bit_cnt <= 3'd0;
            shift_reg <= 8'd0;
        end else begin
            case (state)
                IDLE: begin
                    sclk <= 1'b0;
                    cs_n <= 1'b1;
                    if (start) begin
                        shift_reg <= data_in;
                        state <= SHIFT;
                        ready <= 1'b0;
                        cs_n <= 1'b0; // Assert CS
                        bit_cnt <= 3'd7; // Start at MSB
                    end
                end
                
                SHIFT: begin
                    // Simple div-2 clock generation logic for SCLK
                    sclk <= ~sclk;
                    if (~sclk) begin
                        // Falling edge of SCLK (or initial state): shift out data
                        mosi <= shift_reg[bit_cnt];
                    end else begin
                        // Rising edge of SCLK: data is sampled by slave.
                        // We decrement bit count here.
                        if (bit_cnt == 0) begin
                            state <= DONE;
                        end else begin
                            bit_cnt <= bit_cnt - 1;
                        end
                    end
                end
                
                DONE: begin
                    sclk <= 1'b0;
                    cs_n <= 1'b1; // De-assert CS
                    ready <= 1'b1;
                    state <= IDLE;
                end
                
                default: state <= IDLE;
            endcase
        end
    end

endmodule
