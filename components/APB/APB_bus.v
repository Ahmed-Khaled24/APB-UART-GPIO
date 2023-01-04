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
    output reg [31:0] apb_read_data,
    // Issue an Error 
    output reg PSLVERR,
    // Know The Type of Error
    output reg [2:0] Error_Identify

);
reg [2:0] CurrentState=IDLE, NextState=IDLE;
localparam IDLE = 2'b00, SETUP = 2'b01, Access = 2'b10 ;
localparam Setup_Error = 3'b001 ,Invalid_Addr = 3'b010  , Invalid_PWrite = 3'b011 ;
reg [2:0] Error_Identify_Check;

// Choose Psel depend on Tb and send it to Slaves
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
        PSLVERR <= 0;
        Error_Identify <= 0;
        apb_read_data <= 0;
        PSEL1 <= 0;
        PSEL2 <= 0;
        penable <= 0;
    end
    else begin
        CurrentState <= NextState;
    end
end

always @(*) begin
    Error_Identify_Check <= 0;
    // Check if go From IDLE to Access in No Time this Setup Error 
    if (CurrentState == IDLE && NextState == Access ) begin
        Error_Identify_Check <= Error_Identify_Check || Setup_Error;
    end
    // Check if Write or Read Not Correct
    if (CurrentState == SETUP) begin
        if (pwrite_Master != pwrite) begin
            Error_Identify_Check <= Error_Identify_Check || Invalid_PWrite ;
        end
        else begin
            if (pwrite && (paddr != write_paddr_Master || pwdata != write_data_Master)) begin
                // Error_Identify_Check <= Error_Identify_Check || Invalid_Addr ;
            end
            else if(!pwrite && (paddr != read_paddr_Master)) begin
                Error_Identify_Check <= Error_Identify_Check || Invalid_Addr ;
            end
        end       
    end

    if (Error_Identify_Check != 0) begin
        PSLVERR <= 1;
        Error_Identify <= Error_Identify_Check;
    end
    else begin
        PSLVERR <= 0;
        Error_Identify <= 0;
    end
      
    
end
endmodule