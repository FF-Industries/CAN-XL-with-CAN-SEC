/*
`include "accp_checker.v"
`include "ack_checker.v"
`include "arbtr_ctrl_XL.v"
`include "bit_de_stuff_XL.v"
`include "bit_monitor_XL.v"
`include "bit_stuff_monitor_XL.v"
`include "bit_stuff_XL.v"
`include "canxl_fcrc.v"
`include "canxl_pcrc.v"
`include "Data_Remote_frame_generation.v"
`include "fcrc_checker.v"
`include "form_checker.v"

`include "msg_processor_XL.v"
`include "ovld_err_frm_gen.v"
`include "par_ser_conv.v"
`include "pcrc_checker.v"
`include "Receiver_buffer.v"
`include "Registry.v"
`include "slzd_frm_tx_XL.v"
`include "Synchronizer.v"
`include "Transmitter_buffer.v"
*/

module CAN_XL (osc_clk, g_rst, init_err_st, can_bus_in, param_ld, data_in,
tx_buff_ld, rd_en, tx_buff_busy, can_bus_out, buff_rdy, data_out);
input osc_clk; // oscillator clock
input g_rst; // global reset

input init_err_st; // signal to reset error counters
input can_bus_in; // input form CAN bus
input param_ld; // Signal to load register files
input [255:0] data_in; // data input bus
input tx_buff_ld; // load tx_buff
input rd_en; // signal to read the RX buffers
//input speed_status; //to identify arbitration and data phase
output tx_buff_busy; // status signal to indicate that buff is
 //loaded
output can_bus_out; // output from CAN controller
output buff_rdy; // signal to indicate that the receive
 // buffer is loaded
output [255:0] data_out; // data output bus
wire speed_status;
wire frame_gen_intl; // buffer status full = 1 empty =0
wire [10:0] mask_param; // mask parameter for id acceptance
 //checking
wire [10:0] code_param; // code parameter for id acceptance
 // checking
  wire [10:0] rcvd_prio_id;
wire [1:0] sjw; // re-synchronizing jump width
		wire [255:0] tx_buff_1;  // transmit buffers 
		wire [255:0] tx_buff_2;  // transmit buffers 
		wire [255:0] tx_buff_3;  // transmit buffers 
		wire [255:0] tx_buff_4;  // transmit buffers 
		wire [255:0] tx_buff_5;  // transmit buffers 
		wire [255:0] tx_buff_6;  // transmit buffers 
		wire [255:0] tx_buff_7;  // transmit buffers 
		wire [255:0] tx_buff_8;  // transmit buffers 
		wire [255:0] tx_buff_9;  // transmit buffers 
		wire [255:0] tx_buff_10; // transmit buffers 
		wire [255:0] tx_buff_11; // transmit buffers 
		wire [255:0] tx_buff_12; // transmit buffers 
		wire [255:0] tx_buff_13; // transmit buffers 
		wire [255:0] tx_buff_14; // transmit buffers 
		wire [255:0] tx_buff_15; // transmit buffers 
		wire [255:0] tx_buff_16; // transmit buffers 
		wire [255:0] tx_buff_17; // transmit buffers 
		wire [255:0] tx_buff_18; // transmit buffers 
		wire [255:0] tx_buff_19; // transmit buffers 
		wire [255:0] tx_buff_20; // transmit buffers 
		wire [255:0] tx_buff_21; // transmit buffers 
		wire [255:0] tx_buff_22; // transmit buffers 
		wire [255:0] tx_buff_23; // transmit buffers 
		wire [255:0] tx_buff_24; // transmit buffers 
		wire [255:0] tx_buff_25; // transmit buffers 
		wire [255:0] tx_buff_26; // transmit buffers 
		wire [255:0] tx_buff_27; // transmit buffers 
		wire [255:0] tx_buff_28; // transmit buffers 
		wire [255:0] tx_buff_29; // transmit buffers 
		wire [255:0] tx_buff_30; // transmit buffers 
		wire [255:0] tx_buff_31; // transmit buffers 
		wire [255:0] tx_buff_32; // transmit buffers 
		wire [255:0] tx_buff_33; // transmit buffers 
		wire [255:0] tx_buff_34; // transmit buffers 
		wire [255:0] tx_buff_35; // transmit buffers 
		wire [255:0] tx_buff_36; // transmit buffers 
		wire [255:0] tx_buff_37; // transmit buffers 
		wire [255:0] tx_buff_38; // transmit buffers 
		wire [255:0] tx_buff_39; // transmit buffers 
		wire [255:0] tx_buff_40; // transmit buffers 
		wire [255:0] tx_buff_41; // transmit buffers 
		wire [255:0] tx_buff_42; // transmit buffers 
		wire [255:0] tx_buff_43; // transmit buffers 
		wire [255:0] tx_buff_44; // transmit buffers 
		wire [255:0] tx_buff_45; // transmit buffers 
		wire [255:0] tx_buff_46; // transmit buffers 
		wire [255:0] tx_buff_47; // transmit buffers 
		wire [255:0] tx_buff_48; // transmit buffers 
		wire [255:0] tx_buff_49; // transmit buffers 
		wire [255:0] tx_buff_50; // transmit buffers 
		wire [255:0] tx_buff_51; // transmit buffers 
		wire [255:0] tx_buff_52; // transmit buffers 
		wire [255:0] tx_buff_53; // transmit buffers 
		wire [255:0] tx_buff_54; // transmit buffers 
		wire [255:0] tx_buff_55; // transmit buffers 
		wire [255:0] tx_buff_56; // transmit buffers 
		wire [255:0] tx_buff_57; // transmit buffers 
		wire [255:0] tx_buff_58; // transmit buffers 
		wire [255:0] tx_buff_59; // transmit buffers 
		wire [255:0] tx_buff_60; // transmit buffers 
		wire [255:0] tx_buff_61; // transmit buffers 
		wire [255:0] tx_buff_62; // transmit buffers 
		wire [255:0] tx_buff_63; // transmit buffers 
		wire [255:0] tx_buff_64; // transmit buffers 
		wire [255:0] tx_buff_65; // transmit buffers
wire [10:0] dlc; // data length code register
wire tx_pcrc_frm_cmp; 
wire tx_fcrc_frm_cmp; 
  wire [2:0] ifs;
wire [12:0] tx_pcrc_frm; 
wire [31:0] tx_fcrc_frm; // transmitter data crc_frame
wire [43:0] par_ser_data;
wire [16480:0] par_ser_data1; // par data input to par to series
 // converter module
wire par_ser_intl1;
wire par_ser_intl; // initialize par to series conversion
wire [16532:0] dt_rm_frm;
wire [16532:0] dt_rm_frm1; // output frame to bit stuffing module
wire bit_stf_intl; // output to initialise bit stuffing
wire bit_stf_intl_1;
wire [14:0] dt_rm_frm_len; 
wire [14:0] dt_rm_frm_len1;// data frame length
wire tx_serial_out; // serial data output to crc module
wire tx_pcrc_intl; // initialization signal to tx crc module
wire tx_fcrc_intl;  
wire tx_pcrc_enable;
wire tx_fcrc_enable;  
wire [1:0] err_state; // indicates error state of controller
 // (Active / Passive /Bus off)
wire arbtr_sts; // signal to indicate if the node is a
 // transmitter or receiver
wire abort_dt_rm_tx; // Signal to abort data transmission
wire re_tran; // signal to resume data transmission
wire dt_rm_out; // serial output from the data/remote
 // frame generator module
wire dt_rm_frm_tx; // indicates the transmission of
 // data/remote frame
wire arbtr_fld; // indicates the transmission of arbtr fld 
wire dt_rm_eof_tx_cmp; // indicates the end of transmission of
 // data/remote frame
wire ack_slt; // indicates the transmission of
 // acknowledgement slot
wire txed_lst_bit_ifs; // indicates the transmission of last bit
 // of the inter frame space
wire ifs_flg_tx; // indicates transmission of ifs_flg
wire [1:0] tx_bit; // register to hold previously transmitted
 // bits
  wire [12:0] rcvd_pcrc;
wire bt_err; // indicates the occurrence of a bit error
wire ack_err; // indicates the occurrence of an
 // acknowledgement error
wire stf_err; // indicates the occurrence of a stuff err
wire frm_err; // indicates the occurrence of a frame err
wire pcrc_err; // indicates the occurrence of a crc err
wire fcrc_err;
wire over_ld; // indicates the occurrence of an over ld
 // condition
wire sampling_pt; // the sampling point of the can bus data
wire sampled_bit; // register to store the sampled bit
wire tx_success; // indicates the successful transmission
 // of message
wire rx_success; // indicates the successful reception of
 // message
wire tx_eof_success; // indicates the successful transmission
 // of msg till the end of frame
wire rx_eof_success; // indicates the successful reception of
 // msg till the end of frame
wire err_ovld_out; // serial output from the error/overload
 // frame generator module
wire act_err_frm_tx; // indicates active error frm transmission
 // stays high till end of frm
wire psv_err_frm_tx; // indicates passive err frm transmission
wire ovld_frm_tx; // indicates overload frm transmission 
wire act_err_flg_tx; // indicates active err flag transmission
wire psv_err_flg_tx; // indicates passive err flag transmission
wire ovld_flg_tx; // indicates overload flag transmission
wire cons_zero_flg; // indicates the reception of 0's after
 // the transmission of an error flag
wire ovld_err_ifs_tx; // indicates error/overload inter frame
 // space transmission
wire ovld_err_tx_cmp; // indicates successful transmission of an
 // error frame
wire bus_off_sts; // indicates that the controller is in
 // bus off state
wire send_ack; // indicates the need to send out an
 //acknowledgement
wire rcvd_lst_bit_eof; // indicates the reception of the last bit
 // of the end of frame flag
wire rcvd_eof_flg; // indicates the reception of end of frame
wire [13:0] rcvd_data_len; // register to store received data length
wire [14:0] rcvd_bt_cnt; // counter to count the total number of
 // bits received
wire bt_ack_err_pre; // indicates the presence of a bit or
 // acknowledgement error
wire stf_frm_crc_err_pre; // indicates the presence of a stuff, CRC
 // or form error
wire txmtr; // indicates if the controller is/was a
 // transmitter/receiver 1 -indicates a tx
 // and 0 a receiver
wire msg_due_tx; // indicates that a message is due for
 // transmission
wire serial_in; // register to hold the synchronized
wire serial_in1; // sampled bit
wire rx_buff_0_wrtn; // indicates buffer 0 has been written
wire rx_buff_1_wrtn; // indicates buffer 1 has been written
wire rcvd_lst_bit_ifs; // indicates the reception of the last bit
 // of the inter frame space
 wire clk; // generated system clock
wire bit_destf_intl; // indicates the initialization of the bit
 // stuff module
wire [12:0] rx_pcrc_frm; 
wire [31:0] rx_fcrc_frm; 
 // register to hold the generated crc
 // frame for the received message
wire rcvd_rrs; // register to hold the received remote
 // transfer bit
wire [10:0] rcvd_dlc; // register to hold the received data
 // length code
wire tx_serial_in;
wire [16383:0] rcvd_data_frm; // register to hold the received data
wire rx_pcrc_intl; // indicates the initialization of the
wire rx_fcrc_intl;
wire pcrc_enable; // enable signal for the receiver crc
 // generator
wire fcrc_enable;
wire de_stuff; // indicates that de-stuff is taking place
wire rcvd_pcrc_flg; // indicates the reception of the crc
 // frame
  
wire adh; 
  
wire rcvd_fcrc_flg;
wire [2:0] one_count; // counter to count the consecutive one's
 // in the received message
wire [2:0] one_count1;
wire [2:0] zero_count; // counter to count the consecutive zero's
 // in the received message
wire [2:0] zero_count1; 
wire acpt_sts; // indicates the received message is
 // accepted
wire [7:0] sdt;
wire sec;
wire [2:0] sbc;
wire [12:0] pcrc;
wire [31:0] fcrc;
wire dah;
wire ack_slot;
wire sof;
wire ide;
wire fdf;
wire xlf;
wire resXL;

wire dh1;
wire dh2;
wire dl1;

wire [7:0] vcid;
wire [31:0] af;
wire [3:0] fcp;

wire ah1;
wire al1;
wire ah2;

wire acl_del;
wire [4:0] bit_count;
wire [6:0] eof;
wire enable;
wire enable1;
wire done;
wire done1;
wire done2;
wire done_combined;
wire [127:0] dataout;
wire [127:0] dataout1;
wire [127:0] dataout2;
wire [127:0] rcvd_data;
wire [127:0] datain;
wire [127:0] datain1;
wire [127:0] dataout_combined;
wire tx_sec;
wire [127:0] rcvd_dataout_combined;
wire rcvd_done_combined;
wire enable2;
wire security_err;
wire [31:0] fv;



registry reg_file (clk, g_rst, data_in, param_ld, mask_param,code_param, sjw);

tx_buff tx_buffer (clk, g_rst, data_in, tx_buff_ld, tx_success, frame_gen_intl, tx_buff_busy, 
tx_buff_1, tx_buff_2, tx_buff_3, tx_buff_4, tx_buff_5, tx_buff_6, tx_buff_7, 
tx_buff_8, tx_buff_9, tx_buff_10, tx_buff_11, tx_buff_12, tx_buff_13, tx_buff_14, 
tx_buff_15, tx_buff_16, tx_buff_17, tx_buff_18, tx_buff_19, tx_buff_20, tx_buff_21, 
tx_buff_22, tx_buff_23, tx_buff_24, tx_buff_25, tx_buff_26, tx_buff_27, tx_buff_28, 
tx_buff_29, tx_buff_30, tx_buff_31, tx_buff_32, tx_buff_33, tx_buff_34, tx_buff_35, 
tx_buff_36, tx_buff_37, tx_buff_38, tx_buff_39, tx_buff_40, tx_buff_41, tx_buff_42, 
tx_buff_43, tx_buff_44, tx_buff_45, tx_buff_46, tx_buff_47, tx_buff_48, tx_buff_49, 
tx_buff_50, tx_buff_51, tx_buff_52, tx_buff_53, tx_buff_54, tx_buff_55, tx_buff_56, 
tx_buff_57, tx_buff_58, tx_buff_59, tx_buff_60, tx_buff_61, tx_buff_62, tx_buff_63, 
tx_buff_64, tx_buff_65, dlc, tx_sec
);

dt_rm_frame_gen data_remote_frm (clk, g_rst, frame_gen_intl, tx_success, 
tx_buff_1, tx_buff_2, tx_buff_3, tx_buff_4, tx_buff_5, tx_buff_6, 
tx_buff_7, tx_buff_8, tx_buff_9, tx_buff_10, tx_buff_11, tx_buff_12, tx_buff_13, tx_buff_14, tx_buff_15, tx_buff_16, tx_buff_17, tx_buff_18, tx_buff_19, tx_buff_20, tx_buff_21, tx_buff_22, tx_buff_23, tx_buff_24, tx_buff_25, tx_buff_26, tx_buff_27, tx_buff_28, tx_buff_29, tx_buff_30, tx_buff_31, tx_buff_32, tx_buff_33, tx_buff_34, tx_buff_35, tx_buff_36, tx_buff_37, tx_buff_38, tx_buff_39, tx_buff_40, tx_buff_41, tx_buff_42, tx_buff_43, tx_buff_44, tx_buff_45, tx_buff_46, tx_buff_47, tx_buff_48, tx_buff_49, tx_buff_50, tx_buff_51, tx_buff_52, tx_buff_53, tx_buff_54, tx_buff_55, tx_buff_56, tx_buff_57, tx_buff_58, tx_buff_59, tx_buff_60, tx_buff_61, tx_buff_62, tx_buff_63, tx_buff_64, tx_buff_65,
dlc, tx_fcrc_frm_cmp, tx_pcrc_frm_cmp, tx_pcrc_frm, tx_fcrc_frm, par_ser_data,par_ser_data1, par_ser_intl,par_ser_intl1, dt_rm_frm, bit_stf_intl, 
dt_rm_frm_len,datain,enable,datain1,tx_sec);  

par_ser_conv parser (clk, g_rst, par_ser_intl, tx_success, 
par_ser_data,tx_serial_out, tx_pcrc_intl, tx_pcrc_enable, 
tx_pcrc_frm_cmp); 

par_ser_conv1 parser1 (clk, g_rst,dlc, par_ser_intl1, tx_success, 
par_ser_data1,tx_serial_out1, tx_fcrc_intl, tx_fcrc_enable, 
tx_fcrc_frm_cmp); 
  
canxl_pcrc tx_pcrc (clk, g_rst, tx_serial_out, tx_pcrc_enable, tx_pcrc_intl,
tx_success, rx_success, tx_pcrc_frm);

  canxl_fcrc tx_fcrc (clk, g_rst, tx_serial_out1, tx_fcrc_enable, tx_fcrc_intl,
tx_success, rx_success, tx_fcrc_frm);

bit_stuff bt_stf (clk, g_rst, dt_rm_frm1, bit_stf_intl_1, dt_rm_frm_len1,
tx_success, err_state, arbtr_sts, abort_dt_rm_tx, re_tran, dt_rm_out,
dt_rm_frm_tx, arbtr_fld, dt_rm_eof_tx_cmp, txed_lst_bit_ifs, ack_slt,
ifs_flg_tx);

ovld_err_frm_gen ovld_err (clk, g_rst, init_err_st, tx_bit, serial_in,
arbtr_sts, arbtr_fld, bt_err, ack_err, stf_err, frm_err, pcrc_err, fcrc_err,security_err,
over_ld, sampled_bit, rx_eof_success, tx_eof_success, rx_success,
tx_success, err_ovld_out, err_state, ovld_frm_tx, ovld_flg_tx, txmtr,
act_err_frm_tx, psv_err_frm_tx, act_err_flg_tx, psv_err_flg_tx,
cons_zero_flg, ovld_err_ifs_tx, ovld_err_tx_cmp, bus_off_sts);

slzd_frm_tx slzr (clk, g_rst, dt_rm_frm_tx, act_err_frm_tx,
psv_err_frm_tx, ovld_frm_tx, dt_rm_out, err_ovld_out, send_ack,
bus_off_sts, arbtr_sts, can_bus_out, abort_dt_rm_tx, tx_bit);

msg_processor msg_prsr (clk, g_rst, stf_err, bt_err, fcrc_err, pcrc_err, ack_err,
frm_err, rcvd_eof_flg, rcvd_lst_bit_ifs, dt_rm_eof_tx_cmp,
txed_lst_bit_ifs, ovld_err_tx_cmp, rcvd_data_len, rcvd_bt_cnt,
de_stuff, act_err_frm_tx, psv_err_frm_tx, tx_buff_busy, arbtr_sts,
msg_due_tx, serial_in, rx_buff_0_wrtn, rx_buff_1_wrtn, bt_ack_err_pre,
stf_frm_crc_err_pre, rx_eof_success, rx_success, tx_eof_success,
tx_success,re_tran, send_ack, txmtr, over_ld);

arbtr_ctrl arbtr_sts_ctrl (osc_clk, g_rst, arbtr_fld, rcvd_lst_bit_ifs,
txed_lst_bit_ifs, ovld_err_tx_cmp, tx_buff_busy, bt_ack_err_pre,
bit_destf_intl, dt_rm_frm_tx, sampling_pt, can_bus_out, can_bus_in,
act_err_frm_tx, psv_err_frm_tx, adh, dah, arbtr_sts, msg_due_tx, speed_status);

synchronizer synchro (
    osc_clk, g_rst, can_bus_in, rcvd_lst_bit_ifs, 
    sjw, ovld_err_tx_cmp, txed_lst_bit_ifs, 
    arbtr_sts, clk, bit_destf_intl, sampling_pt, sampled_bit, 
    speed_status
); 

bit_destuff destuff (clk, g_rst, arbtr_sts, bit_destf_intl, sampled_bit, tx_success, 
rx_success, act_err_frm_tx, psv_err_frm_tx, ovld_frm_tx, serial_in,serial_in1,
rcvd_bt_cnt, de_stuff , one_count, zero_count,one_count1, zero_count1, rcvd_data_len,
rcvd_eof_flg, rcvd_lst_bit_ifs, rcvd_pcrc_flg, rcvd_fcrc_flg, rcvd_lst_bit_eof, sof,
rcvd_prio_id, rcvd_rrs, ide, fdf, xlf, resXL, adh, dh1, dh2, dl1, sdt, sec, rcvd_dlc,
sbc, pcrc, vcid, af, rcvd_data_frm, fcrc, fcp, dah, ah1, al1, ah2, ack_slot, acl_del,
pcrc_enable, fcrc_enable, rx_pcrc_intl ,rx_fcrc_intl , bit_count,enable1,enable2,rcvd_data
);

rx_pcrc rx_pcrc1 (clk, g_rst, serial_in1, pcrc_enable, rx_pcrc_intl,
tx_success, rx_success, rx_pcrc_frm,de_stuff);

rx_fcrc rx_fcrc1 (clk, g_rst, serial_in1, fcrc_enable, rx_fcrc_intl,
tx_success, rx_success, rx_fcrc_frm,de_stuff);

bit_stuff_monitor stf_error (clk, g_rst, serial_in, arbtr_fld, one_count,
zero_count,one_count1, zero_count1, bit_count, stf_err, rcvd_bt_cnt);

fcrc_checker fcrc_err_chk (clk, g_rst, rx_success, act_err_frm_tx,
psv_err_frm_tx, rx_fcrc_frm, rcvd_fcrc_flg, fcrc, fcrc_err,sec);

pcrc_checker pcrc_err_chk (clk, g_rst, rx_success, act_err_frm_tx,
psv_err_frm_tx, rx_pcrc_frm, rcvd_pcrc_flg,pcrc, pcrc_err); 

form_checker frm_error (clk, g_rst, rx_success, act_err_frm_tx,
psv_err_frm_tx, rcvd_bt_cnt, rcvd_data_len, serial_in, frm_err);

bit_monitor bit_err_chk (clk, g_rst, can_bus_out, sampled_bit,
dt_rm_frm_tx, act_err_flg_tx, psv_err_flg_tx, ovld_flg_tx,
cons_zero_flg, ovld_err_ifs_tx, tx_success, arbtr_fld, ack_slt,
ifs_flg_tx, arbtr_sts, bt_err);

ack_checker ack_err_chk (clk, g_rst, ack_slt, sampled_bit, arbtr_sts,
act_err_frm_tx, psv_err_frm_tx, tx_success, ack_err);

accp_checker id_check (clk, g_rst, arbtr_sts, mask_param, code_param, 
rcvd_lst_bit_eof, stf_frm_crc_err_pre,bt_ack_err_pre, rcvd_prio_id, 
acpt_sts); 

rx_buff rx_buffer (clk, g_rst, acpt_sts, rd_en, rcvd_prio_id,
rcvd_dlc, rcvd_data_frm,rcvd_rrs, ide, fdf, xlf, resXL, sdt, vcid,sec, buff_rdy, rx_buff_0_wrtn, rx_buff_1_wrtn, 
data_out);

AES_control aes( clk, g_rst, enable, datain, dataout, done);

AES_control1 aes1( clk, g_rst, enable, datain1, dataout1, done1);

AES_control_combined icv(clk, g_rst,enable,dataout,dataout1,done,done1,tx_success,dataout_combined,done_combined);

d_aes data_aes (clk,g_rst,tx_success,dlc,tx_sec,dt_rm_frm,dt_rm_frm_len, dataout,dataout_combined,done,done_combined,bit_stf_intl,dt_rm_frm1, dt_rm_frm_len1,bit_stf_intl_1);

AES_control2 aes2(clk, g_rst, enable1, tx_success, rx_success, rcvd_data_frm, dataout2, done2);

AES_control_combined1 rcvd_icv(clk, g_rst,enable2,rcvd_data,dataout2,done2,rx_success,rcvd_dataout_combined,rcvd_done_combined);

Security secu (clk,g_rst,rx_success,rcvd_done_combined,sec,rcvd_data_frm,rcvd_dataout_combined,enable1,security_err,fv);

endmodule 
 
