`include "components/UART/sipo.v"

module sipo_tb;
  reg clk;
  reg rst;
  reg DataIn;
  wire[7:0]DataOut;
  sipo s(clk,rst,DataIn,DataOut);
  initial
  begin
    clk=0;
    DataIn=0;
    rst=0;
    #2
    rst=1;
    end
  always
  begin
    #1
    clk<=~clk;
  end
  always #2 DataIn=~DataIn;
endmodule
