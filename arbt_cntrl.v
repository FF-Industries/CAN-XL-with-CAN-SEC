module arbtr_ctrl(osc_clk, g_rst, arbtr_fld, rcvd_lst_bit_ifs,
txed_lst_bit_ifs, ovld_err_tx_cmp, tx_buff_busy, bt_ack_err_pre,
bit_destf_intl, dt_rm_frm_tx, sampling_pt, can_bus_out, can_bus_in,
act_err_frm_tx, psv_err_frm_tx, adh, dah, arbtr_sts, msg_due_tx, speed_status);

input osc_clk;
input g_rst;
input arbtr_fld;
input rcvd_lst_bit_ifs;
input txed_lst_bit_ifs;
input ovld_err_tx_cmp;
input tx_buff_busy;
input bt_ack_err_pre;
input bit_destf_intl;
input dt_rm_frm_tx;
input sampling_pt;
input can_bus_out;
input can_bus_in;
input act_err_frm_tx;
input psv_err_frm_tx;
input adh;
input dah;
  
output arbtr_sts;
output msg_due_tx;
output speed_status;

reg arbtr_sts;
reg msg_due_tx;
reg speed_status;

// block to send speed_status
always @ (posedge osc_clk or posedge g_rst)
begin
	if(g_rst)
		begin 
		speed_status<= 1'b0;
		end
	else if(adh)
		begin 
		speed_status<= 1'b1;
		end
	else if(dah)
		begin 
		speed_status<= 1'b0;
		end
	else 
		begin 
		speed_status<= speed_status;
		end
end
		
// block to send arbtr_sts signal
always @ (posedge osc_clk or posedge g_rst)
 begin
 if (g_rst)
 begin
 arbtr_sts <= 1'b1;
 msg_due_tx <= 1'b0;
 end
 else if (ovld_err_tx_cmp)
 begin
 arbtr_sts <= 1'b1;
 msg_due_tx <= 1'b0;
 end
 else if ((rcvd_lst_bit_ifs || txed_lst_bit_ifs) && (~(act_err_frm_tx || psv_err_frm_tx)))
 begin
 arbtr_sts <= 1'b1;
 msg_due_tx <= 1'b0;
 end
 else if ((arbtr_sts && tx_buff_busy
 && bt_ack_err_pre) ||
 (arbtr_sts && tx_buff_busy && bit_destf_intl && 
 (~dt_rm_frm_tx)))
 begin
 arbtr_sts <= 1'b0;
 msg_due_tx <= 1'b1;
 end
 else if (arbtr_sts && (~tx_buff_busy) && bit_destf_intl &&
 (~dt_rm_frm_tx))
 begin
 arbtr_sts <= 1'b0;
 msg_due_tx <= 1'b0;
 end
 else if (sampling_pt && tx_buff_busy && arbtr_sts && arbtr_fld &&
 (can_bus_out != can_bus_in))
 begin
 arbtr_sts <= 1'b0;
 msg_due_tx <= 1'b1;
 end
 else begin
 arbtr_sts <= arbtr_sts;
 msg_due_tx <= msg_due_tx;
 end
 end
endmodule 
