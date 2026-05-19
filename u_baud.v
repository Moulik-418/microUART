`timescale 1ns / 1ps
module u_baud#(parameter baud_rate = 9600)(clk, sys_clk, sys_rst_l);
    input sys_clk, sys_rst_l;
    output reg clk;
    //output integer baud_count;

    localparam integer clk_value = 50000000;
  localparam integer clk_count  = (clk_value/(baud_rate*16*2));
      integer count;

    always@(posedge sys_clk or negedge sys_rst_l)begin 
     if(!sys_rst_l) begin 
        clk <= 1'b0;
        count <= 0;
     end
     
     else begin 
      // baud_count <= (clk_value/baud_rate);
       if(count >= (clk_count) -1)begin 
          clk<= ~clk;
          count <= 0;
       end
       else count <= count +1;
     end
     end
     
  endmodule
