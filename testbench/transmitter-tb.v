`timescale 1ps/1ps
module transmitter_tb;

reg [7:0] din=7'b01010101;
wire tx_done_tick;
reg clk = 0,
    s_tick = 0,
    tx_start = 0;
wire dout=1;

Transmitter#(8,8)t1 (
    .tx_start(tx_start),
    .s_tick(s_tick),
    .din(din),
    .tx_done_tick(tx_done_tick),
    .dout(dout)
);
initial
begin 
  #100
  tx_start=1;
end

always #50 s_tick = ~s_tick;
endmodule  


