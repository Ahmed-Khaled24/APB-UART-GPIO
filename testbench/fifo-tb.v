`include "components/fifo.v"
`timescale 1ns/1ns

module fifo_tb;
    reg [7:0] dataIn;
    reg clk = 0, writeEn = 0, readEn = 0 , reset = 0;

    // output
    wire Empty, Full; 
    wire [7:0] dataOut;

    fifo f1 (
        .clk(clk),
        .reset(reset),
        .EMPTY(Empty),
        .FULL(Full),
        .writeEn(writeEn),
        .readEn(readEn),
        .dataIn(dataIn),
        .dataOut(dataOut)
    );
    
    initial begin
        $dumpfile("fifo.vcd");
        $dumpvars(0, f1);
 
        writeEn = 1;
        dataIn = 8'd255;
        #10
        dataIn = 8'd165;
        #10
        dataIn = 8'd109;
        #10
        dataIn = 8'd165;
        #10
        dataIn = 8'd109;
        #10
        dataIn = 8'd255;
        #10
        dataIn = 8'd165;
        #10
        dataIn = 8'd109;
        #10
        dataIn = 8'd255;

        writeEn = 0;
        readEn = 1;

    end 

    always #5 clk = ~clk;
endmodule