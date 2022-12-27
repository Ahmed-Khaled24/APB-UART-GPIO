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
    // write operation tx not full
    PENABLE <= 1;
    PSELx <= 1;
    PWRITE <= 1;
    PWDATA <= 8'b10101010;
    #10
    PENABLE <= 0;

    #20

    // write operation tx full 
    PENABLE <= 1;
    PSELx <= 1;
    PWRITE <= 1;
    PWDATA <= 8'b00110011;
    #10
    PENABLE <= 0;

end

always #5 PCLK = ~ PCLK;
endmodule