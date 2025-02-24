module bit_stuff (
    clk, 
    g_rst, 
    dt_rm_frm1, 
    bit_stf_intl_1, 
    dt_rm_frm_len1,
    tx_success, 
    err_state, 
    arbtr_sts, 
    abort_dt_rm_tx, 
    re_tran, 
    dt_rm_out,
    dt_rm_frm_tx, 
    arbtr_fld, 
    dt_rm_eof_tx_cmp, 
    txed_lst_bit_ifs, 
    ack_slt,
    ifs_flg_tx
);
input clk;
input g_rst;
input arbtr_sts;
input abort_dt_rm_tx;
input re_tran;
input [1:0] err_state;
input tx_success;
input [16532:0] dt_rm_frm1;
input bit_stf_intl_1;
input [14:0] dt_rm_frm_len1;

output dt_rm_out;
output dt_rm_frm_tx;
output arbtr_fld;
output ack_slt;
output dt_rm_eof_tx_cmp;
output txed_lst_bit_ifs;
output ifs_flg_tx;

reg dt_rm_out;
reg dt_rm_frm_tx;
reg arbtr_fld;
reg ack_slt;
reg dt_rm_eof_tx_cmp;
reg txed_lst_bit_ifs;
reg ifs_flg_tx;
reg [2:0] eof_bit_cnt;
reg [3:0] ifs_bit_cnt;
reg [16532:0] msg;
reg [2:0] one_count;
reg [2:0] zero_count;
reg [14:0] bit_count;
reg [14:0] total_bit_count;
reg [4:0] fixed_bit_count;
reg [3:0] state;

parameter [3:0] idle = 4'd0,
                load = 4'd1,
                dynamic_stuff = 4'd2,
                no_stuff_1 = 4'd3,
                fixed_stuff = 4'd4,
                no_stuff_2 = 4'd5,
                ack_slot = 4'd6,
                ack_delim = 4'd7,
                eof = 4'd8,
                ifs = 4'd9,
                dt_rm_cmp = 4'd10;

// block to determine the next state
always @ (posedge clk or posedge g_rst) begin
    if (g_rst) begin
        state <= idle;
    end else if (abort_dt_rm_tx) begin
        state <= idle;
    end else if (arbtr_sts) begin
        case (state)
            idle: begin
                if (bit_stf_intl_1 || re_tran) begin
                    state <= load;
                end else begin
                    state <= idle;
                end
            end
            load: begin
                state <= dynamic_stuff;
            end
            dynamic_stuff: begin
                if (bit_count == 14'd13) begin
                    state <= no_stuff_1;
                end else begin
                    state <= dynamic_stuff;
                end
            end
            no_stuff_1: begin
                if (bit_count == 14'd19) begin
                    state <= fixed_stuff;
                    fixed_bit_count <= 5'd0;
                end else begin
                    state <= no_stuff_1;
                end
            end
            fixed_stuff: begin
                if (bit_count == (dt_rm_frm_len1 - 14'd21)) begin    
                    state <= no_stuff_2;
                end else begin
                    state <= fixed_stuff;
                end
            end
            no_stuff_2: begin
                if (bit_count == (dt_rm_frm_len1 - 14'd13)) begin    
                    state <= ack_slot;
                end else begin
                    state <= no_stuff_2;
                end
            end
            ack_slot: begin
                state <= ack_delim;
            end
            ack_delim: begin
                state <= eof;
            end
            eof: begin
                if (eof_bit_cnt <= 3'd5) begin
                    state <= eof;
                end else begin
                    state <= ifs;
                end
            end
            ifs: begin
                if (err_state == 2'b0) begin
                    if (ifs_bit_cnt < 4'd2) begin
                        state <= ifs;
                    end else begin
                        state <= dt_rm_cmp;
                    end
                end else if (err_state == 2'b01) begin
                    if (ifs_bit_cnt < 4'd10) begin
                        state <= ifs;
                    end else begin
                        state <= dt_rm_cmp;
                    end
                end
            end
            dt_rm_cmp: begin
                if (tx_success) begin
                    state <= idle;
                end else begin
                    state <= dt_rm_cmp;
                end
            end
            default: begin
                state <= idle;
            end
        endcase
    end else begin
        state <= idle;
    end
end

// block to determine the output
always @ (posedge clk or posedge g_rst) begin
    if (g_rst) begin
        dt_rm_out <= 1'b1;
        ack_slt <= 1'b0;
        msg <= 16533'd0;
        bit_count <= 14'd0;
        total_bit_count <= 14'd0;
        fixed_bit_count <= 5'd0;
        dt_rm_frm_tx <= 1'b0;
        dt_rm_eof_tx_cmp <= 1'b0;
        txed_lst_bit_ifs <= 1'b0;
        one_count <= 3'd0;
        zero_count <= 3'd0;
        eof_bit_cnt <= 3'd0;
        ifs_bit_cnt <= 4'd0;
        ifs_flg_tx <= 1'b0;
    end else begin
        case (state)
            idle: begin
                dt_rm_out <= 1'b1;
                ack_slt <= 1'b0;
                msg <= 16533'd0;
                bit_count <= 14'd0;
                total_bit_count <= 14'd0;
                fixed_bit_count <= 5'd0;
                dt_rm_frm_tx <= 1'b0;
                dt_rm_eof_tx_cmp <= 1'b0;
                txed_lst_bit_ifs <= 1'b0;
                one_count <= 3'd0;
                zero_count <= 3'd0;
                eof_bit_cnt <= 3'd0;
                ifs_bit_cnt <= 4'd0;
                ifs_flg_tx <= 1'b0;
            end
            load: begin
                dt_rm_frm_tx <= 1'b1;
                msg <= dt_rm_frm1;
            end 
            dynamic_stuff: begin
                if (one_count == 3'd5 || zero_count == 3'd5) begin
                    dt_rm_out <= ~dt_rm_out;  
                    one_count <= 3'd0;
                    zero_count <= 3'd0;
                    total_bit_count <= total_bit_count + 14'd1;
                end else begin
                    if (msg[16532] == 1'b1) begin
                        dt_rm_out <= 1'b1;
                        one_count <= one_count + 3'd1;
                        zero_count <= 3'd0;
                    end else begin
                        dt_rm_out <= 1'b0;
                        zero_count <= zero_count + 3'd1;
                        one_count <= 3'd0;
                    end
                    msg <= msg << 1;
                    bit_count <= bit_count + 1;
                    total_bit_count <= total_bit_count + 14'd1;
                end
            end
            no_stuff_1: begin
                if (msg[16532] == 1'b1) begin
                    dt_rm_out <= 1'b1;
                end else begin
                    dt_rm_out <= 1'b0;
                end
                msg <= msg << 1;
                bit_count <= bit_count + 14'd1;
                total_bit_count <= total_bit_count + 14'd1;
            end
            fixed_stuff: begin
                if (fixed_bit_count == 5'd15) begin
                    dt_rm_out <= ~dt_rm_out;  
                    total_bit_count <= total_bit_count + 14'd1;
                    fixed_bit_count <= 5'd0;
                end else begin
                    if (msg[16532] == 1'b1) begin
                        dt_rm_out <= 1'b1;
                    end else begin
                        dt_rm_out <= 1'b0;
                    end
                    msg <= msg << 1;
                    bit_count <= bit_count + 14'd1;
                    total_bit_count <= total_bit_count + 14'd1;
                    fixed_bit_count <= fixed_bit_count + 5'd1;
                end
            end
            no_stuff_2: begin
                if (msg[16532] == 1'b1) begin
                    dt_rm_out <= 1'b1;
                end else begin
                    dt_rm_out <= 1'b0;
                end
                msg <= msg << 1;
                bit_count <= bit_count + 14'd1;
                total_bit_count <= total_bit_count + 14'd1;
            end
            ack_slot: begin
                ack_slt <= 1'b1;
                dt_rm_out <= 1'b1;
                bit_count <= bit_count + 14'd1;
                total_bit_count <= total_bit_count + 14'd1;
            end
            ack_delim: begin
                ack_slt <= 1'b0;
                dt_rm_out <= 1'b1;
                bit_count <= bit_count + 14'd1;
                total_bit_count <= total_bit_count + 14'd1;
            end
            eof: begin
                if (eof_bit_cnt <= 3'd5) begin
                    dt_rm_out <= 1'b1;
                    bit_count <= bit_count + 14'd1;
                    total_bit_count <= total_bit_count + 14'd1;
                    eof_bit_cnt <= eof_bit_cnt + 3'd1;
                end else begin
                    ack_slt <= 1'b0;
                    dt_rm_out <= 1'b1;
                    bit_count <= bit_count + 14'd1;
                    total_bit_count <= total_bit_count + 14'd1;
                    eof_bit_cnt <= 3'd0;
                    ifs_flg_tx <= 1'b1;
                end
            end
            ifs: begin
                if (err_state == 2'b0) begin
                    if (ifs_bit_cnt < 4'd2) begin
                        dt_rm_out <= 1'b1;
                        bit_count <= bit_count + 14'd1;
                        total_bit_count <= total_bit_count + 14'd1;
                        ifs_bit_cnt <= ifs_bit_cnt + 4'd1;
                        ifs_flg_tx <= 1'b1;
                        if (ifs_bit_cnt == 4'd0)
                            dt_rm_eof_tx_cmp <= 1'b1;
                        else 
                            dt_rm_eof_tx_cmp <= 1'b0;
                    end else begin
                        dt_rm_out <= 1'b1;
                        txed_lst_bit_ifs <= 1'b1;
                        bit_count <= bit_count + 14'd1;
                        total_bit_count <= total_bit_count + 14'd1;
                        ifs_bit_cnt <= 4'd0;
                        ifs_flg_tx <= 1'b0;
                    end
                end else if (err_state == 2'b01) begin
                    if (ifs_bit_cnt < 4'd10) begin
                        dt_rm_out <= 1'b1;
                        bit_count <= bit_count + 14'd1; 
                        total_bit_count <= total_bit_count + 14'd1;
                        ifs_bit_cnt <= ifs_bit_cnt + 4'd1;
                        ifs_flg_tx <= 1'b1;
                        if (ifs_bit_cnt == 4'd0)
                            dt_rm_eof_tx_cmp <= 1'b1;
                        else 
                            dt_rm_eof_tx_cmp <= 1'b0;
                    end else begin
                        dt_rm_out <= 1'b1;
                        txed_lst_bit_ifs <= 1'b1;
                        bit_count <= bit_count + 14'd1;
                        total_bit_count <= total_bit_count + 14'd1;
                        ifs_bit_cnt <= 4'd0;
                        ifs_flg_tx <= 1'b0;
                    end
                end
            end
            dt_rm_cmp: begin
                dt_rm_frm_tx <= 1'b0;
                txed_lst_bit_ifs <= 1'b0;
                dt_rm_out <= 1'b1;
            end
            default: begin
                dt_rm_out <= 1'b1;
            end
        endcase
    end
end

// block to indicate transmission of arbtr field
always @ (posedge clk or posedge g_rst) begin
    if (g_rst)
        arbtr_fld <= 1'b0;
    else if (~arbtr_sts)
        arbtr_fld <= 1'b0;
    else if ((bit_count > 14'd0) && (bit_count < 14'd16))
        arbtr_fld <= 1'b1;
    else
        arbtr_fld <= 1'b0;
end

endmodule