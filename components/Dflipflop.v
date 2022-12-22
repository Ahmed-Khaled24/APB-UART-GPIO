
module DFlipFlop(clk,D,Q);
  input clk;
  input D;
  output Q;
  reg Q;
  always@(posedge clk)
  begin
    Q <= D;
  end
endmodule
    




