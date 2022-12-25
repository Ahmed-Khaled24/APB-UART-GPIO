`include "components/baud-rate-generator.v"
`timescale 1ns/1ns
module baud_gen_tb;
  reg clk;
  reg rst;
  reg [10:0]divsr;
  wire tick;
  baud_gen gen(clk,rst,divsr,tick);
  initial
  begin
    $dumpfile("baud_gen.vcd");
    $dumpvars(0, gen);
    clk=0;
    divsr=16'd65;
    rst=0;
    #100
    rst=1;
    end
  always
  begin
    #50
    clk<=~clk;
  end
endmodule



