 
`include "components/baud-rate-generator.v"
`include "components/fifo.v"
`include "components/transmitter.v"

`timescale 1ns/1ns
module transmitter_tb;

reg [7:0] dataInTofifo;
reg clk = 0,reset;
reg writeEn=0;

baud_gen br1 (
    .clk(clk),
    .divsr(11'd650),
    .reset(reset)
);

Transmitter#(8,16)t1 (
    .tx_start(~f.EMPTY),
    .s_tick(br1.tick),
    .tx_dataIn(f.dataOut)
);

fifo f(
  .clk(clk),
  .dataIn(dataInTofifo),
  .reset(reset),
  .readEn(t1.tx_done_tick),
  .writeEn(writeEn)
);

initial begin
    $dumpfile("transmitter");
    $dumpvars(0, transmitter_tb);

    reset=1;
    #15
    reset=0;

    dataInTofifo=8'b01010101;
    writeEn=1;//put data in fifo
    #15
    writeEn = 0;
    #15
    writeEn = 1;
    dataInTofifo=8'b01010111;
    #15
    writeEn=0;

end

always #5 clk = ~clk;
endmodule
