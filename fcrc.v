module fcrc_checker (clk, g_rst, rx_success, act_err_frm_tx,
psv_err_frm_tx, rx_fcrc_frm,rcvd_fcrc_flg, fcrc, fcrc_err,sec);

input clk;
input g_rst;
input rx_success;
input act_err_frm_tx;
input psv_err_frm_tx;
input rcvd_fcrc_flg;
input [31:0] fcrc;
input [31:0] rx_fcrc_frm;
input sec;
output fcrc_err;

reg fcrc_err;

// Always block to generate crc error signal
always @ (posedge clk or posedge g_rst)
 begin
 if (g_rst)
 fcrc_err <= 1'b0;
 else if (rx_success || act_err_frm_tx || psv_err_frm_tx || sec )
 fcrc_err <= 1'b0;
   else if (rcvd_fcrc_flg)
 begin
   if (fcrc != rx_fcrc_frm)
 fcrc_err <= 1'b1;
 else fcrc_err <= 1'b0;
 end
 else fcrc_err <= 1'b0;
 end
endmodule 