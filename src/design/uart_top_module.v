`timescale 1ns / 1ps

module uart_top_module#(parameter width = 4'd8, parameter integer baud_rate = 9600)(xmitH,sys_clk, sys_rst_l,xmitdataH, xmit_active, xmit_doneH, uart_xmit_dataH, uart_REC_dataH, rec_dataH, rec_readyH, rec_busy);
input [7:0]xmitdataH;
output xmit_active, xmit_doneH, rec_readyH, rec_busy;
output [7:0]rec_dataH;
input sys_clk, sys_rst_l, xmitH;
output uart_xmit_dataH;
input uart_REC_dataH;
wire clk;
u_baud#(.baud_rate(baud_rate))m1(.sys_clk(sys_clk), .clk(clk), .sys_rst_l(sys_rst_l));
uart_tx#(.width(width),.baud_rate(baud_rate))m2(.clk(clk), .sys_rst_l(sys_rst_l), .xmitH(xmitH), .xmitdataH(xmitdataH), .uart_xmit_dataH(uart_xmit_dataH), .xmit_doneH(xmit_doneH), .xmit_active(xmit_active));
uart_rx#(.width(width), .baud_rate(baud_rate))m3(.clk(clk),.sys_rst_l(sys_rst_l), .uart_REC_dataH(uart_REC_dataH), .rec_readyH(rec_readyH), .rec_busy(rec_busy), .rec_dataH(rec_dataH) );

endmodule
