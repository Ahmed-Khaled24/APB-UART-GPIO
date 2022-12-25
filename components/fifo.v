/*
    8 byte first in first out buffer
*/
module fifo (dataIn, readEn, writeEn, Full, Empty, dataOut, clk, reset);
    // Ports
    input [7:0] dataIn;
    input readEn, writeEn, clk, reset;
    output reg [7:0] dataOut;
    output Empty, Full;
    // Internals
    reg [7:0] buffer [7:0];
    reg [3:0] counter = 0;
    reg [3:0] readCoutner = 0, writeCounter = 0;

    assign Full = (counter == 8 ? 1 : 0);
    assign Empty = (counter == 0 ? 1 : 0);

    always @(posedge clk) begin

        if(reset) begin
            readCoutner = 0;
            writeCounter = 0;
        end 
        else if (readEn == 1 && !Empty) begin
            dataOut = buffer[readCoutner];
            readCoutner = readCoutner + 1;
        end
        else if (writeEn == 1 && !Full) begin
            buffer[writeCounter] = dataIn;
            writeCounter = writeCounter + 1;
        end 

        // Update the counter
        if(readCoutner > writeCounter) 
            counter = readCoutner - writeCounter;
        if(readCoutner < writeCounter) 
            counter = writeCounter - readCoutner; 

        // Reset counters
        if(writeCounter == 8) 
            writeCounter = 0;
            
        if(readCoutner == 8) 
            readCoutner = 0;

     
    end

endmodule