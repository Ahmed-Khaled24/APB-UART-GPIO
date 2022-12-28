module APB_Bridge (
    // Taken From Master (Cpu)
    input  pclk,
    input  penable_Master,
    input  pwrite_Master,
    input transfer_Master,
    input Reset,
    input [1:0] Psel,
    input [4:0]  write_paddr_Master,read_paddr_Master,
    input [31:0] write_data_Master,   

    //  inputs from Slave
    input pready_slave,
    input [31:0] prdata,

    // Outputs To Slaves
    output reg pwrite , penable,
    // pwdata = write_data_Master
    // paddr = write_paddr_Master or read_paddr_Master address depend on pwrite coming from master 
    output reg [31:0] pwdata,
    output reg[4:0]paddr,
    output reg PSEL1,PSEL2,

    // apb_read_data data to computer coming from reading slave 
    output reg [31:0] apb_read_data

);
reg [2:0] CurrentState=IDLE, NextState=IDLE;
localparam IDLE = 2'b00, SETUP = 2'b01, Access = 2'b10 ;

always @(Psel) begin
    case (Psel)
        1 : begin
          PSEL1 <= 1;
          PSEL2 <= 0;
        end 
        2 : begin
          PSEL1 <= 0;
          PSEL2 <= 1;
        end
        default: begin
            PSEL1 <= 0;
            PSEL2 <= 0;
        end 
    endcase
end
// Psel1 , Psel2 

//assign {PSEL1,PSEL2} = ((CurrentState != IDLE) ? (Psel == 1 ? {1'b0,1'b1} : {1'b1,1'b0}) : 2'd0);


always @(CurrentState,transfer_Master,pready_slave) begin   
            pwrite <= pwrite_Master; 
            case (CurrentState)
                IDLE: 
                    begin
                        penable = 0;
                        if (transfer_Master) begin
                            NextState <= SETUP;
                        end                       
                    end
                SETUP:
                    begin
                        penable = 0;
                        // if Master called Write Bus will send Address of Write else will send read Address
                        // write data in setup
                        if (pwrite_Master) begin
                            paddr <= write_paddr_Master;
                            pwdata <= write_data_Master;

                        end
                        else begin
                            paddr <= read_paddr_Master;
                        end
                        if (transfer_Master) begin
                            NextState <= Access;
                        end
                    end
                Access: 
                    begin
                        if (!PSEL1 && !PSEL2) begin
                            NextState <= IDLE;
                        end
                        else begin
                                penable = 1;
                                if (pready_slave) begin
                                    // Read Data from slave output to read_out 
                                    NextState <= SETUP; 
                                if (!pwrite_Master) begin
                                   apb_read_data <= prdata;
                                end

                                end
                        end
                    end
            endcase
end

always @(posedge pclk or posedge Reset) begin
    if (Reset) begin
        CurrentState <= IDLE;
    end
    else begin
        CurrentState <= NextState;
    end
end
endmodule