
module TB_Avalon_slave_interface();

reg avl_clk, avl_rst_n,avl_read,avl_write,avl_beginbursttransfer;
reg [9:0]avl_address;
reg [7:0]avl_writedata;
reg [9:0]avl_burstcount;
wire [7:0]avl_readdata;
wire avl_readdatavalid;

Avalon_slave_interface uut (  

.avl_clk(avl_clk),
.avl_rst_n(avl_rst_n),
.avl_address(avl_address),
.avl_read(avl_read),
.avl_readdata(avl_readdata),
.avl_readdatavalid(avl_readdatavalid),
.avl_writedata(avl_writedata),
.avl_write(avl_write),
.avl_burstcount(avl_burstcount),
.avl_beginbursttransfer(avl_beginbursttransfer)

);

initial begin  
    avl_clk = 0;  
    forever #10 avl_clk = ~avl_clk;  
end 

initial begin 
avl_clk=1'b0;
avl_rst_n=1'b0;
avl_read=1'b0;
avl_write=1'b0;
avl_beginbursttransfer=1'b0;
avl_address=10'b0000000000;
avl_writedata=8'b00000000;
avl_burstcount=10'b0000000000;
@(posedge avl_clk) ;
//simple write state one 
avl_rst_n=1'b1;
avl_read=1'b0;
avl_write=1'b1;
avl_beginbursttransfer=1'b0;
avl_address=10'b0000000000;
avl_writedata=8'b00000111;
avl_burstcount=10'b0000000000; 
@(posedge avl_clk) ;
//simple write state two
avl_rst_n=1'b1;
avl_read=1'b0;
avl_write=1'b1;
avl_beginbursttransfer=1'b0;
avl_address=10'b0000000001;
avl_writedata=8'b00000111;
avl_burstcount=10'b0000000000; 
@(posedge avl_clk) ;
//simple write state three
avl_rst_n=1'b1;
avl_read=1'b0;
avl_write=1'b1;
avl_beginbursttransfer=1'b0;
avl_address=10'b0000000010;
avl_writedata=8'b00000111;
avl_burstcount=10'b0000000000; 
@(posedge avl_clk) ;
//simple write state four
avl_rst_n=1'b1;
avl_read=1'b0;
avl_write=1'b1;
avl_beginbursttransfer=1'b0;
avl_address=10'b0000000011;
avl_writedata=8'b00000111;
avl_burstcount=10'b0000000000; 
@(posedge avl_clk);
//simple read state one 
avl_rst_n=1'b1;
avl_read=1'b1;
avl_write=1'b0;
avl_beginbursttransfer=1'b0;
avl_address=10'b0000000000;
avl_writedata=8'b00000000;
avl_burstcount=10'b0000000000; 
@(posedge avl_clk);
//simple read state two
avl_rst_n=1'b1;
avl_read=1'b1;
avl_write=1'b0;
avl_beginbursttransfer=1'b0;
avl_address=10'b0000000001;
avl_writedata=8'b00000000;
avl_burstcount=10'b0000000000; 
@(posedge avl_clk);     
//burst read
avl_rst_n=1'b1;
avl_read=1'b1;
avl_write=1'b0;
avl_beginbursttransfer=1'b1;
avl_address=10'b0000000000;
avl_writedata=8'b00000000;
avl_burstcount=10'b0000000100; 

@(posedge avl_clk); 
@(posedge avl_clk);
@(posedge avl_clk);
@(posedge avl_clk);

@(posedge avl_clk); 
//burst write    
avl_rst_n=1'b1;
avl_read=1'b0;
avl_write=1'b1;
avl_beginbursttransfer=1'b1;
avl_address=10'b0000000000;
avl_writedata=8'd1;
avl_burstcount=10'b0000000100;
@(posedge avl_clk); 
//burst write    
avl_rst_n=1'b1;
avl_read=1'b0;
avl_write=1'b0;
avl_beginbursttransfer=1'b0;
//avl_address=10'b0000000000;
avl_writedata=8'd2;
avl_burstcount=10'b0000000000;
@(posedge avl_clk); 
//burst write    
avl_rst_n=1'b1;
avl_read=1'b0;
avl_write=1'b0;
avl_beginbursttransfer=1'b0;
//avl_address=10'b0000000000;
avl_writedata=8'd3;
avl_burstcount=10'b0000000000;
@(posedge avl_clk); 
//burst write    
avl_rst_n=1'b1;
avl_read=1'b0;
avl_write=1'b0;
avl_beginbursttransfer=1'b0;
//avl_address=10'b0000000000;
avl_writedata=8'd4;
avl_burstcount=10'b0000000000;
end 
endmodule 