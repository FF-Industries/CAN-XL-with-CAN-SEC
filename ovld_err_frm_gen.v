module ovld_err_frm_gen (clk, g_rst, init_err_st, tx_bit, serial_in,
arbtr_sts, arbtr_fld, bt_err, ack_err, stf_err, frm_err, pcrc_err, fcrc_err,security_err,
over_ld, sampled_bit, rx_eof_success, tx_eof_success, rx_success,
tx_success, err_ovld_out, err_state, ovld_frm_tx, ovld_flg_tx, txmtr,
act_err_frm_tx, psv_err_frm_tx, act_err_flg_tx, psv_err_flg_tx,
cons_zero_flg, ovld_err_ifs_tx, ovld_err_tx_cmp, bus_off_sts);

input clk;
input g_rst;
input init_err_st;
input [1:0] tx_bit;
input arbtr_sts;
input arbtr_fld;
input serial_in;
input bt_err;
input ack_err;
input stf_err;
input frm_err;
input fcrc_err;
input pcrc_err;
input security_err;
input over_ld;
input sampled_bit;
input tx_success;
input rx_success;
input tx_eof_success;
input rx_eof_success;
input txmtr;

output act_err_frm_tx; 
output psv_err_frm_tx; 
output ovld_frm_tx;
output act_err_flg_tx; 
output psv_err_flg_tx; 
output ovld_flg_tx; 
output cons_zero_flg;
output ovld_err_ifs_tx;
output ovld_err_tx_cmp;
output err_ovld_out;
output [1:0] err_state;
output bus_off_sts;
reg act_err_frm_tx;
reg psv_err_frm_tx;
reg ovld_frm_tx;
reg act_err_flg_tx;
reg psv_err_flg_tx;
reg ovld_flg_tx;
reg cons_zero_flg;
reg ovld_err_ifs_tx;
reg ovld_err_tx_cmp;
reg err_ovld_out;
reg [1:0] err_state;
reg bus_off_sts;
reg init_bit;
reg fst_bit_zero_err;
reg cons_domn_err;
reg tx_excp_1;
reg tx_excp_1_trig;
reg tx_excp_2;
reg [4:0] ovld_err_flg_cnt;
reg [4:0] dlm_cnt;
reg [9:0] cons_zero_cnt;
reg [5:0] ovld_err_ifs_cnt;
reg [10:0] tx_serr_cntr;
reg [10:0] rx_derr_cntr;
reg [10:0] tx_derr_cntr;
reg [10:0] rx_serr_cntr;
reg [5:0] cons_domn_err_cnt;
reg [2:0] state, nxt_state;
reg init_err_st_in;
reg init_err_st_en;

parameter [2:0] idle = 3'd0,
 err_flg = 3'd1,
 ovld_flg = 3'd2,
 delm_init = 3'd3,
 ovld_err_dlm = 3'd4,
 ovld_err_ifs = 3'd5,
 ovld_err_comp = 3'd6,
 bus_off = 3'd7;
 
// Block to synchronise init_err_st
always @ (posedge clk or posedge g_rst)
 begin
 if (g_rst)
 init_err_st_in <= 1'b0;
 else if (init_err_st)
 init_err_st_in <= 1'b1;
 else init_err_st_in <= 1'b0;
 end

always @ (posedge clk or posedge g_rst)
 begin
 if (g_rst)
 init_err_st_en <= 1'b0;
 else if (init_err_st_in) 
 init_err_st_en <= 1'b1;
 else init_err_st_en <= 1'b0;
 end
// block to increment ovld_err_flg_cnt
always @ (posedge clk or posedge g_rst)
begin
if (g_rst)
 ovld_err_flg_cnt <= 5'd0;
else if ((nxt_state == err_flg) || (nxt_state == ovld_flg))
 ovld_err_flg_cnt <= ovld_err_flg_cnt + 5'd1;
else
 ovld_err_flg_cnt <= 5'd0;
end
// block to increment cons_zero_cnt
always @ (posedge clk or posedge g_rst)
begin
if (g_rst)
 cons_zero_cnt <= 11'd0;
else if (nxt_state == delm_init)
 cons_zero_cnt <= cons_zero_cnt + 11'd1;
else
 cons_zero_cnt <= 11'd0;
end
// block to increment dlm_cnt
always @ (posedge clk or posedge g_rst)
begin
if (g_rst)
 dlm_cnt <= 5'd0;
else if (nxt_state == ovld_err_dlm)
 dlm_cnt <= dlm_cnt + 5'd1;
else
 dlm_cnt <= 5'd0;
end
// block to increment ovld_err_ifs_cnt
always @ (posedge clk or posedge g_rst)
begin
if (g_rst)
 ovld_err_ifs_cnt <= 6'd0;
else if (nxt_state ==ovld_err_ifs)
 ovld_err_ifs_cnt <= ovld_err_ifs_cnt + 6'd1;
else
 ovld_err_ifs_cnt <= 6'd0;
end
// block to check for the 1st '1' bit after txn. of error flag
always @ (posedge clk or posedge g_rst)
 begin
 if(g_rst)
 init_bit <= 1'b0;
 else if (nxt_state == delm_init)
 begin
 if(sampled_bit)
 init_bit <= 1'b1;
 else init_bit <= 1'b0;
 end
 else init_bit <= 1'b0;
 end
// sequential always block
always @ (posedge clk or posedge g_rst)
 begin
 if (g_rst)
 state <= idle;
 else state <= nxt_state;
 end
// block to determine nxt state
always @ (state or init_err_st_en or err_state or bt_err or ack_err or security_err or 
stf_err or frm_err or pcrc_err or fcrc_err or init_bit or ovld_err_flg_cnt or
cons_zero_cnt or dlm_cnt or ovld_err_ifs_cnt or tx_success or over_ld)
begin
case (state)
 idle:begin
 if (bt_err || ack_err || stf_err || frm_err || fcrc_err || pcrc_err || security_err )
 begin
 nxt_state = err_flg;
 end
 else if (over_ld)
 begin
 nxt_state = ovld_flg;
 end
 else begin
 nxt_state = idle;
 end
 end
 err_flg:begin
 if ((err_state == 2'b00) || (err_state == 2'b01))
 begin
 if (ovld_err_flg_cnt < 5'd6)
 begin
 nxt_state = err_flg;
 end
 else begin
 nxt_state = delm_init;
 end
 end
 else if (err_state == 2'b10)
 begin
 nxt_state = bus_off;
 end
 else nxt_state = idle;
 end
 ovld_flg:begin
 if (ovld_err_flg_cnt < 5'd6)
 begin
 nxt_state = ovld_flg;
 end
 else begin
 nxt_state = delm_init;
 end
 end
 delm_init:begin
 if ((cons_zero_cnt <= 11'd1))
 begin
 nxt_state = delm_init;
 end
 else begin
 if (init_bit)
 begin
 nxt_state = ovld_err_dlm;
 end
 else begin
 nxt_state = delm_init;
 end
 end
 end
 ovld_err_dlm:begin
 if (dlm_cnt < 5'd6)
 begin
 nxt_state = ovld_err_dlm;
 end
 else begin
 nxt_state = ovld_err_ifs;
 end
 end
 ovld_err_ifs:begin
 if(err_state == 2'b00)
 begin
 if(ovld_err_ifs_cnt < 6'd3)
 begin
 nxt_state = ovld_err_ifs;
 end
 else begin
 nxt_state = ovld_err_comp;
 end
 end
 else if (err_state == 2'b01)
 begin
 if(ovld_err_ifs_cnt < 6'd11)
 begin
 nxt_state = ovld_err_ifs;
 end
 else begin
 nxt_state = ovld_err_comp;
 end
 end
 else if (err_state == 2'b10)
 begin
 nxt_state = bus_off;
 end
 else begin
 nxt_state = idle;
 end
 end
 ovld_err_comp:begin
 nxt_state = idle;
 end
 bus_off:begin
 if(init_err_st_en)
 begin
 nxt_state = idle;
 end
 else begin
 nxt_state = bus_off;
 end
 end
 default: begin
 nxt_state = idle;
 end
 endcase
 end
// always block to determine output
always @ (posedge clk or posedge g_rst)
 begin
 if (g_rst)
 begin
 ovld_frm_tx <= 1'b0;
 act_err_frm_tx <= 1'b0;
 psv_err_frm_tx <= 1'b0;
 act_err_flg_tx <= 1'b0;
 psv_err_flg_tx <= 1'b0;
 ovld_flg_tx <= 1'b0;
 err_ovld_out <= 1'b1;
 cons_zero_flg <= 1'b0;
 ovld_err_ifs_tx <= 1'b0;
 ovld_err_tx_cmp <= 1'b0;
 fst_bit_zero_err <= 1'b0;
 end
 else begin
 case (state)
 idle:begin
 if (bt_err || ack_err || stf_err || frm_err || pcrc_err || fcrc_err || security_err ||
 over_ld)
 begin
 err_ovld_out <= 1'b1;
 end
 else
 begin
 ovld_frm_tx <= 1'b0;
 act_err_frm_tx <= 1'b0;
 psv_err_frm_tx <=1'b0; 
 act_err_flg_tx <=1'b0;
 psv_err_flg_tx <=1'b0;
 ovld_flg_tx <= 1'b0;
 err_ovld_out <= 1'b1;
 cons_zero_flg <= 1'b0;
 ovld_err_ifs_tx <= 1'b0;
 ovld_err_tx_cmp <=1'b0;
 fst_bit_zero_err <=1'b0;
 end
 end
 err_flg:begin
 if (err_state == 2'b00)
 begin
 err_ovld_out <=1'b0;
 act_err_frm_tx <= 1'b1;
 act_err_flg_tx <=1'b1;
 end
 else if (err_state == 2'b01)
 begin
 err_ovld_out <=1'b0;
 psv_err_frm_tx <=1'b1;
 psv_err_flg_tx <=1'b1;
 end
 else if (err_state == 2'b10)
 begin
 err_ovld_out <=1'b1;
 act_err_frm_tx <= 1'b0;
 psv_err_frm_tx <=1'b0;
 act_err_flg_tx <=1'b0;
 psv_err_flg_tx <=1'b0;
 end
 end
 ovld_flg:begin
 err_ovld_out <= 1'b0;
 ovld_frm_tx <= 1'b1;
 ovld_flg_tx <= 1'b1;
 end
 delm_init:begin
 if ((cons_zero_cnt <= 11'd2))
 begin
 fst_bit_zero_err <=1'b0;
 err_ovld_out <=1'b1;
 cons_zero_flg <=1'b0;
 act_err_flg_tx <=1'b0;
 psv_err_flg_tx <=1'b0;
 ovld_flg_tx <=1'b0;
 end
 else if (cons_zero_cnt == 11'd3)
 begin
 if (init_bit)
 begin
 fst_bit_zero_err <=1'b0;
 err_ovld_out <=1'b1;
 cons_zero_flg <=1'b0;
 act_err_flg_tx <=1'b0;
 psv_err_flg_tx <=1'b0;
 ovld_flg_tx <=1'b0;
 end
 else begin
 fst_bit_zero_err <= 1'b1;
 err_ovld_out <= 1'b1;
 cons_zero_flg <= 1'b1;
 act_err_flg_tx <= 1'b0;
 psv_err_flg_tx <= 1'b0;
 ovld_flg_tx <= 1'b0;
 end
 end
 else begin
 if (init_bit)
 begin
 fst_bit_zero_err <=1'b0;
 cons_zero_flg <=1'b0;
 err_ovld_out <=1'b1;
 act_err_flg_tx <=1'b0;
 psv_err_flg_tx <=1'b0;
 ovld_flg_tx <=1'b0;
 end
 else begin
 fst_bit_zero_err <=1'b0;
 cons_zero_flg <=1'b1;
 err_ovld_out <=1'b1;
 act_err_flg_tx <=1'b0;
 psv_err_flg_tx <=1'b0;
 ovld_flg_tx <=1'b0;
 end
 end
 end
 ovld_err_dlm:begin
 err_ovld_out <= 1'b1;
 fst_bit_zero_err <=1'b0;
 cons_zero_flg <=1'b0;
 end
 ovld_err_ifs:begin
 if(err_state == 2'b01)
 begin
 if(ovld_err_ifs_cnt < 6'd11)
 begin
 err_ovld_out <= 1'b1;
 ovld_err_ifs_tx <=1'b1;
 end
 else begin
 err_ovld_out <= 1'b1;
 end
 end
 else
 begin
 if(ovld_err_ifs_cnt < 6'd3)
 begin 
 err_ovld_out <= 1'b1;
 ovld_err_ifs_tx <=1'b1;
 end
 else begin
 err_ovld_out <= 1'b1;
 end
 end
 end
 ovld_err_comp:begin
 err_ovld_out <= 1'b1;
 psv_err_frm_tx <= 1'b0;
 act_err_frm_tx <= 1'b0;
 ovld_frm_tx <= 1'b0;
 ovld_err_ifs_tx <= 1'b0;
 ovld_err_tx_cmp <=1'b1;
 end
 bus_off:begin
 ovld_frm_tx <= 1'b0;
 act_err_frm_tx <= 1'b0;
 psv_err_frm_tx <= 1'b0;
 act_err_flg_tx <= 1'b0;
 psv_err_flg_tx <= 1'b0;
 ovld_flg_tx <= 1'b0;
 err_ovld_out <= 1'b1;
 cons_zero_flg <= 1'b0;
 ovld_err_ifs_tx <= 1'b0;
 ovld_err_tx_cmp <= 1'b0;
 fst_bit_zero_err <= 1'b0;
 end
 default: begin
 ovld_frm_tx <= 1'b0;
 act_err_frm_tx <= 1'b0;
 psv_err_frm_tx <= 1'b0;
 act_err_flg_tx <= 1'b0;
 psv_err_flg_tx <= 1'b0;
 ovld_flg_tx <= 1'b0;
 err_ovld_out <= 1'b1;
 cons_zero_flg <= 1'b0;
 ovld_err_ifs_tx <= 1'b0;
 ovld_err_tx_cmp <= 1'b0;
 fst_bit_zero_err <= 1'b0;
 end
 endcase
 end
end
// block to count the occurance of consecutive zero's after error/overload flag
always @ (posedge clk or posedge g_rst)
 begin
 if (g_rst)
 begin
 cons_domn_err <= 1'b0; 
 cons_domn_err_cnt <= 6'd0;
 end
 else if (ovld_err_tx_cmp || rx_success)
 begin
 cons_domn_err <= 1'b0;
 cons_domn_err_cnt <= 6'd0;
 end
 else if (cons_zero_flg)
 begin
 if (cons_zero_cnt == 11'd4)
 begin
 cons_domn_err <= 1'b0;
 cons_domn_err_cnt <= 6'd2;
 end
 else if (cons_domn_err_cnt == 6'd7)
 begin
 cons_domn_err <= 1'b1;
 cons_domn_err_cnt <= 6'd0;
 end
 else begin
 cons_domn_err <= 1'b0;
 cons_domn_err_cnt <= cons_domn_err_cnt + 6'd1;
 end
 end
 end

//tx. error limitation exception 1
always @ (posedge clk or posedge g_rst)
 begin
 if (g_rst)
 begin
 tx_excp_1 <= 1'b0;
 tx_excp_1_trig <= 1'b0;
 end
 else if (ovld_err_tx_cmp || rx_success)
 begin
 tx_excp_1 <= 1'b0;
 tx_excp_1_trig <= 1'b0;
 end
 else if ((err_state == 2'b01) && ack_err)
 tx_excp_1_trig <= 1'b1;
 else if(tx_excp_1_trig && psv_err_flg_tx)
 begin
 if(~sampled_bit)
 tx_excp_1 <= tx_excp_1;
 else tx_excp_1 <= 1'b1;
 end
 else tx_excp_1 <= 1'b0;
 end
//tx. error limitation exception 2
always @ (posedge clk or posedge g_rst) 
begin
 if (g_rst)
 begin
 tx_excp_2 <= 1'b0;
 end
 else if (ovld_err_tx_cmp || rx_success)
 begin
 tx_excp_2 <= 1'b0;
 end
 else if (arbtr_fld & stf_err & tx_bit[1] & serial_in)
 tx_excp_2 <= 1'b1;
 end
//Block to increment the tx & rx error counters
always @ (posedge clk or posedge g_rst)
 begin
 if (g_rst)
 begin
 tx_serr_cntr <= 11'd0;
 rx_serr_cntr <= 11'd0;
tx_derr_cntr <= 11'd0;
 rx_derr_cntr <= 11'd0;
 end
 else if (init_err_st_en)
 begin
 tx_serr_cntr <= 11'd0;
 rx_serr_cntr <= 11'd0;
tx_derr_cntr <= 11'd0;
 rx_derr_cntr <= 11'd0;
 end
 else if (~txmtr)
 begin
 if (( stf_err || frm_err || pcrc_err || fcrc_err || security_err ) && (~((act_err_flg_tx
 || ovld_flg_tx) && bt_err))) 
begin
rx_serr_cntr <= rx_serr_cntr + 9'd1;
rx_derr_cntr <= rx_derr_cntr + 9'd1;
end
else if ((fst_bit_zero_err && (act_err_frm_tx ||
psv_err_frm_tx )) || ((act_err_flg_tx ||
ovld_flg_tx) && bt_err) || cons_domn_err)
begin
rx_serr_cntr <= rx_serr_cntr + 9'd8;
rx_derr_cntr <= rx_derr_cntr + 9'd8;
end
 else if (rx_eof_success)
 begin
 if (tx_serr_cntr == 9'd0 && tx_serr_cntr == 9'd0)
begin
 rx_serr_cntr <= 9'd0;
 rx_derr_cntr <= 9'd0;
end
 else if ((rx_serr_cntr >= 9'd1) || (rx_serr_cntr <
 9'd128))
 rx_serr_cntr <= rx_serr_cntr - 9'd1;
 else
 rx_serr_cntr <= 9'd120;
 end
 else rx_serr_cntr <= rx_serr_cntr;
 end
 else begin
 if ((((~tx_excp_1) && (~tx_excp_2)) && ( stf_err ||
 frm_err || pcrc_err || fcrc_err || bt_err || security_err || ack_err))||
 (fst_bit_zero_err && (act_err_frm_tx ||
 psv_err_frm_tx)) || (cons_domn_err)||
((act_err_flg_tx || ovld_flg_tx) && bt_err))
tx_derr_cntr <= tx_derr_cntr + 11'd8;
 else if (tx_eof_success)
 begin
 if (tx_derr_cntr == 11'd0)
 tx_derr_cntr <= 11'd0;
 else tx_derr_cntr <= tx_derr_cntr - 11'd1;
 end
 else tx_derr_cntr <= tx_derr_cntr;
 end
 end
// Block to assign error state of node based on the counter values
always @ (posedge clk or posedge g_rst)
 begin
 if (g_rst)
 begin
 err_state <= 2'b00;
 bus_off_sts <= 1'b0;
 end
 else if (init_err_st_en)
 begin
 err_state <= 2'b00;
 bus_off_sts <= 1'b0;
 end
 else if((rx_serr_cntr <= 11'd127 ) && ( tx_serr_cntr <= 11'd127))
 begin
 err_state <= 2'b00;
 bus_off_sts <= 1'b0;
 end
 else if(((rx_serr_cntr > 11'd127) || (tx_serr_cntr > 11'd127)) &&
 (tx_serr_cntr <= 11'd255))
 begin
 err_state <= 2'b01;
 bus_off_sts <= 1'b0;
 end
 else if (tx_serr_cntr > 11'd255)
 begin
 err_state <= 2'b10;
 bus_off_sts <= 1'b1;
 end
 end
endmodule 
