`timescale 1ns / 1ps
module uart_tx#(parameter width = 4'd8, parameter integer baud_rate = 9600)(clk, sys_rst_l, xmitH, xmitdataH, uart_xmit_dataH, xmit_doneH, xmit_active);
    input clk, sys_rst_l, xmitH;
    input [width-1:0]xmitdataH;
    output reg uart_xmit_dataH;
    output reg xmit_doneH;
    output xmit_active;

    wire clk;
    reg [width-1:0]data_out;
    reg [3:0]i;

    // BAUD CALCULATION
   // wire [31:0]tmp_baud_count;
    integer count_val;
	//integer baud_count;
    
    //states
    localparam IDLE = 2'd0, START = 2'd1, SEND_DATA = 2'd2, STOP = 2'd3 ;
    reg [1:0]states;

    //assign xmit_active = ((states == START) || (states == SEND_DATA))?1'b1:1'b0;
    
    always@(posedge clk or negedge sys_rst_l)begin 
      if(!sys_rst_l)begin 
        	states <= IDLE;
         	uart_xmit_dataH <= 1'b1;
        	data_out <= {width{1'b0}};
          	xmit_doneH <= 1'b1;
        	count_val <= 0;
        	i <= 0;
       // baud_count <= 0;
      end

      else begin
		//baud_count <= tmp_baud_count;
        
        case(states) 
          IDLE : begin
			xmit_active <= 1'b0;  
            uart_xmit_dataH <= 1'b1;
            if(xmitH)begin 
              xmit_doneH <= 1'b0;
              states <= START;
          end
          end

          START : begin 
			  xmit_active <= 1'b1;
            uart_xmit_dataH <= 1'b0;
            if(count_val >= 15)begin 
              data_out <= xmitdataH;
              states <= SEND_DATA;
              count_val <= 0;
            end
            else  count_val <= count_val +1;

          end

          SEND_DATA : begin 
            uart_xmit_dataH <= data_out[i] ;
			 xmit_active <= 1'b1;
            if(i < width-1)begin 
              if(count_val >= 15) begin 
                count_val <= 0;
                i <= i +1;
              end
              else begin 
                count_val <= count_val +1;
                i <= i;
              end

            end 
        else begin   // i == width-1
            if(count_val >= 15)begin
                i <= 3'd0;
                count_val <= 0;
                states <= STOP;
            end
            else count_val <= count_val + 1;
        end
          end

          STOP : begin 
            uart_xmit_dataH <= 1'b1;
            if(count_val >= 15)begin 
              count_val <= 0;
              xmit_doneH <= 1'b1;
			  xmit_active <= 1'b0;
              if(xmitH)
                states <= START;
              else 
              states <= IDLE;
            end
            else count_val <= count_val +1;

          end

          default : begin 
            states <= IDLE;
            count_val <= 0;
            i <= 3'd0;

          end
        endcase

      end
    end
  endmodule
