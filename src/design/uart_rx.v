
`timescale 1ns / 1ps

module uart_rx#(parameter width = 4'd8, parameter integer baud_rate = 9600)(clk,sys_rst_l, uart_REC_dataH, rec_readyH, rec_busy, rec_dataH );
input clk, sys_rst_l, uart_REC_dataH;
output reg [width-1:0]rec_dataH;
output reg rec_readyH;
output reg rec_busy;

wire clk;
reg [3:0]i;
reg [width-1:0]tmp_data;
reg [1:0]states;
integer count;

localparam IDLE = 2'd0, REC_DATA = 2'd1, STOP = 2'd2;
//assign rec_busy = (states == REC_DATA || states == STOP)?1'b1 : 1'b0;

  
always@(posedge clk or negedge sys_rst_l)begin 
if(!sys_rst_l)begin 
    rec_dataH <= {width{1'b0}};
    rec_readyH <= 1'b1;
    i <= 4'd0;
    tmp_data <= {width{1'b0}};
    states <= 2'd0;
    count <= 0;
    rec_busy <= 1'b0;
end
else begin 

case(states)
    IDLE : begin 
        rec_busy <= 1'b0;
       rec_dataH <= tmp_data;
       rec_readyH <= 1'b1;
      if(!uart_REC_dataH)begin 
        if(count >= 7)begin 
                count <= 0;
                states <= REC_DATA;
                rec_readyH <= 1'b0;
            end
            else count <= count +1;
         end
         else begin 
         count <= 0;
         states <= IDLE;
         i <= 0;
         end
            
    end
    
    REC_DATA : begin 
        rec_readyH <= 1'b0
       rec_busy <= 1'b1;
      if(count >= 15)begin 
      tmp_data[i] <= uart_REC_dataH;        
          count <= 0;
        if(i >= (width-1))begin 
            i <= 0;
            states <= STOP;
        end
        else 
            i <= i +1;
    end
    else count <= count + 1;
    end
    
    STOP : begin 
      if(count >= 7)begin
                states <= IDLE;
                count <= 0;

                if(uart_REC_dataH == 1'b1)begin 
                     rec_readyH <= 1'b1;
                     rec_busy <= 1'b0;    
                     rec_dataH <= tmp_data;

                end
                else rec_readyH <= 1'b0;
            end 
            else begin 
                count <= count +1;
            end
    end

endcase

end
end
endmodule
