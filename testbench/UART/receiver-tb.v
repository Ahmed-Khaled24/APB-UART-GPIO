`include "components/UART/receiver.v"
`include "components/UART/baud-rate-generator.v"
`include "components/UART/fifo.v"
`timescale 1ns/1ns
module receiver_tb;

reg clk = 0,
    s_tick = 0,
    rx = 1,
    readEn = 0;

baud_gen b1 (
    .divsr(11'd650),
    .clk(clk)
);

fifo f1(
    .dataIn(r1.rx_dataOut),
    .writeEn(r1.rx_doneTick),
    .clk(clk),
    .readEn(readEn)
);

receiver r1 (
    .clk(clk),
    .rx(rx),
    .s_tick(b1.tick)
);

initial begin
    $dumpfile("receiver.vcd");
    $dumpvars(0, receiver_tb);
    


    rx = 0; // start bit
    #104166
    rx = 1;
    #104166
    rx = 0;
    #104166
    rx = 1;
    #104166
    rx = 0;
    #104166
    rx = 1;
    #104166
    rx = 0;
    #104166
    rx = 1;
    #104166
    rx = 0;
    #104166
    rx = 1; // stop bit



    #104166
    rx = 0; // start bit
    for (integer i  = 0 ; i < 4 ; i ++) begin
        #104166
        rx = 1;
    end
    for (integer i  = 0 ; i < 4 ; i ++) begin
        #104166
        rx = 0;
    end
    #104166
    rx = 1; // stop bit



    #104166
    rx = 0; // start bit
    for (integer i  = 0 ; i < 8; i ++) begin
        #104166
        rx = 1;
    end
    #104166
    rx = 1; // stop bit



    #104166
    rx = 0; // start bit
    for (integer i  = 0 ; i < 4 ; i ++) begin
        #104166
        rx = 1;
    end
    for (integer i  = 0 ; i < 4 ; i ++) begin
        #104166
        rx = 0;
    end
    #104166
    rx = 1; // stop bit



    #104166
    rx = 0; // start bit
    for (integer i  = 0 ; i < 8; i ++) begin
        #104166
        rx = 1;
    end
    #104166
    rx = 1; // stop bit



    rx = 0; // start bit
    #104166
    rx = 1;
    #104166
    rx = 0;
    #104166
    rx = 1;
    #104166
    rx = 0;
    #104166
    rx = 1;
    #104166
    rx = 0;
    #104166
    rx = 1;
    #104166
    rx = 0;
    #104166
    rx = 1; // stop bit



    #104166
    rx = 0; // start bit
    for (integer i  = 0 ; i < 8; i ++) begin
        #104166
        rx = 1;
    end
    #104166
    rx = 1; // stop bit



    #104166
    rx = 0; // start bit
    for (integer i  = 0 ; i < 4 ; i ++) begin
        #104166
        rx = 1;
    end
    for (integer i  = 0 ; i < 4 ; i ++) begin
        #104166
        rx = 0;
    end
    #104166
    rx = 1; // stop bit



    #104166
    rx = 0; // start bit
    for (integer i  = 0 ; i < 8; i ++) begin
        #104166
        rx = 1;
    end
    #104166
    rx = 1; // stop bit

    
end

always #5 clk = ~clk;
endmodule