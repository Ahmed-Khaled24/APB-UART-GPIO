`include "APB_Protocol.v"

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
        #10;
        // Select the first slave peripheral
        Psel = 2'b01;
        transfer = 1'b1;
        // Wait for the APB protocol module to stabilize
        #30;
        // Write a value to the slave peripheral's memory
        penable = 1'b1;
        pwrite = 1'b1;
        write_paddr = 1'b1;
        write_data = 32'hABCD1234;
        #10
        penable = 1'b0;

        // Select the second slave peripheral UART
        Psel = 2'b10;
        transfer = 1'b1;
        // Wait for the APB protocol module to stabilize
        #30;
        // send byte using uart transmitter
        penable = 1'b1;
        write_data[7:0] = 8'b10101010;
        pwrite = 1'b1;
        #10
        
        // Read a value from the slave peripheral's memory
        // penable = 1'b1;
        pwrite = 1'b0;
        apb_read_paddr = 1'b1;
        #30; 
        pwrite = 1'b1;
        write_paddr = 2'b10;
        write_data = 32'hAAA;
        #30;
        pwrite=1'b0;
        apb_read_paddr = 2'b10;
        #30;
        Psel = 1'b0;
         #10
        // Check the output value

        // receive 
        Psel = 2'b10;
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
        #10
        penable = 1'b0;
    end

    // Clock generator
    always #5 pclk <= ~pclk;
endmodule