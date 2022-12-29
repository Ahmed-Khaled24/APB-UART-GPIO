module GPIO
    (
input  clk , penable,pwrite,Psel,Reset,
input [31:0] pwdata,
input [4:0] paddr,
output reg pready,
output reg [31:0] gpio_out_data
    
);

reg[31:0] memory [0:31];
reg[4:0]read_address;

reg [2:0] CurrentState = IDLE;



localparam IDLE = 2'b00, SETUP = 2'b01, Access = 2'b10 ;


always @(*) begin
    if (Psel) begin
        if(penable)begin
          if(pwrite)begin
            read_address <= paddr;
            // memory <= pwdata;
             memory[read_address] <= pwdata;
          end
          else begin
            gpio_out_data <= memory[read_address];
            // gpio_out_data <= memory;
          end
        end
    end
end
always @(posedge Reset) begin

        pready <= 0;
        CurrentState <= IDLE;
    
end

always @(penable or Psel)begin
  if(penable && Psel)begin
    pready <= 1'b1; 
  end
  else begin
    pready <= 1'b0; 
    
  end
end
endmodule