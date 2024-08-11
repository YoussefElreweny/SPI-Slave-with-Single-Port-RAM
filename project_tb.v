module project_tb();

reg mosi,ss_n,clk,rst_n;
wire miso;

project pr (.mosi(mosi),.miso(miso),.ss_n(ss_n),.clk(clk),.rst_n(rst_n));


initial begin
    clk=0;
    forever 
    #1 clk=~clk;
end

integer i = 0;
initial begin
    $readmemh("mem.txt",pr.m1.mem);
        rst_n = 0;
        //mosi = 0;
        

        // Reset the module
        @(negedge clk); rst_n = 1;

        // Deassert reset and start test
        
        
        // 10'b0000001101;// 13
        // Test case: Write address
        ss_n = 0;
        mosi = 1'b0; @(negedge clk); // Command for WRITE_ADDRESS
        mosi = 1'b0; @(negedge clk); // Address bit 9
        mosi = 1'b0; @(negedge clk); // Address bit 8
        mosi = 1'b0; @(negedge clk); // Address bit 7
        mosi = 1'b0; @(negedge clk); // Address bit 6
        mosi = 1'b0; @(negedge clk); // Address bit 5
        mosi = 1'b0; @(negedge clk); // Address bit 4
        mosi = 1'b1; @(negedge clk); // Address bit 3
        mosi = 1'b1; @(negedge clk); // Address bit 2
        mosi = 1'b0; @(negedge clk); // Address bit 1
        mosi = 1'b1; @(negedge clk); // Address bit 0
        ss_n = 1;    @(negedge clk); 
        
        
        // Test case: Write data 0x55 to address 13
        ss_n = 0;
        mosi = 1'b0; @(negedge clk); // Command for WRITE_DATA //b0000001101
        mosi = 1'b0; @(negedge clk); // Data bit 9
        mosi = 1'b1; @(negedge clk); // Data bit 8
        mosi = 1'b0; @(negedge clk); // Data bit 7
        mosi = 1'b0; @(negedge clk); // Data bit 6
        mosi = 1'b0; @(negedge clk); // Data bit 5
        mosi = 1'b0; @(negedge clk); // Data bit 4
        mosi = 1'b1; @(negedge clk); // Data bit 3
        mosi = 1'b0; @(negedge clk); // Data bit 2
        mosi = 1'b0; @(negedge clk); // Data bit 1
        mosi = 1'b0; @(negedge clk); // Data bit 0
        ss_n = 1;
        @(negedge clk);
        
        // Test case: Read address // 10'b0000001101;// 13
        ss_n = 0;@(negedge clk);
        mosi = 1'b1; @(negedge clk); // Command for read //b0000001101
        mosi = 1'b1; @(negedge clk); // Data bit 9
        mosi = 1'b0; @(negedge clk); // Data bit 8
        mosi = 1'b0; @(negedge clk); // Data bit 7
        mosi = 1'b0; @(negedge clk); // Data bit 6
        mosi = 1'b0; @(negedge clk); // Data bit 5
        mosi = 1'b0; @(negedge clk); // Data bit 4
        mosi = 1'b1; @(negedge clk); // Data bit 3
        mosi = 1'b1; @(negedge clk); // Data bit 2
        mosi = 1'b0; @(negedge clk); // Data bit 1
        mosi = 1'b1; @(negedge clk); // Data bit 0
        ss_n = 1;
        @(negedge clk);


        // read data in address 10'b0000001101;// 13
        ss_n = 0;@(negedge clk);
        mosi = 1'b1; @(negedge clk); // Command for READ_ADDRESS // b0000001101
        mosi = 1'b1; @(negedge clk); // Address bit 9
        mosi = 1'b1; @(negedge clk); // Address bit 8
        mosi = 1'b0; @(negedge clk); // Data bit 7
        mosi = 1'b0; @(negedge clk); // Data bit 6
        mosi = 1'b0; @(negedge clk); // Data bit 5
        mosi = 1'b0; @(negedge clk); // Data bit 4
        mosi = 1'b1; @(negedge clk); // Data bit 3
        mosi = 1'b1; @(negedge clk); // Data bit 2
        mosi = 1'b0; @(negedge clk); // Data bit 1
        mosi = 1'b1; @(negedge clk); // Data bit 0
        
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);@(negedge clk);
        @(negedge clk);
        @(negedge clk);ss_n = 1;
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);@(negedge clk);
        @(negedge clk);
        

        /*
        // Test case: Read data from address 0x01
        ss_n = 0;
        mosi = 1'b1; @(negedge clk); // Command for READ_DATA
        #80; // Wait for 8 clock cycles to read 8 bits
        ss_n = 1;
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);
        @(negedge clk);*/

        
        $stop;

end

endmodule
