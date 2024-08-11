module project(mosi,miso,ss_n,clk,rst_n);

input mosi,clk,rst_n,ss_n;
output miso;
//spi wires
wire ss_n,rx_valid,tx_valid;
wire [9:0] rx_data;
wire [7:0] tx_data;


spi_slave_2 spi (.clk(clk),.rst_n(rst_n),.mosi(mosi),.miso(miso),.ss_n(ss_n),.rx_data(rx_data),.rx_valid(rx_valid),.tx_data(tx_data),.tx_valid(tx_valid));

ram m1 (.din(rx_data),.rx_valid(rx_valid),.dout(tx_data),.tx_valid(tx_valid),.clk(clk),.rst_n(rst_n));
endmodule