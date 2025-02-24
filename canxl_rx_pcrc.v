/* module canxl_rx_pcrc (clk, g_rst, data, pcrc_enable, initialize, tx_success,
rx_success, rcvd_bt_cnt, pcrc_frm);
input clk;
input g_rst;
input data;
input pcrc_enable;
input initialize;
input tx_success;
input rx_success;
input [14:0] rcvd_bt_cnt;
output [12:0] pcrc_frm;
reg [12:0] pcrc_frm;
wire pcrc_next;
wire [12:0] pcrc_tmp;
assign pcrc_next = data ^ pcrc_frm[12];
assign pcrc_tmp = {pcrc_frm[11:0], 1'b0};

always @ (posedge clk or posedge g_rst)
begin
 if(g_rst)
begin
 pcrc_frm <= 13'h0;
end
 else if (tx_success || rx_success)
 pcrc_frm <= 13'h0;
 else if (initialize)
 pcrc_frm <= 13'h0;
else if (pcrc_enable)
 begin
   if (pcrc_next)
begin
 pcrc_frm <= pcrc_tmp ^ 13'h19C7; 
end
 else
 begin
 pcrc_frm <= pcrc_tmp;
 end
 end
end
endmodule 
*/

module canxl_rx_pcrc (
    clk,
    g_rst,
    data,
    pcrc_enable,
    initialize,
    tx_success,
    rx_success,
    rcvd_bt_cnt,
    pcrc_frm
);
input clk;
input g_rst;
input data;
input pcrc_enable;
input initialize;
input tx_success;
input rx_success;
input [14:0] rcvd_bt_cnt;
output [12:0] pcrc_frm;
reg [12:0] pcrc_frm;
wire pcrc_next;
wire [12:0] pcrc_tmp;
reg [14:0] prev_rcvd_bt_cnt;

assign pcrc_next = data ^ pcrc_frm[12];
assign pcrc_tmp = {pcrc_frm[11:0], 1'b0};

always @ (posedge clk or posedge g_rst)
begin
    if (g_rst)
    begin
        pcrc_frm <= 13'h0;
        prev_rcvd_bt_cnt <= 15'h0;
    end
    else if (tx_success || rx_success)
    begin
        pcrc_frm <= 13'h0;
        prev_rcvd_bt_cnt <= rcvd_bt_cnt;
    end
    else if (initialize)
    begin
        pcrc_frm <= 13'h0;
        prev_rcvd_bt_cnt <= rcvd_bt_cnt;
    end
    else if (pcrc_enable && (rcvd_bt_cnt != prev_rcvd_bt_cnt))
    begin
        if (pcrc_next)
        begin
            pcrc_frm <= pcrc_tmp ^ 13'h19C7;
        end
        else
        begin
            pcrc_frm <= pcrc_tmp;
        end
        prev_rcvd_bt_cnt <= rcvd_bt_cnt;
    end
end
endmodule

