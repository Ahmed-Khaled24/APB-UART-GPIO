`include "components/APB/APB_Protocol.v"

`timescale 1ns/1ns

module APB_Protocol_tb;
    // Inputs
    reg pclk;
    reg penable;
    reg pwrite;
    reg transfer;
    reg Reset;
    reg [4:0] write_paddr;
    reg [4:0] apb_read_paddr;
    reg [31:0] write_data;
    reg [1:0] Psel;
    reg rx = 1;
    // Outputs
    wire [31:0] apb_read_data_out;

    // Instantiate the APB protocol module
    APB_Protcol A1 (pclk, penable, pwrite, transfer, Reset, write_paddr, apb_read_paddr, write_data, Psel, apb_read_data_out,rx);

    // Test vectors
    initial begin
    $dumpfile("dump2.vcd");
    $dumpvars(0,APB_Protocol_tb);
        // Initialize input signals
        pclk = 1'b0;
        penable = 1'b0;
        pwrite = 1'b0;
        transfer = 1'b0;
        Reset = 1'b0;
        write_paddr = 32'h00000000;
        apb_read_paddr = 32'h00000000;
        write_data = 32'h00000000;
        Psel = 2'b00;
        // Wait for the APB protocol module to reset
        // Assert the reset signal
        // Reset = 1'b1;
        // Wait for the APB protocol module to reset
        // Deassert the reset signal
        // Reset = 1'b0;
        // Wait for the APB protocol module to stabilize
        #30;
        
    
        // ++++++++++++++++++++++++++++++++ GPIO ++++++++++++++++++++++++++++++++
       // Write hABCD1234 to the  memory address 1
        pwrite = 1'b1;
        transfer = 1'b1;
        Psel = 2'b01;
        write_paddr = 1'b1;
        write_data = 32'hABCD1234;


        #30;
        // Read a value from memory address 1
        Psel = 2'b01;
        pwrite = 1'b0;
        transfer=1;
        apb_read_paddr = 1'b1;


        #30;
        //write hAAA into memory address 2
        Psel=1;
        transfer =1;
        pwrite = 1'b1;
        write_paddr = 2'b10;
        write_data = 32'hAAA;

        #40;
        // Read a value from memory address 2
        Psel=1;
        transfer=1;
        pwrite=1'b0;
        apb_read_paddr = 2'b10;

        #10
        // ++++++++++++++++++++++++++++++++ UART test ++++++++++++++++++++++++++++++++
        Psel = 2'b10;
        transfer = 1'b1;
        #10;
    
        // Trasmitter
        // push 8 elemnts in tx_fifo, in the next push 
        // fifo is full then PREADY remains 0 till timeout
        pwrite = 1'b1;
        for(integer i = 0 ; i < 10 ; i++) begin
            #10
            write_data = $urandom % 256; // unsinged random number between 0 and 255
            penable = 1'b1;
            #10
            penable = 1'b0;
        end

        #100

        // Receiver 

        // try to read from rx_fifo while it is empty 
        // PREADY remains 0 till timeout
        penable = 1;
        pwrite = 0;
        #13
        penable = 0;

        #30

        // receive data then try to read from rx_fifo 
        // PREADY is 1 while rx_fifo is not empty
        // first byte
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
        pwrite = 1'b0;

        // second byte
        rx = 0; // start bit
        #104166
        rx = 0;
        #104166
        rx = 0;
        #104166
        rx = 1;
        #104166
        rx = 1;
        #104166
        rx = 0;
        #104166
        rx = 0;
        #104166
        rx = 1;
        #104166
        rx = 1;
        #104166
        rx = 1; // stop bit
        #104166

        pwrite = 1'b0;
        penable = 1'b1;
        #13
        penable = 1'b0;
        #100
        penable = 1'b1;
        #13
        penable = 1'b0;
        #100
        penable = 1'b1;
        #13
        penable = 1'b0;
    end


    always @(negedge A1.g1.pready) begin
        transfer =0;
        Psel=0;
    end


    // Clock generator
    always #5 pclk <= ~pclk;
endmodule
