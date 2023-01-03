`include "components/UART/receiver.v"
`include "components/UART/transmitter.v"
`include "components/UART/fifo.v"
`include "components/UART/baud-rate-generator.v"

module UART (
    input [10:0] baud_final_value,
    input [7:0] tx_fifo_dataIn,
    input clk,
    input reset,
    input tx_fifo_writeEn,
    input rx_fifo_readEn,
    input rx,
    output tx_fifo_Full,
    output tx,
    output rx_fifo_Empty,
    output [7:0] rx_fifo_dataOut
);

baud_gen baud_generator (
    .clk(clk),
    .divsr(baud_final_value),
    .reset(reset)
);

fifo tx_fifo (
    .clk(clk),
    .dataIn(tx_fifo_dataIn),
    .reset(reset),
    .readEn(transmitter.tx_done_tick),
    .writeEn(tx_fifo_writeEn),
    .FULL(tx_fifo_Full)
);

Transmitter transmitter (
    .tx_start(~tx_fifo.EMPTY),
    .s_tick(baud_generator.tick),
    .tx_dataIn(tx_fifo.dataOut),
    .tx_dataOut(tx)
);

fifo rx_fifo (
    .clk(clk),
    .reset(reset),
    .dataIn(receiver.rx_dataOut),
    .writeEn(receiver.rx_doneTick),
    .readEn(rx_fifo_readEn),
    .dataOut(rx_fifo_dataOut),
    .EMPTY(rx_fifo_Empty)
);

receiver receiver (
    .clk(clk),
    .rx(rx),
    .s_tick(baud_generator.tick)
);

endmodule