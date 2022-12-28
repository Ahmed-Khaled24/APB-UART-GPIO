`include "components/UART/UART-APB-interface.v"
`timescale 1ns/1ns

module UART_APB_interface_tb;
    reg PCLK = 0;          
    reg PRESETn;       
    reg PSELx;
    reg PENABLE;
    reg PWRITE;
    reg  [31:0] PWDATA; 
    reg rx_fifo_Full;
    reg rx_fifo_Empty;
    reg tx_fifo_Full;
    reg [7:0] rx_fifo_dataOut;
    wire [31:0] PADDR;   


UART_APB_interface ua (
    .PCLK(PCLK),
    .PRESETn(PRESETn),
    .PADDR(PADDR),
    .PWDATA(PWDATA),
    .PSELx(PSELx),
    .PWRITE(PWRITE),
    .PENABLE(PENABLE),
    .rx_fifo_dataOut(rx_fifo_dataOut),
    .rx_fifo_Full(rx_fifo_Full),
    .rx_fifo_Empty(rx_fifo_Empty),
    .tx_fifo_Full(tx_fifo_Full)
);

initial begin
    $dumpfile("interface.vcd");
    $dumpvars(0, ua);

    rx_fifo_Full <= 0;


    // reset
    PRESETn <= 1;
    #10 
    PRESETn <= 0;

    #20

    // write operation tx not full
    tx_fifo_Full <= 0;
    PENABLE <= 1;
    PSELx <= 1;
    PWRITE <= 1;
    PWDATA <= 8'b10101010;
    #10
    PENABLE <= 0;

    #20

    // write operation tx full 
    tx_fifo_Full <= 1;
    PENABLE <= 1;
    PSELx <= 1;
    PWRITE <= 1;
    PWDATA <= 8'b00110011;
    #10
    PENABLE <= 0;

    #20

    // read operation rx fifo not empty
    rx_fifo_Empty <= 0;
    PENABLE <= 1;
    PSELx <= 1;
    PWRITE <= 0;
    rx_fifo_dataOut <= 8'b11110000;
    #10
    PENABLE <= 0;

    #20

    // read operation rx fifo empty
    rx_fifo_Empty = 1;
    PENABLE <= 1;
    PSELx <= 1;
    PWRITE <= 0;
    rx_fifo_dataOut <= 8'b11001100;
    #10
    PENABLE <= 0;
    
end

always #5 PCLK <= ~PCLK;
endmodule