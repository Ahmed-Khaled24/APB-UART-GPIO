module Transmitter
#( parameter DBit=8,SBit=16//to make 1 stop bit 
)
(
input tx_start,s_tick,
input [7:0]din,
output reg tx_done_tick,dout
);
reg [1:0]state;
reg[3:0]tickCounter;
reg[2:0]n;
localparam IDLE=0,Start=1,Data=2,Stop=3;
reg[7:0] data;//buffer
initial
begin
   state<=IDLE;
    n<=0;
    tickCounter<=0;
    dout<=1;
    data<=0;
    tx_done_tick<=0;
  end
  
always @(posedge s_tick,posedge tx_start)//as it start only in tx_start and s_tick
    case(state)
        IDLE:
         begin
            if(tx_start==1)
              begin
                state<=Start;
                tickCounter<=0;
                n<=0;
                data<=din;  
              end
          end
        Start:
          begin
            dout<=0;
            if(tickCounter<15)
              begin
                tickCounter<=tickCounter+1;
              end
            else
              begin
                tickCounter<=0;
                state<=Data;
                n<=n+1;
              end
           end
        Data:
           begin
             dout<=data[0];   
             if(tickCounter<15)
                 begin
                     tickCounter<=tickCounter+1;
                  end
             else
                 begin
                      tickCounter<=0;
                      data<=data>>1;
                      n<=n+1;
                      if(n==DBit-1)
                        begin
                          state<=Stop;
                        end
                  end
            end
        Stop:
          begin
            dout<=1;
            if(tickCounter<SBit-1)
                begin
                    tickCounter<=tickCounter+1;
                end
            else
                begin
                    tx_done_tick<=1;
                    state<=IDLE;
                    dout<=1;
                end
          end
    endcase
    
endmodule

