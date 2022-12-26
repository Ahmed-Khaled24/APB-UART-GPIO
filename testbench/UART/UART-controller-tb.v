`include "components/UART/UART-controller.v"
`timescale 1ns/1ns

module UART_tb;

reg [10:0] baud_final_value;
reg [7:0] tx_fifo_dataIn;
reg clk = 0, reset, 
tx_fifo_writeEn, 
rx_fifo_readEn, rx = 1;


UART u (
    .clk(clk),
    .reset(reset),
    .tx_fifo_writeEn(tx_fifo_writeEn),
    .rx_fifo_readEn(rx_fifo_readEn),
    .rx(rx),
    .baud_final_value(11'd650),
    .tx_fifo_dataIn(tx_fifo_dataIn)
);

initial begin
    $dumpfile("uart.vcd");
    $dumpvars(0, u);
    rx_fifo_readEn = 0;

    reset = 1;
    #10
    reset = 0;

    // trasmitter
    // write 9 bytes till fifo is full 
    // the 9th packet is discarded.
    tx_fifo_dataIn=8'b01010101;
    tx_fifo_writeEn=1;
    #10
    tx_fifo_writeEn = 0;
    #10
    // ****
    tx_fifo_dataIn=8'b00001111;
    tx_fifo_writeEn = 1;
    #10
    tx_fifo_writeEn = 0;
    #10
    // *****
    tx_fifo_dataIn=8'b00001111;
    tx_fifo_writeEn = 1;
    #10
    tx_fifo_writeEn = 0;
    #10
    // *****
    tx_fifo_dataIn=8'b00001111;
    tx_fifo_writeEn = 1;
    #10
    tx_fifo_writeEn = 0;
    #10
    // *****
    tx_fifo_dataIn=8'b00001111;
    tx_fifo_writeEn = 1;
    #10
    tx_fifo_writeEn = 0;
    #10
    // *****
    tx_fifo_dataIn=8'b00001111;
    tx_fifo_writeEn = 1;
    #10
    tx_fifo_writeEn = 0;
    #10
    // *****
    tx_fifo_dataIn=8'b00001111;
    tx_fifo_writeEn = 1;
    #10
    tx_fifo_writeEn = 0;
    #10
    // *****
    tx_fifo_dataIn=8'b00001111;
    tx_fifo_writeEn = 1;
    #10
    tx_fifo_writeEn = 0;
    #10
    // *****
    tx_fifo_dataIn=8'b00001111;
    tx_fifo_writeEn = 1;
    #10
    tx_fifo_writeEn = 0;
    #10


    // receiver
    #104166
    rx = 0;
    for (integer i  = 0 ; i < 4 ; i ++) begin
        #104166
        rx = 1;
    end
    for (integer i  = 0 ; i < 4 ; i ++) begin
        #104166
        rx = 0;
    end
    #104166
    rx = 1;
    // ****
    #104166
    rx = 0;
    for (integer i  = 0 ; i < 4 ; i ++) begin
        #104166
        rx = 0;
    end
    for (integer i  = 0 ; i < 4 ; i ++) begin
        #104166
        rx = 1;
    end
    #104166
    rx = 1;

   
    rx_fifo_readEn = 1;
    #10;
    rx_fifo_readEn = 0;

end

always #5 clk = ~clk;
endmodule
