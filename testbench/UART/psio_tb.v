`include "components/UART/piso.v"

module piso_tb;
  reg clk;
  reg control;
  reg [7:0]DataIn;
  wire DataOut;
  Piso piso(clk,control,DataIn,DataOut);
  initial
  begin
    clk=0;
    control<=0;
    DataIn<=8'b01010101;
    #2
    control<=1;
  end
  always
  begin
    #1
    clk<=~clk;
  end
endmodule
