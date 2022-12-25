`timescale 1ns/1ns
module baud_gen_tb;
  reg clk;
  reg rst;
  reg [10:0]divsr;
  wire tick;
  baud_gen gen(clk,rst,divsr,tick);
  initial
  begin
    clk=0;
    divsr=11'd650;
    rst=1;
    #1
    rst=0;
    end
  always
  begin
    #5
    clk=~clk;
  end
endmodule


