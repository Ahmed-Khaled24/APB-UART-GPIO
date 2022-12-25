`include "components/baud-rate-generator.v"
`include "components/transmitter.v"

`timescale 1ns/1ns
module transmitter_tb;

reg [7:0] din=8'b01010101;
wire tx_done_tick;
reg clk = 0,
    s_tick = 0,
    tx_start = 0;
wire dout=1;

baud_gen br1 (
    .clk(clk),
    .divsr(11'd650)
);

Transmitter#(8,16)t1 (
    .tx_start(tx_start),
    .s_tick(br1.tick),
    .din(din),
    .tx_done_tick(tx_done_tick),
    .dout(dout)
);
initial
begin 
$dumpfile("trasmitter.vcd");
$dumpvars(0, transmitter_tb);
  #10
  tx_start=1;
end

always #5 clk = ~clk;
endmodule  
