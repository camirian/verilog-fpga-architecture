`timescale 1ns / 1ps

module spi_master_tb;

    // Inputs
    reg clk;
    reg rst_n;
    reg start;
    reg [7:0] data_in;

    // Outputs
    wire mosi;
    wire sclk;
    wire cs_n;
    wire ready;

    // Instantiate the Unit Under Test (UUT)
    spi_master uut (
        .clk(clk), 
        .rst_n(rst_n), 
        .start(start), 
        .data_in(data_in), 
        .mosi(mosi), 
        .sclk(sclk), 
        .cs_n(cs_n), 
        .ready(ready)
    );

    // Clock generation (100MHz system clock)
    always #5 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 0;
        rst_n = 0;
        start = 0;
        data_in = 8'h00;

        // Display Simulation Outputs
        $monitor("Time=%0t | rst_n=%b | start=%b | data_in=0x%h | mosi=%b | sclk=%b | cs_n=%b | ready=%b", 
                 $time, rst_n, start, data_in, mosi, sclk, cs_n, ready);

        // Apply Reset
        #100;
        rst_n = 1;
        
        // Wait for ready
        wait(ready);

        // Start Transmission of 0x5A (01011010)
        #20;
        data_in = 8'h5A;
        start = 1;
        #10;
        start = 0;

        // Wait for transmission to complete
        wait(ready);
        #50;

        // Start Transmission of 0xC3 (11000011)
        data_in = 8'hC3;
        start = 1;
        #10;
        start = 0;
        
        wait(ready);
        #100;

        $display("SPI Master Simulation Complete.");
        $finish;
    end
      
endmodule
