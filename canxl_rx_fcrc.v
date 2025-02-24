module canxl_rx_fcrc (clk, g_rst, data, fcrc_enable, initialize, tx_success,
rx_success, rcvd_bt_cnt, fcrc_frm);
input clk;
input g_rst;
input data;
input fcrc_enable;
input initialize;
input tx_success;
input rx_success;
input [14:0] rcvd_bt_cnt;
output [31:0] fcrc_frm;
reg [31:0] fcrc_frm;
wire fcrc_next;
wire [31:0] fcrc_tmp;
reg [14:0] prev_rcvd_bt_cnt;

  assign fcrc_next = data ^ fcrc_frm[31];
  assign fcrc_tmp = {fcrc_frm[30:0], 1'b0};

always @ (posedge clk or posedge g_rst)
begin
 if(g_rst)
 begin 
 fcrc_frm <= 32'h0;
 prev_rcvd_bt_cnt <= 15'h0;
 end 
 else if (tx_success || rx_success)
 begin
 fcrc_frm <= 32'h0;
 prev_rcvd_bt_cnt <= rcvd_bt_cnt;
 end
 else if (initialize)
 begin
 fcrc_frm <= 32'h0;
 prev_rcvd_bt_cnt <= rcvd_bt_cnt;
 end 

else if (fcrc_enable && (rcvd_bt_cnt != prev_rcvd_bt_cnt))
    begin
        if (fcrc_next)
        begin
            fcrc_frm <= fcrc_tmp ^ 32'h90BF6B5E;
        end
        else
        begin
            fcrc_frm <= fcrc_tmp;
        end
        prev_rcvd_bt_cnt <= rcvd_bt_cnt;
    end
end
endmodule 
