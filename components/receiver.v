`timescale 1ns/1ns

module receiver(rx, s_tick, rx_dataOut, rx_doneTick, clk);
parameter numberOfDataBits = 8;
parameter stopBitTicks = 16;

input wire clk, rx, s_tick /* Baud rate clk */;
output reg [7:0] rx_dataOut;
output reg rx_doneTick;

reg [1:0] state;
// Idle  00
// Start 01
// Data  10
// Stop  11

reg [3:0] tickCounter = 0;
reg [2:0] receivedBitsCounter = 0;
reg [7:0] recieverBuffer = 0;

initial begin
    state = 2'b00;
    rx_dataOut = 0;
    rx_doneTick = 0;
end

always @(posedge s_tick) begin
    case(state) 

        2'b00: begin // Idle
            if(rx == 0) begin
                tickCounter = 0;
                state = 2'b01;
            end
        end

        2'b01: begin // Start
            if(tickCounter == 7) begin
                tickCounter = 0;
                receivedBitsCounter = 0;
                state = 2'b10;
            end
            else begin
                tickCounter = tickCounter + 1;
            end
        end

        2'b10: begin // Data
            if(tickCounter == 15) begin
                tickCounter = 0;
                recieverBuffer = { rx, recieverBuffer[numberOfDataBits-1 : 1] }; //shift right;
                if(receivedBitsCounter == numberOfDataBits - 1) begin
                    state = 2'b11;
                end
                else begin
                    receivedBitsCounter = receivedBitsCounter + 1;
                end
            end
            else begin
                tickCounter = tickCounter + 1;
            end
        end

        2'b11: begin // Stop
            if(tickCounter == stopBitTicks-1) begin
                rx_dataOut = recieverBuffer;
                rx_doneTick = 1;
                #15
                rx_doneTick = 0;
                state = 2'b00;

            end
            else begin
                tickCounter = tickCounter + 1;
            end
        end

        default: ;

    endcase
end  
endmodule