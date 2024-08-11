module ram(din,rx_valid,dout,tx_valid,clk,rst_n);

parameter MIN_DEPTH = 256;
parameter ADDR_SIZE = 8;

input [9:0] din;
input clk,rst_n,rx_valid;
output reg [7:0] dout;
output reg tx_valid;


reg [7:0] mem [0 : MIN_DEPTH-1];
reg [7:0] addr_reg;

always @(*) begin
    if (~rst_n) begin
        dout<=0;
        tx_valid<=0;
        addr_reg<=0;
    end
    else begin
        if (rx_valid) begin
            case (din[9:8])
                2'b00: begin 
                    addr_reg <= din[7:0];  // Store the address
                    tx_valid <= 1'b0; 
                end
                2'b01: begin
                    mem[addr_reg] <= din[7:0];  // Write to memory
                    tx_valid <= 1'b0; 
                end
                2'b10: begin 
                    addr_reg <= din[7:0]; 
                    tx_valid <= 1'b0; 
                end  // Read address setup
                2'b11: begin 
                    dout <= mem[addr_reg]; 
                    tx_valid <= 1'b1; 
                end  // Read from memory
            endcase
        end 
        
        else begin
            tx_valid <= 1'b0;  // Default tx_valid to 0 when rx_valid is not asserted
        end
    end
    
end

endmodule