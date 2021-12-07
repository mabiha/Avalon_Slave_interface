
module FSM (burst_read_on,burst_write_on,new_read_address,new_write_address,avl_clk,avl_rst_n,avl_address,avl_read,avl_readdata,avl_readdatavalid,avl_writedata,avl_write,avl_burstcount,avl_beginbursttransfer);

input burst_read_on;
input burst_write_on;
input [9:0] new_read_address;
input [9:0] new_write_address;

input avl_clk, avl_rst_n,avl_read,avl_write,avl_beginbursttransfer;
input [9:0]avl_address;
input [7:0]avl_writedata;
input [9:0]avl_burstcount;
output reg [7:0]avl_readdata;
output reg avl_readdatavalid;

reg [7:0] ram [0:1023];

parameter idle = 0; 
parameter simple_read = 1;
parameter simple_write = 2; 
parameter burst_read = 3; 
parameter burst_write = 4;
reg [2:0] state;
reg [2:0] next_state;

///state changing 
always @(posedge avl_clk)
     begin
       if (!avl_rst_n)
         state<=idle;
       else
         state<=next_state;
     end
       
// state assignment conditions for finite state machine 
always @ (*)
	begin
		case (state)
		    idle:	    
				begin
					if(avl_read && !burst_read_on )
						next_state = simple_read;
					else if(avl_write && !burst_write_on)
						next_state = simple_write;
                                        else if(burst_read_on)
						next_state = burst_read;
					else if(burst_write_on)
						next_state = burst_write;
                    else 
                        next_state = idle;	
                end
			simple_read:	    
				begin
					if(avl_read && !burst_read_on )
						next_state = simple_read;
					else if(avl_write && !burst_write_on)
						next_state = simple_write;
                                        else if(burst_read_on)
						next_state = burst_read;
					else if(burst_write_on)
						next_state = burst_write;
                    else 
                        next_state = idle;	
                end 				
			simple_write:
				begin 
					if(avl_write && !burst_write_on)
						next_state = simple_write;
					else if(avl_read && !burst_read_on )
						next_state = simple_read;
					else if(burst_read_on)
						next_state = burst_read;
					else if(burst_write_on)
						next_state = burst_write;	
                    else 
                        next_state = idle;	
                end						
			burst_read:
			    begin 
					if(burst_read_on)
						next_state = burst_read;
					if(avl_write && !burst_write_on)
						next_state = simple_write;
					else if(avl_read && !burst_read_on )
						next_state = simple_read;
					else if( burst_write_on)
					    next_state = burst_write;
                    else 
                        next_state = idle;
                end 						
			burst_write:
				begin
					if(burst_write_on)
						next_state = burst_write;
					else if(burst_read_on)
						next_state = burst_read;
					else if(avl_write && !burst_write_on)
						next_state = simple_write;
					else if(avl_read && !burst_read_on)
						next_state = simple_read;	
				    else 
                        next_state = idle;
				end 
			default: 
					    next_state = idle; 					
		endcase
	end

//Output logic for avalon slave interface
	
always @(*)
	begin
		case (state)
			idle:
          			begin
					avl_readdata = 0;
					avl_readdatavalid = 0;
					end
			simple_read:
				    begin
					avl_readdata = ram[avl_address];
					avl_readdatavalid = 1;
					end
			simple_write:
					ram[avl_address] = avl_writedata;
			burst_read:
				    begin
					avl_readdata = ram[new_read_address];
					avl_readdatavalid = 1;
					end 
			burst_write:
					ram[new_write_address] = avl_writedata;
			default:
				    begin
					avl_readdata = 0;
					avl_readdatavalid = 0;
					end
		endcase
	end
	
endmodule



/////Counter for write//////////////
module Counter_Avalon_write( avl_burstcount, avl_address, avl_beginbursttransfer,avl_write,avl_clk,avl_rst_n,expired_write,new_write_address,burst_write_on);
             input [9:0] avl_burstcount;
	     input [9:0] avl_address;
             input avl_beginbursttransfer;
	     input avl_write;
             input avl_clk;
             input avl_rst_n;
             output expired_write;
             output [9:0]new_write_address;
             output burst_write_on;
reg [9:0] count;

reg hold;

assign expired_write = (count == avl_burstcount - 10'd1) && (hold == 1'b1);
assign hold = 1'b0;

always @(posedge avl_clk )
begin
    if ((hold == 1'b0) && (avl_beginbursttransfer == 1'b1) && (avl_write == 1'b1)) begin
    hold <= 1'b1; 
    count <= 10'd0;
   end
   else if (hold == 1'b1) begin
        if (count == avl_burstcount - 10'd1) begin
        hold <= 1'b0; 
	end
   else begin
        count <= count + 10'd1;
   end
   end
end
assign burst_write_on = hold;
assign new_write_address = avl_address + count;
endmodule
///////////////////////////////////////////////////////
//////////////// counter for read//////////////////////////

module Counter_Avalon_read( avl_burstcount,avl_address,avl_beginbursttransfer,avl_read,avl_clk,avl_rst_n,expired_read,new_read_address,burst_read_on);
             input [9:0] avl_burstcount;
	     input [9:0] avl_address;
             input avl_beginbursttransfer;
	     input avl_read;
             input avl_clk;
             input avl_rst_n;
             output expired_read;
             output [9:0]new_read_address;
             output burst_read_on;
        
reg [9:0] count;

reg hold;

assign expired_read = (count == avl_burstcount - 10'd1) && (hold == 1'b1);
assign hold = 1'b0;

always @(posedge avl_clk )
begin
    if ((hold == 1'b0) && (avl_beginbursttransfer == 1'b1) && (avl_read == 1'b1)) begin
    hold <= 1'b1; 
    count <= 10'd0;
   end
   else if (hold == 1'b1) begin
        if (count == avl_burstcount - 10'd1) begin
        hold <= 1'b0; 
	end
   else begin
        count <= count + 10'd1;
   end
   end
end
assign burst_read_on = hold;
assign new_read_address = avl_address + count;
endmodule
/////////////////////////////////////////
//////////////////Integration 
module Avalon_slave_interface(avl_clk,avl_rst_n,avl_address,avl_read,avl_readdata,avl_readdatavalid,avl_writedata,avl_write,avl_burstcount,avl_beginbursttransfer);

input avl_clk, avl_rst_n,avl_read,avl_write,avl_beginbursttransfer;
input [9:0]avl_address;
input [7:0]avl_writedata;
input [9:0]avl_burstcount;
output [7:0]avl_readdata;
output avl_readdatavalid;

wire [9:0] new_read_address;
wire [9:0] new_write_address;
wire burst_read_on;
wire burst_write_on;

Counter_Avalon_write part1 ( avl_burstcount, avl_address, avl_beginbursttransfer,avl_write,avl_clk,avl_rst_n,expired_write,new_write_address,burst_write_on);
Counter_Avalon_read  part2 ( avl_burstcount, avl_address, avl_beginbursttransfer,avl_read,avl_clk,avl_rst_n,expired_read,new_read_address,burst_read_on);
FSM part3 (burst_read_on,burst_write_on,new_read_address,new_write_address,avl_clk,avl_rst_n,avl_address,avl_read,avl_readdata,avl_readdatavalid,avl_writedata,avl_write,avl_burstcount,avl_beginbursttransfer);
endmodule

