module bit_monitor (clk, g_rst, can_bus_out, sampled_bit, dt_rm_frm_tx,
act_err_flg_tx, psv_err_flg_tx, ovld_flg_tx, cons_zero_flg,
ovld_err_ifs_tx, tx_success, arbtr_fld, ack_slt, ifs_flg_tx, arbtr_sts,
bt_err);

input clk;
input g_rst;
input can_bus_out;
input sampled_bit;
input dt_rm_frm_tx;
input act_err_flg_tx;
input psv_err_flg_tx;
input ovld_flg_tx;
input cons_zero_flg;
input ovld_err_ifs_tx;
input tx_success;
input arbtr_fld;
input arbtr_sts;
input ack_slt;
input ifs_flg_tx;
  
output bt_err;
  
reg bt_err;
reg arbtr_sts_en;
always @ (posedge clk or posedge g_rst)
 begin
 if (g_rst)
 arbtr_sts_en <= 1'b0;
 else if (arbtr_sts)
 arbtr_sts_en <= 1'b1;
 else arbtr_sts_en <= 1'b0;
 end
always @ (posedge clk or posedge g_rst)
 begin
 if (g_rst)
 bt_err <= 1'b0;
 else if((can_bus_out == sampled_bit) || (arbtr_sts_en && (arbtr_fld
 || ack_slt || ifs_flg_tx) && can_bus_out && (~sampled_bit))
 || (psv_err_flg_tx && can_bus_out && (~sampled_bit))
 ||(cons_zero_flg && can_bus_out && (~sampled_bit)) ||
 (ovld_err_ifs_tx && can_bus_out && (~sampled_bit)))
   
 // This condition checks for several cases where bt_err should be set to 0:
 // 1. If the CAN bus output matches the sampled bit, no error has occurred.
 // 2. If arbitration status is enabled (arbtr_sts_en) and:
 //    - arbitration field (arbtr_fld) is set, or
 //    - acknowledgment slot (ack_slt) is set, or
 //    - inter-frame space flag (ifs_flg_tx) is set, and
 //    - CAN bus output is 1 and sampled bit is 0,
 //    Then, it is a valid arbitration process, not an error.
 // 3. If the passive error flag for transmission (psv_err_flg_tx) is set and:
 //    - CAN bus output is 1 and sampled bit is 0,
 //    Then, it indicates the node is in a passive error state, not an error.
 // 4. If the consecutive zero flag (cons_zero_flg) is set and:
 //    - CAN bus output is 1 and sampled bit is 0,
 //    Then, it indicates a valid consecutive zero scenario, not an error.
 // 5. If the overload error and inter-frame space error flag (ovld_err_ifs_tx) is set and:
 //    - CAN bus output is 1 and sampled bit is 0,
 //    Then, it indicates an overload error or inter-frame space error, not an error.
  
 bt_err <= 1'b0;
 else if ((dt_rm_frm_tx && arbtr_sts_en && (~(arbtr_fld || ack_slt ||
 ifs_flg_tx)) && (can_bus_out != sampled_bit)) ||
 ((~can_bus_out) && (sampled_bit) && (ovld_flg_tx
||act_err_flg_tx)))
 
   // This condition checks for scenarios where bt_err should be set to 1 (indicating a bit error):
 // 1. If data removed from transmission (dt_rm_frm_tx) is true and:
 //    - Arbitration status is enabled (arbtr_sts_en), and
 //    - None of the arbitration field (arbtr_fld), acknowledgment slot (ack_slt), or inter-frame space flag (ifs_flg_tx) are set, and
 //    - The CAN bus output (can_bus_out) does not match the sampled bit (sampled_bit),
 //    Then, this indicates an error during arbitration or data transmission.
 // 2. If CAN bus output (can_bus_out) is 0 (transmitting a recessive bit) and:
 //    - The sampled bit (sampled_bit) is 1 (receiving a dominant bit), and
 //    - Either the overload flag (ovld_flg_tx) or active error flag (act_err_flg_tx) is set,
 //    Then, this indicates an error condition due to either overload or an active error.
  
 bt_err <= 1'b1;
 else bt_err <= 1'b0;
 end
endmodule 
