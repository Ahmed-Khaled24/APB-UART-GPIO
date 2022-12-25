module fifo( clk, dataIn, readEn, writeEn, dataOut, reset, EMPTY, FULL); 

    input clk, readEn, writeEn, reset;
    output EMPTY, FULL;
    input [7:0] dataIn;

    output reg [7:0] dataOut; // internal registers 
    reg [3:0] counter = 0; 
    reg [7:0] FIFO [0:7]; 
    reg [2:0]  readPtr = 0, writePtr = 0; 

    assign EMPTY = (counter==0) ? 1'b1 : 1'b0; 
    assign FULL = (counter==8) ? 1'b1 : 1'b0; 

    always @ (posedge clk) begin 

        if (reset) begin 
            readPtr = 0; 
            writePtr = 0; 
        end 

        else if (readEn == 1'b1 && counter != 0) begin 
            dataOut = FIFO[readPtr]; 
            counter = counter - 1;
            readPtr = readPtr + 1; 
        end 


        else if (writeEn == 1'b1 && counter < 8) begin
            FIFO[writePtr] = dataIn; 
            counter = counter + 1;
            writePtr = writePtr + 1; 
        end 


        if (writePtr == 8) 
            writePtr = 0; 
        else if (readPtr == 8) 
            readPtr = 0; 

    end 

endmodule