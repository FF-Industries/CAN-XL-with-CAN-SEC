module slzd_frm_tx (clk, g_rst, dt_rm_frm_tx, act_err_frm_tx,
psv_err_frm_tx, ovld_frm_tx, dt_rm_out, err_ovld_out, send_ack,
bus_off_sts, arbtr_sts, can_bus_out, abort_dt_rm_tx, tx_bit);

input clk;
input g_rst;
input dt_rm_frm_tx;
input act_err_frm_tx;
input psv_err_frm_tx;
input ovld_frm_tx;
input dt_rm_out;
input err_ovld_out;
input send_ack;
input bus_off_sts;
input arbtr_sts;

output can_bus_out;
output [1:0] tx_bit;
output abort_dt_rm_tx;

reg can_bus_out;
reg [1:0] tx_bit;
reg abort_dt_rm_tx;
reg [1:0] state, nxt_state;
parameter [1:0] idle = 2'd0,
 dt_rm_tx = 2'd1,
 err_ovld_tx = 2'd2;
 
// sequential always block
always @ (posedge clk or posedge g_rst)
begin
if (g_rst)
 state <= idle;
else state <= nxt_state;
end
// combinational block to determine nxt state and output logic
always @ (state or act_err_frm_tx or psv_err_frm_tx or ovld_frm_tx or
dt_rm_frm_tx or bus_off_sts or send_ack or arbtr_sts or err_ovld_out or
dt_rm_out)
 begin
 case (state)
 idle: begin
 if (((act_err_frm_tx || psv_err_frm_tx) &&
 (~bus_off_sts)) || ovld_frm_tx)
 begin 
 can_bus_out = err_ovld_out;
 nxt_state = err_ovld_tx;
 abort_dt_rm_tx = 1'b0;
 end
 else if (dt_rm_frm_tx && arbtr_sts && (~bus_off_sts))
 begin
 can_bus_out = dt_rm_out;
 nxt_state = dt_rm_tx;
 abort_dt_rm_tx = 1'b0;
 end
 else if ((~arbtr_sts) && send_ack && (~bus_off_sts))
 begin
 can_bus_out = 1'b0;
 nxt_state = idle;
 abort_dt_rm_tx = 1'b0;
 end
 else begin
 can_bus_out = 1'b1;
 nxt_state = idle;
 abort_dt_rm_tx = 1'b0;
 end
 end
 dt_rm_tx: begin
 if (((act_err_frm_tx || psv_err_frm_tx) &&
 (~bus_off_sts)) || ovld_frm_tx)
 begin
 can_bus_out = err_ovld_out;
 nxt_state = err_ovld_tx;
 abort_dt_rm_tx = 1'b1;
 end
 else if (dt_rm_frm_tx && arbtr_sts && (~bus_off_sts))
 begin
 can_bus_out = dt_rm_out;
 nxt_state = dt_rm_tx;
 abort_dt_rm_tx = 1'b0;
 end
 else begin
 can_bus_out = 1'b1;
 nxt_state = idle;
 abort_dt_rm_tx = 1'b0;
 end
 end
 err_ovld_tx: begin
 if (((act_err_frm_tx || psv_err_frm_tx) && (~bus_off_sts
 )) || ovld_frm_tx)
 begin
 can_bus_out = err_ovld_out;
 nxt_state = err_ovld_tx;
 abort_dt_rm_tx = 1'b0;
 end
 else begin
 can_bus_out = 1'b1;
 nxt_state = idle;
 abort_dt_rm_tx = 1'b0; 
 end
 end
 default: begin
 can_bus_out = 1'b1;
 nxt_state = idle;
 abort_dt_rm_tx = 1'b0;
 end
 endcase
 end
// Reg to store the output of can bus for one clock cycle after
//transmission of bit.
always @ (posedge clk or posedge g_rst)
 begin
 if (g_rst)
 tx_bit <= 2'b00;
 else
 tx_bit <= {tx_bit[0], can_bus_out};
 end

endmodule 
