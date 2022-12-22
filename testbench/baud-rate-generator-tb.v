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
    rst=0;
    #2
    rst=1;
    end
  always
  begin
    #1
    clk<=~clk;
  end
endmodule
