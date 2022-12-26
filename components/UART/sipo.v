module sipo(clk,rst,DataIn,DataOut);
  input clk,rst;
  input DataIn;
  output reg [7:0]DataOut;
  reg [7:0]temp;
  always @(posedge clk)
  begin 
    if(!rst)
      temp=8'b00000000;
    else
      begin
         temp=temp<<1;
         temp[0]=DataIn;
         DataOut=temp;
      end
   end
   
endmodule

