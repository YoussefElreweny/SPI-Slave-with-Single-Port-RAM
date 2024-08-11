module spi_slave (
    input clk,         // System clock
    input rst_n,       // Asynchronous reset, active low
    input mosi,        // Master-Out-Slave-In
    input ss_n,        // Slave Select, active low
    output reg miso,        // Master-In-Slave-Out
    output reg [9:0] rx_data, // Received data
    output reg rx_valid,    // Valid flag for received data
    input [7:0] tx_data, // Data to transmit
    input tx_valid     // Valid flag for data to transmit
);
// State encoding
localparam IDLE         = 3'b000,
           CHK_CMD      = 3'b001,
           WRITE        = 3'b010,
           READ_DATA    = 3'b011,
           READ_ADDRESS = 3'b100;

reg [9:0] shift_reg;
reg [2:0] cs,ns;
reg [3:0] bit_cnt;
reg read_data_or_addr; // 0 for address 1 for data
reg finished_read_flag;
reg [2:0] tx_bit_cnt; // Counter for tx_data bits
reg [3:0] flag=0;
reg flag2 =0;


//state memory
always @(posedge clk , negedge rst_n) begin
    if (~rst_n) begin
        cs<=IDLE;
    end
    else 
        cs<=ns;
end



// next state logic
always @(cs,mosi,ss_n) begin
    case (cs)

        IDLE: begin
            if (ss_n == 0) begin
                ns = CHK_CMD;
            end
            else ns = IDLE;
        end

        CHK_CMD: begin
            if (ss_n == 0) begin
                if (mosi == 0) begin
                    ns = WRITE;
                end else if(mosi == 1)begin
                    if (!read_data_or_addr) begin 
                        ns = READ_ADDRESS;
                    end else begin
                        ns = READ_DATA;
                    end
                end
            end
            else ns = IDLE;
        end

        WRITE: begin
            if (ss_n == 0 && bit_cnt <= 4'd10) begin
                ns = WRITE;
            end
            else ns = IDLE;
        end

        READ_ADDRESS: begin
            if (ss_n == 0 && bit_cnt <= 4'd10) begin
                ns = READ_ADDRESS;
            end
            else begin ns = IDLE; read_data_or_addr = 1;end
        end

        READ_DATA: begin
            if (ss_n == 0 && finished_read_flag == 0) begin
                ns = READ_DATA;
            end
            else begin ns = IDLE; read_data_or_addr = 0; end
        end
        default: ns = IDLE; 
    endcase
end

integer i=0;
//output logic
always @(posedge clk) begin
    
    
     
        case (cs)
                IDLE: begin    
                    bit_cnt <= 0;
                    rx_valid <= 0;
                    tx_bit_cnt <= 0;
                    finished_read_flag <= 0;
                    shift_reg <= 0;
                    read_data_or_addr <= 0;
                end

                CHK_CMD: begin
                    // No specific output logic for CHK_CMD
                end

                WRITE: begin
                    if (bit_cnt ==9) begin
                        rx_data <= shift_reg;
                        rx_valid <= 1;
                    end
                    else begin
                    shift_reg <= {shift_reg[8:0], mosi};
                    bit_cnt <= bit_cnt + 1;
                    end
                    
                end

                READ_ADDRESS: begin
                    
                    
                    shift_reg = {shift_reg[8:0], mosi};
                    bit_cnt = bit_cnt + 1; //9
                    if (bit_cnt == 10) begin
                        rx_data = shift_reg;
                        rx_valid = 1;
                        bit_cnt = bit_cnt + 1;
                    end
                    
                    
                end

                READ_DATA: begin

                    shift_reg = {shift_reg[8:0], mosi};
                    bit_cnt = bit_cnt + 1; //9
                    if (bit_cnt == 10) begin
                        rx_data = shift_reg;
                        rx_valid = 1;
                        bit_cnt = bit_cnt + 1;
                    end

                    if (tx_valid) begin
                    miso <= tx_data[7 - tx_bit_cnt];
                    tx_bit_cnt <= tx_bit_cnt + 1;
                    if (tx_bit_cnt == 7) begin
                        finished_read_flag <= 1;
                    end
                end else begin
                    miso <= 0; // Default value for miso
                end
                end

                default: begin
                    bit_cnt <= 0;
                    rx_valid <= 0;
                    miso <= 0;
                end
            endcase

end
endmodule