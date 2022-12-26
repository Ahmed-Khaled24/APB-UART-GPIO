module baud_gen(
  input clk,reset,
  input [10:0] divsr,//max baudrate 9600 as div =650
  output reg tick
  );
  reg [10:0] count=11'b0;
  always@(posedge clk,posedge reset)
  begin
  if(reset)
    count=0;
  else
    begin
    if(count==divsr)
      begin
        count=0;
        tick=~tick;
      end
    else
      begin
        count=count+1;
        tick=0;
      end
    end
  end
endmodule

