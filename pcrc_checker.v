module pcrc_checker (clk, g_rst, rx_success, act_err_frm_tx, psv_err_frm_tx, rx_pcrc_frm,rcvd_pcrc_flg, pcrc, pcrc_err);

input clk;
input g_rst;
input rx_success;
input act_err_frm_tx;
input psv_err_frm_tx;
input rcvd_pcrc_flg;
  input [12:0] pcrc;
  input [12:0] rx_pcrc_frm;
output pcrc_err;

reg pcrc_err;

// Always block to generate crc error signal
always @ (posedge clk or posedge g_rst)
 begin
 if (g_rst)
 pcrc_err <= 1'b0;
 else if (rx_success || act_err_frm_tx || psv_err_frm_tx)
 pcrc_err <= 1'b0;
   else if (rcvd_pcrc_flg)
 begin
   if (pcrc != rx_pcrc_frm)
 pcrc_err <= 1'b1;
 else pcrc_err <= 1'b0;
 end
 else pcrc_err <= 1'b0;
 end
endmodule 