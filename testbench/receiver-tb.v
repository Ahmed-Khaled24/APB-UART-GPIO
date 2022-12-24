`include "components/receiver.v"
`timescale 1ps/1ps
module receiver_tb;

reg clk = 0,
    s_tick = 0,
    rx = 1;

receiver r1 (
    .clk(clk),
    .rx(rx),
    .s_tick(s_tick)
);

initial begin
    $dumpfile("receiver.vcd");
    $dumpvars(0, r1);
    
    // receiving (10101010)
    rx = 0; // start bit
    #1600
    rx = 1;
    #1600
    rx = 0;
    #1600
    rx = 1;
    #1600
    rx = 0;
    #1600
    rx = 1;
    #1600
    rx = 0;
    #1600
    rx = 1;
    #1600
    rx = 0;
    #1600
    rx = 1; // stop bit


end

always #50 s_tick = ~s_tick;
endmodule