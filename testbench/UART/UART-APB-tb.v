`include "components/UART/UART-APB.v"
`timescale 1ns/1ns
module UART_APB_tb;
    reg [31:0] PADDR;
    reg [31:0] PWDATA;
    wire [31:0] PRDATA;
    reg PSELx;
    reg PENABLE;
    reg PWRITE;
    reg PRESETn;
    wire PREADY;
    reg PCLK = 0;
    reg rx;
    wire tx;

UART_APB u (
    .PADDR(PADDR),
    .PWDATA(PWDATA),
    .PRDATA(PRDATA),
    .PSELx(PSELx),
    .PENABLE(PENABLE),
    .PWRITE(PWRITE),
    .PRESETn(PRESETn),
    .PREADY(PREADY),
    .PCLK(PCLK),
    .rx(rx),
    .tx(tx)
);

initial begin
    $dumpfile("uart_apb.vcd");
    $dumpvars(0, u);

    PENABLE <= 1;


    PSELx <= 1;
    PWRITE <= 0;

    // read operation rx fifo not empty
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
    PSELx <= 0;
    #104166


    PSELx <= 1;
    PWDATA <= 8'b01010101;
    PWRITE <=1 ;
end

always #5 PCLK = ~ PCLK;
endmodule