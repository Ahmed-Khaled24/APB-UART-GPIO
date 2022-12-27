`timescale 1ns/1ns
module UART_APB_interface(
    // APB side
    input PCLK,          
    input PRESETn,       
    input [31:0] PADDR,    
    input [31:0] PWDATA, 
    input PSELx,
    input PWRITE,
    input PENABLE,
    output reg [31:0] PRDATA, 
    output reg PREADY,
    // UART side
    input [7:0] rx_fifo_dataOut, 
    input rx_fifo_Full,
    input rx_fifo_Empty,
    input tx_fifo_Full,
    output reg tx_fifo_writeEn, 
    output reg rx_fifo_readEn,  
    output [7:0] tx_fifo_dataIn,  
    output reg reset
);
localparam cycleDuration = 15;

assign tx_fifo_dataIn = PWDATA[7:0];
assign rx_fifo_dataOut = PRDATA[7:0];

always @(posedge PCLK, posedge PRESETn) begin
    if(PSELx && PRESETn) begin
        reset = 1;
        #cycleDuration
        reset = 0;
    end
    else if(PSELx && PENABLE) begin
        case(PWRITE) 
            1: begin // write operation to the tx FIFO
                /* 
                    if the transmitter buffer is full uart cannot accept more data
                    the master need to wait for a space in tx buffer,
                */ 
                PREADY = ~tx_fifo_Full;
                tx_fifo_writeEn = 1;
                #cycleDuration
                tx_fifo_writeEn = 0;
            end
            0: begin // read from rx FIFO
            /*
                if the receiver buffer is empty, there is no data to read from 
                the buffer.
                the master need to wait for the next data to be received 
                then it can read it.
            */
                PREADY = ~rx_fifo_Empty;
                rx_fifo_readEn = 1;
                #cycleDuration
                rx_fifo_readEn = 0;
            end
        endcase
    end
    else if (!PENABLE) begin
        PREADY = 0;
    end
end


endmodule