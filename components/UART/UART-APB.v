`include "components/UART/UART-controller.v"
`include "components/UART/UART-APB-interface.v"

module UART_APB (
    input [31:0] PADDR,
    input [31:0] PWDATA,
    output [31:0] PRDATA,
    input PSELx,
    input PENABLE,
    input PWRITE,
    input PRESETn,
    output PREADY,
    input PCLK,
    input rx,
    output tx
);

UART uart (
    .tx_fifo_dataIn(interface.tx_fifo_dataIn),
    .tx_fifo_writeEn(interface.tx_fifo_writeEn),
    .rx_fifo_readEn(interface.rx_fifo_readEn),
    .tx_fifo_Full(interface.tx_fifo_Full),
    .reset(interface.PRESETn),
    .clk(PCLK),
    .baud_final_value(11'd650),
    .rx(rx),
    .tx(tx)
);

UART_APB_interface interface (
    .PADDR(PADDR),
    .PWDATA(PWDATA),
    .PRDATA(PRDATA),
    .PSELx(PSELx),
    .PENABLE(PENABLE),
    .PWRITE(PWRITE),
    .PREADY(PREADY),
    .PCLK(PCLK),
    .PRESETn(PRESETn),
    .rx_fifo_dataOut(uart.rx_fifo_dataOut),
    .rx_fifo_Empty(uart.rx_fifo_Empty),
    .tx_fifo_Full(uart.tx_fifo_Full)
);
  


endmodule