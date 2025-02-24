module msg_processor (clk, g_rst, stf_err, bt_err, fcrc_err, pcrc_err, ack_err,
frm_err, rcvd_eof_flg, rcvd_lst_bit_ifs, dt_rm_eof_tx_cmp,
txed_lst_bit_ifs, ovld_err_tx_cmp, rcvd_data_len, rcvd_bt_cnt,
de_stuff, act_err_frm_tx, psv_err_frm_tx, tx_buff_busy, arbtr_sts,
msg_due_tx, serial_in, rx_buff_0_wrtn, rx_buff_1_wrtn, bt_ack_err_pre,
stf_frm_crc_err_pre, rx_eof_success, rx_success, tx_eof_success,
tx_success, re_tran, send_ack, txmtr, over_ld);

input clk;
input g_rst;
input stf_err;
input bt_err;
input pcrc_err;
input fcrc_err;  
input ack_err;
input frm_err;
input rcvd_eof_flg;
input rcvd_lst_bit_ifs;
input dt_rm_eof_tx_cmp;
input txed_lst_bit_ifs;
input ovld_err_tx_cmp;
input [13:0] rcvd_data_len;  
input [14:0] rcvd_bt_cnt;    
input de_stuff;
input act_err_frm_tx;
input psv_err_frm_tx;
input tx_buff_busy;
input arbtr_sts;
input msg_due_tx;
input serial_in;
input rx_buff_0_wrtn;
input rx_buff_1_wrtn;

output bt_ack_err_pre;
output stf_frm_crc_err_pre;
output rx_eof_success;
output rx_success;
output tx_eof_success;
output tx_success;
output re_tran;
output send_ack;
output txmtr;
output over_ld;
  
reg bt_ack_err_pre;
reg stf_frm_crc_err_pre;
reg rx_eof_success;
reg rx_success;
reg tx_eof_success;
reg tx_success;
reg re_tran;
reg send_ack;
reg txmtr;
reg over_ld;
reg msg_due_tx_reg;
reg tx_success_en;
reg rx_success_en;

// block to indicate if a stf crc or frm error occured
always @ (posedge clk or posedge g_rst)
 begin
 if (g_rst)
 stf_frm_crc_err_pre <= 1'b0;
 else if (ovld_err_tx_cmp)
 stf_frm_crc_err_pre <= 1'b0;
 else if ((rcvd_eof_flg || rcvd_lst_bit_ifs) && (~(act_err_frm_tx
 || psv_err_frm_tx)))
 stf_frm_crc_err_pre <= 1'b0;
   else if ((~arbtr_sts) && ((pcrc_err) || (fcrc_err) || (stf_err) || (frm_err)))
 stf_frm_crc_err_pre <= 1'b1;
 end

// block to indicate the succesful reception of mesage till the eof
always @ (posedge clk or posedge g_rst)
 begin
 if (g_rst)
 rx_eof_success <= 1'b0;
 else if (arbtr_sts || rx_success)
 rx_eof_success <= 1'b0;
 else if ((~arbtr_sts) && (rcvd_eof_flg) && (~stf_frm_crc_err_pre)
 && (~(act_err_frm_tx || psv_err_frm_tx)))
 rx_eof_success <= 1'b1;
 else rx_eof_success <= 1'b0;
 end

//block to indicate the succesful reception of message
always @ (posedge clk or posedge g_rst)
 begin
 if (g_rst)
 rx_success_en <= 1'b0;
 else if ((~arbtr_sts) && rx_eof_success)
 rx_success_en <= 1'b1;
 else rx_success_en <= 1'b0;
 end
//block to indicate the succesful reception of message
always @ (posedge clk or posedge g_rst)
 begin
 if (g_rst)
 rx_success <= 1'b0;
 else if (rx_success) 
 rx_success <= 1'b0;
 else if (rx_success_en && rcvd_lst_bit_ifs && (~(act_err_frm_tx
 || psv_err_frm_tx)))
 rx_success <= 1'b1;
 else rx_success <= 1'b0;
 end

// block to indicate if a ack or bit error occured
always @ (posedge clk or posedge g_rst)
 begin
 if (g_rst)
 bt_ack_err_pre <= 1'b0;
 else if (ovld_err_tx_cmp)
 bt_ack_err_pre <= 1'b0;
 else if ((dt_rm_eof_tx_cmp || txed_lst_bit_ifs) &&
 (~(act_err_frm_tx || psv_err_frm_tx)))
 bt_ack_err_pre <= 1'b0;
 else if ((arbtr_sts) && ((bt_err) || (ack_err)))
 bt_ack_err_pre <= 1'b1;
 end

//block to indicate the succesful transmission of message till eof
always @ (posedge clk or posedge g_rst)
 begin
 if (g_rst)
 tx_eof_success <= 1'b0;
 else if ((~arbtr_sts) || tx_success)
 tx_eof_success <= 1'b0;
 else if (arbtr_sts && dt_rm_eof_tx_cmp && (~bt_ack_err_pre))
 tx_eof_success <= 1'b1;
 else tx_eof_success <= 1'b0;
 end

//block to indicate the succesful transmission of message
always @ (posedge clk or posedge g_rst)
 begin
 if (g_rst)
 tx_success_en <= 1'b0;
 else if (arbtr_sts && tx_eof_success)
 tx_success_en <= 1'b1;
 else tx_success_en <= 1'b0;
 end
//block to indicate the succesful transmission of message
always @ (posedge clk or posedge g_rst)
 begin
 if (g_rst)
 tx_success <= 1'b0;
 else if (tx_success)
 tx_success <= 1'b0;
 else if (tx_success_en && txed_lst_bit_ifs && (~(act_err_frm_tx
 || psv_err_frm_tx)))
 tx_success <= 1'b1;
 else tx_success <= 1'b0;
 end

  // always block to generate send_ack signal
always @(posedge clk or posedge g_rst) begin
    if (g_rst)
        send_ack <= 1'b0;
  else if ((~txmtr) && (rcvd_bt_cnt > 14'd98) && (rcvd_bt_cnt ==
    (14'd98 + rcvd_data_len + 14'd31 + 14'd4 + 14'd3))&& (~stf_frm_crc_err_pre)
 && (~de_stuff))
        send_ack <= 1'b1;
    else
        send_ack <= 1'b0;
end

// block to indicate if a message is due for transmission
always @ (posedge clk or posedge g_rst)
 begin
 if (g_rst)
 msg_due_tx_reg <= 1'b0;
 else if (rcvd_lst_bit_ifs || ovld_err_tx_cmp || re_tran)
 msg_due_tx_reg <= 1'b0;
 else if (msg_due_tx)
 msg_due_tx_reg <= 1'b1;
 end

// block to initiate retransmission of message
always @ (posedge clk or posedge g_rst)
 begin
 if (g_rst)
 re_tran <= 1'b0;
 else if (msg_due_tx_reg && tx_buff_busy && ((rcvd_lst_bit_ifs &&
 (~(act_err_frm_tx || psv_err_frm_tx))) ||
 ovld_err_tx_cmp))
 re_tran <= 1'b1;
 else re_tran <= 1'b0;
 end

// block to indicate if the controller was/is a transmitter or receiver
always @ (posedge clk or posedge g_rst)
 begin
 if (g_rst)
 txmtr <= 1'b0;
   else if ((rcvd_bt_cnt == 14'd17) && arbtr_sts) 
 txmtr <= 1'b1;
 else if (rcvd_lst_bit_ifs || txed_lst_bit_ifs)
 txmtr <= 1'b0;
 else txmtr <= txmtr;
 end

// block to signal over load condition
always @ (posedge clk or posedge g_rst)
 begin
 if (g_rst)
 over_ld <= 1'b0;
 else if ((rx_success && rx_buff_0_wrtn && rx_buff_1_wrtn) ||
          ((~serial_in) && (rcvd_bt_cnt >= (14'd97 + rcvd_data_len + 14'd49)) && (rcvd_bt_cnt <= (14'd97 + rcvd_data_len
 + 14'd49 + 14'd2))))
 over_ld <= 1'b1;
 else over_ld <= 1'b0;
 end
endmodule

