module ack_checker (clk, g_rst, ack_slt, sampled_bit, arbtr_sts,
 act_err_frm_tx, psv_err_frm_tx, tx_success, ack_err);

input clk;
input g_rst;
input ack_slt;
input act_err_frm_tx;
input psv_err_frm_tx;
input arbtr_sts;
input tx_success;
input sampled_bit;
output ack_err;
reg ack_err;

always @ (posedge clk or posedge g_rst)
 begin
 if (g_rst)
 ack_err <= 1'b0;
 else if (tx_success || act_err_frm_tx || psv_err_frm_tx)
 ack_err <= 1'b0;
 else if (arbtr_sts && ack_slt && sampled_bit)
 ack_err <= 1'b1;
 else ack_err <= 1'b0;
 end
endmodule 