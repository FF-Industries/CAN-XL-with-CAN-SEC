module form_checker (clk, g_rst, rx_success, act_err_frm_tx,
psv_err_frm_tx, rcvd_bt_cnt, rcvd_data_len, serial_in, frm_err);
input clk;
input g_rst;
input rx_success;
input act_err_frm_tx;
input psv_err_frm_tx;
input serial_in;
input [14:0] rcvd_bt_cnt;
input [13:0] rcvd_data_len;
output frm_err;

reg frm_err;

// Always block to generate form error signal
always @ (posedge clk or posedge g_rst)
 begin
 if (g_rst)
 frm_err <= 1'b0;
 else if (rx_success || act_err_frm_tx || psv_err_frm_tx)
 frm_err <= 1'b0;
 else if ((rcvd_bt_cnt == (12'd97 + rcvd_data_len + 12'd32 + 12'd8 + 12'd2))
 ||((rcvd_bt_cnt >= (12'd97 + rcvd_data_len + 12'd32 + 12'd8 + 12'd3))
 &&(rcvd_bt_cnt <= (12'd97 + rcvd_data_len + 12'd32 + 12'd8 + 12'd9 ))))
 begin
 if (~serial_in)
 frm_err <= 1'b1;
 else
 frm_err <= 1'b0;
 end
 else frm_err <= 1'b0;
 end
endmodule 


