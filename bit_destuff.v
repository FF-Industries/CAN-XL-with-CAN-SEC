module bit_destuff (clk, g_rst, arbtr_sts, bit_destf_intl, sampled_bit, tx_success, rx_success, 
act_err_frm_tx, psv_err_frm_tx, ovld_frm_tx, serial_in,serial_in1,rcvd_bt_cnt, de_stuff , one_count, 
zero_count,one_count1, zero_count1, rcvd_data_len, rcvd_eof_flg, rcvd_lst_bit_ifs, 
rcvd_pcrc_flg, rcvd_fcrc_flg, rcvd_lst_bit_eof, sof, rcvd_prio_id, rcvd_rrs, ide, 
fdf, xlf, resXL, adh, dh1, dh2, dl1, sdt, sec, rcvd_dlc, sbc, pcrc, vcid, af, 
rcvd_data_frm, fcrc, fcp, dah, ah1, al1, ah2, ack_slot, acl_del, pcrc_enable, 
fcrc_enable, rx_pcrc_intl,rx_fcrc_intl, bit_count,enable1,enable2,rcvd_data
);

    input clk;
    input g_rst;
    input arbtr_sts; 
    input bit_destf_intl;
    input sampled_bit;
    input tx_success;
    input rx_success;
    input act_err_frm_tx;
    input psv_err_frm_tx;
    input ovld_frm_tx;  
    
    output de_stuff;
    output serial_in;
    output serial_in1;
    output [14:0] rcvd_bt_cnt;
    output [2:0] one_count;
    output [2:0] zero_count;
	output [2:0] one_count1;
    output [2:0] zero_count1;
    output [13:0] rcvd_data_len;
    output rcvd_eof_flg;
    output rcvd_lst_bit_ifs;
    output rcvd_pcrc_flg;
    output rcvd_fcrc_flg;  
    output rcvd_lst_bit_eof;
    output sof;
    output [10:0] rcvd_prio_id;
    output rcvd_rrs;
    output ide;
    output fdf;
    output xlf;
    output resXL;
    output adh;
    output dh1;
    output dh2;
    output dl1;
    output [7:0] sdt;
    output sec;
    output [10:0] rcvd_dlc;
    output [2:0] sbc;
    output [12:0] pcrc; 
    output [7:0] vcid;
    output [31:0] af;
    output [16383:0] rcvd_data_frm; 
    output [31:0] fcrc; 
    output [3:0] fcp;
    output dah;
    output ah1;
    output al1;
    output ah2;
    output ack_slot;
    output acl_del;
    output pcrc_enable;
    output fcrc_enable;
    output rx_pcrc_intl;
    output rx_fcrc_intl;
    output [4:0] bit_count;
    output enable1;
    output enable2;
    output [127:0] rcvd_data;

    reg [127:0] rcvd_data;
    reg [16532:0] destf_out; 
    reg de_stuff;
    reg sampled_bit2; 
    reg serial_in;
    reg serial_in1;
    reg [14:0] rcvd_bt_cnt;
  	reg [14:0] rcvd_bt_cnt2;
    reg [2:0] one_count;
    reg [2:0] zero_count;
	reg [2:0] one_count1;
    reg [2:0] zero_count1;
    reg pcrc_enable;
    reg fcrc_enable;
    reg rx_pcrc_intl;
    reg rx_fcrc_intl;
    reg [13:0] rcvd_data_len;
    reg rcvd_eof_flg;
    reg rcvd_lst_bit_ifs;
    reg rcvd_pcrc_flg;
    reg rcvd_fcrc_flg;  
    reg rcvd_lst_bit_eof;
    reg sof;
    reg [10:0] rcvd_prio_id;
    reg rcvd_rrs;
    reg ide;
    reg fdf;
    reg xlf;
    reg resXL;
    reg adh;
    reg dh1;
    reg dh2;
    reg dl1;
    reg [7:0] sdt;
    reg sec;
    reg [10:0] rcvd_dlc;
    reg [2:0] sbc;
    reg [12:0] pcrc; 
    reg [7:0] vcid;
    reg [31:0] af;
    reg [16383:0] rcvd_data_frm; 
    reg [31:0] fcrc; 
    reg [3:0] fcp;
    reg dah;
    reg ah1;
    reg al1;
    reg ah2;
    reg ack_slot;
    reg acl_del;
  	reg [6:0] eof;
    reg [2:0] ifs;  
    reg [5:0] state, nxt_state;
    reg [4:0] bit_count;
    reg dynamic_phase;
    reg fixed_phase;
  	reg [10:0] rcvd_dlc1; 
  	reg [1:0] de_stuff_count;
  	reg enable1;
  	reg enable2;
  	

    always @(posedge clk or posedge g_rst) begin
        if (g_rst) begin
            destf_out <= 16533'd0; 
            de_stuff <= 1'b0;
            sampled_bit2 <= 1'b0;
            one_count <= 3'd0;
            one_count1 <= 3'd0;
            zero_count <= 3'd0;
            zero_count1 <= 3'd0;
            bit_count <= 5'd0;
            rcvd_bt_cnt <= 15'd0;
            rcvd_bt_cnt2 <= 15'd0; 
            dynamic_phase <= 1'b1;
            fixed_phase <= 1'b0;
            rcvd_dlc1 <= 11'd0; 
            de_stuff_count <= 2'd0;
        end else if (bit_destf_intl) begin
         if (sampled_bit == 1) begin
            one_count1 <= one_count1 + 1;
            zero_count1 <= 3'd0;  
        end else begin
            zero_count1 <= zero_count1 + 1;
            one_count1 <= 3'd0;  
        end
          	if (rcvd_bt_cnt < 97 + (rcvd_dlc1 * 8) + 53) begin
                if (dynamic_phase) begin
                    // Dynamic stuffing phase
                    if (one_count == 5) begin
                        if (sampled_bit == 0) begin
                            de_stuff <= 1'b1;
                            one_count <= 3'd0;
                        end else begin
                            de_stuff <= 1'b1;
                            one_count <= 1;
                            zero_count <= 3'd0;
                        end
                    end else if (zero_count == 5) begin
                        if (sampled_bit == 1) begin
                            de_stuff <= 1'b1;
                            zero_count <= 3'd0;
                        end else begin
                            de_stuff <= 1'b1;
                            zero_count <= 1;
                            one_count <= 3'd0;
                        end
                    end else begin
                        destf_out <= {destf_out[16531:0], sampled_bit}; 
                        sampled_bit2 <= sampled_bit; 
                        de_stuff <= 1'b0;
                        if (sampled_bit == 1) begin
                            one_count <= one_count + 1;
                            zero_count <= 3'd0;
                        end else begin
                            zero_count <= zero_count + 1;
                            one_count <= 3'd0;
                        end
                        rcvd_bt_cnt <= rcvd_bt_cnt + 1;
                    end
                if (de_stuff && (rcvd_bt_cnt2 <= 17)) begin
                    de_stuff_count <= de_stuff_count + 1;
                end
                    // Transition to fixed stuffing phase
                    if (rcvd_bt_cnt == 14) begin
                        dynamic_phase <= 1'b0;
                        fixed_phase <= 1'b1;
                        one_count <= 3'd0;
                        zero_count <= 3'd0;
                    end
                end else if (fixed_phase) begin
                    // Fixed stuffing phase
                    if (rcvd_bt_cnt >= 20) begin
                        if (bit_count == 15) begin
                            de_stuff <= 1'b1;
                            bit_count <= 5'd0;
                    // Transition to no stuffing phase
                    if (rcvd_bt_cnt == 97 + (rcvd_dlc1 * 8) + 32) begin
                        fixed_phase <= 1'b0;
                    end
                        end else begin
                            destf_out <= {destf_out[16531:0], sampled_bit}; 
                            sampled_bit2 <= sampled_bit; 
                            de_stuff <= 1'b0;
                            bit_count <= bit_count + 1;
                            rcvd_bt_cnt <= rcvd_bt_cnt + 1;
                    // Transition to no stuffing phase
                    if (rcvd_bt_cnt == 97 + (rcvd_dlc1 * 8) + 32) begin
                        fixed_phase <= 1'b0;
                        bit_count <= 5'd0;
                    end
                        end
                    end else begin
                        destf_out <= {destf_out[16531:0], sampled_bit}; 
                        sampled_bit2 <= sampled_bit;
                        de_stuff <= 1'b0;
                        rcvd_bt_cnt <= rcvd_bt_cnt + 1;
                    // Transition to no stuffing phase
                    if (rcvd_bt_cnt == 97 + (rcvd_dlc1 * 8) + 32) begin
                        fixed_phase <= 1'b0;
                        bit_count <= 5'd0;
                    end
                    end
                end else begin
                    // No stuffing phase
                    destf_out <= {destf_out[16531:0], sampled_bit}; 
                    sampled_bit2 <= sampled_bit; 
                    de_stuff <= 1'b0;
                    rcvd_bt_cnt <= rcvd_bt_cnt + 1;
                end
            end

          if (rcvd_bt_cnt == 97 + (rcvd_dlc1 * 8) + 52) begin
                 destf_out <= 16533'd0; 
                de_stuff <= 1'b0;
                sampled_bit2 <= 1'b0; 
                one_count <= 3'd0;
                zero_count <= 3'd0;
                bit_count <= 5'd0;
                rcvd_bt_cnt <= 15'd0;
                dynamic_phase <= 1'b1;
                fixed_phase <= 1'b0;
                rcvd_dlc1 <= 11'd0; 
                de_stuff_count <= 2'd0;
            end

        if (de_stuff_count == 2'd0) begin
            case (rcvd_bt_cnt2)
                7'd30: rcvd_dlc1[10] <= sampled_bit;
                7'd31: rcvd_dlc1[9] <= sampled_bit;
                7'd32: rcvd_dlc1[8] <= sampled_bit;
                7'd33: rcvd_dlc1[7] <= sampled_bit;
                7'd34: rcvd_dlc1[6] <= sampled_bit;
                7'd36: rcvd_dlc1[5] <= sampled_bit;
                7'd37: rcvd_dlc1[4] <= sampled_bit;
                7'd38: rcvd_dlc1[3] <= sampled_bit;
                7'd39: rcvd_dlc1[2] <= sampled_bit;
                7'd40: rcvd_dlc1[1] <= sampled_bit;
                7'd41: rcvd_dlc1[0] <= sampled_bit;
                default: ;
            endcase
        end else if (de_stuff_count == 2'd1) begin
            case (rcvd_bt_cnt2)
                7'd31: rcvd_dlc1[10] <= sampled_bit;
                7'd32: rcvd_dlc1[9] <= sampled_bit;
                7'd33: rcvd_dlc1[8] <= sampled_bit;
                7'd34: rcvd_dlc1[7] <= sampled_bit;
                7'd35: rcvd_dlc1[6] <= sampled_bit;
                7'd37: rcvd_dlc1[5] <= sampled_bit;
                7'd38: rcvd_dlc1[4] <= sampled_bit;
                7'd39: rcvd_dlc1[3] <= sampled_bit;
                7'd40: rcvd_dlc1[2] <= sampled_bit;
                7'd41: rcvd_dlc1[1] <= sampled_bit;
                7'd42: rcvd_dlc1[0] <= sampled_bit;
                default: ;
            endcase
        end else if (de_stuff_count == 2'd2) begin
            case (rcvd_bt_cnt2)
                7'd32: rcvd_dlc1[10] <= sampled_bit;
                7'd33: rcvd_dlc1[9] <= sampled_bit;
                7'd34: rcvd_dlc1[8] <= sampled_bit;
                7'd35: rcvd_dlc1[7] <= sampled_bit;
                7'd36: rcvd_dlc1[6] <= sampled_bit;
                7'd38: rcvd_dlc1[5] <= sampled_bit;
                7'd39: rcvd_dlc1[4] <= sampled_bit;
                7'd40: rcvd_dlc1[3] <= sampled_bit;
                7'd41: rcvd_dlc1[2] <= sampled_bit;
                7'd42: rcvd_dlc1[1] <= sampled_bit;
                7'd43: rcvd_dlc1[0] <= sampled_bit;
                default: ;
            endcase
        end
            rcvd_bt_cnt2 <= rcvd_bt_cnt2 + 1;
        end else begin
            destf_out <= 16533'd0; 
            de_stuff <= 1'b0;
            sampled_bit2 <= 1'b0; 
            one_count <= 3'd0;
            zero_count <= 3'd0;
            bit_count <= 5'd0;
            rcvd_bt_cnt <= 15'd0;
            rcvd_bt_cnt2 <= 15'd0; 
            dynamic_phase <= 1'b1;
            fixed_phase <= 1'b0;
            rcvd_dlc1 <= 11'd0; 
            de_stuff_count <= 2'd0;
        end
    end  

    parameter [1:0] 
        idle           = 2'd0,
        receive        = 2'd1,
        complete       = 2'd2; 

    // This always block is triggered on the positive edge of the clock or the positive edge of the global reset.
    always @ (posedge clk or posedge g_rst)
    begin
        if (g_rst)
            serial_in <= 1'b1;
        else
            serial_in <= sampled_bit;
    end
    
        always @ (posedge clk or posedge g_rst)
    begin
        if (g_rst)
            serial_in1 <= 1'b1;
        else
            serial_in1 <= sampled_bit2;
    end

 /*    // This always block resets all outputs when IFS is hit except rcvd_lst_bit_ifs
    always @ (posedge clk or posedge g_rst)
    begin
      if (rcvd_bt_cnt == (14'd98 + rcvd_dlc * 8 + 51) && state == receive )
        begin
            sof <= 1'b0;
            rcvd_prio_id <= 11'b0;
            rcvd_rrs <= 1'b0;
            ide <= 1'b0;
            fdf <= 1'b0;
            xlf <= 1'b0;
            resXL <= 1'b0;
            adh <= 1'b0;
            dh1 <= 1'b0;
            dh2 <= 1'b0;
            dl1 <= 1'b0;
            sdt <= 8'b0;
            sec <= 1'b0;
            rcvd_dlc <= 11'b0;
            sbc <= 3'b0;
            pcrc <= 13'b0;
            vcid <= 8'b0;
            af <= 32'b0;
            fcrc <= 32'b0;
            fcp <= 4'b0;
            dah <= 1'b0;
            ah1 <= 1'b0;
            al1 <= 1'b0;
            ah2 <= 1'b0;
            ack_slot <= 1'b0;
            acl_del <= 1'b0;
            eof <= 7'b0;
            rcvd_data_frm <= 16384'b0;
            rcvd_data_len <= 14'd0;
            rcvd_eof_flg <= 1'b0;
            rcvd_lst_bit_eof <= 1'b0;
            rcvd_lst_bit_ifs <= 1'b0;
            rcvd_pcrc_flg <= 1'b0;
            rcvd_fcrc_flg <= 1'b0;
            pcrc_enable <= 1'b0;
            fcrc_enable <= 1'b0;
            rx_crc_intl <= 1'b0;
            one_count <= 3'd0;
            zero_count <= 3'd0; 
            enable1 <= 1'b0;
            data <= 128'd0;
            enable2 <= 1'b0;
            
        end
    end */

    // Setting and resetting rcvd_pcrc_flg and rcvd_fcrc_flg
always @(posedge clk or posedge g_rst) begin
    if (g_rst) begin
        rcvd_pcrc_flg <= 1'b0;
        rcvd_fcrc_flg <= 1'b0;
    end else begin
        if (rx_success || tx_success) begin
            rcvd_pcrc_flg <= 1'b0;
            rcvd_fcrc_flg <= 1'b0;
        end else begin
            if (rcvd_bt_cnt == 14'd57) begin
                rcvd_pcrc_flg <= 1'b1;
            end else if (rcvd_bt_cnt == 14'd58) begin
                rcvd_pcrc_flg <= 1'b0;
            end

            if (rcvd_bt_cnt == 14'd97 + rcvd_dlc * 8 + 32) begin
                rcvd_fcrc_flg <= 1'b1;
            end else if (rcvd_bt_cnt == 14'd97 + rcvd_dlc * 8 + 32) begin
                rcvd_fcrc_flg <= 1'b0;
            end

            if (state == complete) begin
                rcvd_pcrc_flg <= 1'b0;
                rcvd_fcrc_flg <= 1'b0;
            end
        end
    end
end

    
    // This always block updates the current state based on the next state.
    always @ (posedge clk or posedge g_rst)
    begin
        if (g_rst)
            state <= idle;
        else 
            state <= nxt_state;
    end

// State transition logic
always @(state or bit_destf_intl or act_err_frm_tx or psv_err_frm_tx or ovld_frm_tx or 
         rcvd_bt_cnt or rcvd_dlc1) 
begin
    case (state)
        idle: begin
            if (bit_destf_intl && ~(act_err_frm_tx || psv_err_frm_tx || ovld_frm_tx)) 
                nxt_state = receive;
            else 
                nxt_state = idle;
        end
        receive: begin
            if (~(act_err_frm_tx || psv_err_frm_tx || ovld_frm_tx)) begin
                if (rcvd_bt_cnt >= (14'd97 + rcvd_dlc1 * 8 + 52)) begin
                    nxt_state = complete;
                end else begin
                    nxt_state = receive;
                end
            end else begin
                nxt_state = idle;
            end
        end
        complete: begin
            nxt_state = idle;
        end
        default: begin
            nxt_state = idle;
        end
    endcase
end

 // This always block samples the data for each state.
always @ (posedge clk or posedge g_rst)
begin
    if (g_rst)
    begin
        sof <= 1'b0;
        rcvd_prio_id <= 11'b0;
        rcvd_rrs <= 1'b0;
        ide <= 1'b0;
        fdf <= 1'b0;
        xlf <= 1'b0;
        resXL <= 1'b0;
        adh <= 1'b0;
        dh1 <= 1'b0;
        dh2 <= 1'b0;
        dl1 <= 1'b0;
        sdt <= 8'b0;
        sec <= 1'b0;
        rcvd_dlc <= 11'b0;
        sbc <= 3'b0;
        pcrc <= 13'b0;
        vcid <= 8'b0;
        af <= 32'b0;
        fcrc <= 32'b0;
        fcp <= 4'b0;
        dah <= 1'b0;
        ah1 <= 1'b0;
        al1 <= 1'b0;
        ah2 <= 1'b0;
        ack_slot <= 1'b0;
        acl_del <= 1'b0;
        eof <= 7'b0;
        ifs <= 3'b0;
        rcvd_data_frm <= 16384'b0;
        rcvd_data_len <= 14'd0;
        rcvd_eof_flg <= 1'b0;
        rcvd_lst_bit_ifs <= 1'b0;
        rcvd_lst_bit_eof <= 1'b0;
        rcvd_pcrc_flg <= 1'b0;
        rcvd_fcrc_flg <= 1'b0;
        enable1 <= 1'b0;
        enable2 <= 1'b0;
        rcvd_data <= 128'd0;
    end
    else if (rx_success)
    begin
        sof <= 1'b0;
        rcvd_prio_id <= 11'b0;
        rcvd_rrs <= 1'b0;
        ide <= 1'b0;
        fdf <= 1'b0;
        xlf <= 1'b0;
        resXL <= 1'b0;
        adh <= 1'b0;
        dh1 <= 1'b0;
        dh2 <= 1'b0;
        dl1 <= 1'b0;
        sdt <= 8'b0;
        sec <= 1'b0;
        rcvd_dlc <= 11'b0;
        sbc <= 3'b0;
        pcrc <= 13'b0;
        vcid <= 8'b0;
        af <= 32'b0;
        fcrc <= 32'b0;
        fcp <= 4'b0;
        dah <= 1'b0;
        ah1 <= 1'b0;
        al1 <= 1'b0;
        ah2 <= 1'b0;
        ack_slot <= 1'b0;
        acl_del <= 1'b0;
        eof <= 7'b0;
        ifs <= 3'b0;
        rcvd_data_frm <= 384'b0;
        rcvd_data_len <= 14'd0;
        rcvd_eof_flg <= 1'b0;
        rcvd_lst_bit_ifs <= 1'b0;
        rcvd_lst_bit_eof <= 1'b0;
        rcvd_pcrc_flg <= 1'b0;
        rcvd_fcrc_flg <= 1'b0;
        rcvd_lst_bit_ifs <= 1'b0; 
        enable1 <= 1'b0;
        enable2 <= 1'b0;
        rcvd_data <= 128'd0;
    end
    else if (tx_success)
    begin
        sof <= 1'b0;
        rcvd_prio_id <= 11'b0;
        rcvd_rrs <= 1'b0;
        ide <= 1'b0;
        fdf <= 1'b0;
        xlf <= 1'b0;
        resXL <= 1'b0;
        adh <= 1'b0;
        dh1 <= 1'b0;
        dh2 <= 1'b0;
        dl1 <= 1'b0;
        sdt <= 8'b0;
        rcvd_dlc <= 11'b0;
        sbc <= 3'b0;
        pcrc <= 13'b0;
        vcid <= 8'b0;
        af <= 32'b0;
        fcrc <= 32'b0;
        fcp <= 4'b0;
        dah <= 1'b0;
        ah1 <= 1'b0;
        al1 <= 1'b0;
        ah2 <= 1'b0;
        ack_slot <= 1'b0;
        acl_del <= 1'b0;
        eof <= 7'b0;
        ifs <= 3'b0;
        rcvd_data_frm <= 384'b0;
        rcvd_data_len <= 14'd0;
        rcvd_pcrc_flg <= 1'b0;
        rcvd_fcrc_flg <= 1'b0;
        rcvd_lst_bit_ifs <= 1'b0; 
        enable1 <= 1'b0;
        rcvd_data <= 128'd0;
	end
        else if (state == receive)
        begin
            // Sample the current bit into the correct field based on bit count
            case (rcvd_bt_cnt)
                14'd1: sof <= sampled_bit2;
                14'd2: rcvd_prio_id[10] <= sampled_bit2;
                14'd3: rcvd_prio_id[9] <= sampled_bit2;
                14'd4: rcvd_prio_id[8] <= sampled_bit2;
                14'd5: rcvd_prio_id[7] <= sampled_bit2;
                14'd6: rcvd_prio_id[6] <= sampled_bit2;
                14'd7: rcvd_prio_id[5] <= sampled_bit2;
                14'd8: rcvd_prio_id[4] <= sampled_bit2;
                14'd9: rcvd_prio_id[3] <= sampled_bit2;
                14'd10: rcvd_prio_id[2] <= sampled_bit2;
                14'd11: rcvd_prio_id[1] <= sampled_bit2;
                14'd12: rcvd_prio_id[0] <= sampled_bit2;
                14'd13: rcvd_rrs <= sampled_bit2;
                14'd14: ide <= sampled_bit2;
                14'd15: fdf <= sampled_bit2;
                14'd16: xlf <= sampled_bit2;
                14'd17: resXL <= sampled_bit2;
                14'd18: adh <= sampled_bit2;
                14'd19: dh1 <= sampled_bit2;
                14'd20: dh2 <= sampled_bit2;
                14'd21: dl1 <= sampled_bit2;
                14'd22: sdt[7] <= sampled_bit2;
                14'd23: sdt[6] <= sampled_bit2;
                14'd24: sdt[5] <= sampled_bit2;
                14'd25: sdt[4] <= sampled_bit2;
                14'd26: sdt[3] <= sampled_bit2;
                14'd27: sdt[2] <= sampled_bit2;
                14'd28: sdt[1] <= sampled_bit2;
                14'd29: sdt[0] <= sampled_bit2;
                14'd30: sec <= sampled_bit2;
                14'd31: rcvd_dlc[10] <= sampled_bit2;
                14'd32: rcvd_dlc[9] <= sampled_bit2;
                14'd33: rcvd_dlc[8] <= sampled_bit2;
                14'd34: rcvd_dlc[7] <= sampled_bit2;
                14'd35: rcvd_dlc[6] <= sampled_bit2;
                14'd36: rcvd_dlc[5] <= sampled_bit2;
                14'd37: rcvd_dlc[4] <= sampled_bit2;
                14'd38: rcvd_dlc[3] <= sampled_bit2;
                14'd39: rcvd_dlc[2] <= sampled_bit2;
                14'd40: rcvd_dlc[1] <= sampled_bit2;
                14'd41: rcvd_dlc[0] <= sampled_bit2;
                14'd42: sbc[2] <= sampled_bit2;
                14'd43: sbc[1] <= sampled_bit2;
                14'd44: sbc[0] <= sampled_bit2;
                14'd45: pcrc[12] <= sampled_bit2;
                14'd46: pcrc[11] <= sampled_bit2;
                14'd47: pcrc[10] <= sampled_bit2;
                14'd48: pcrc[9] <= sampled_bit2;
                14'd49: pcrc[8] <= sampled_bit2;
                14'd50: pcrc[7] <= sampled_bit2;
                14'd51: pcrc[6] <= sampled_bit2;
                14'd52: pcrc[5] <= sampled_bit2;
                14'd53: pcrc[4] <= sampled_bit2;
                14'd54: pcrc[3] <= sampled_bit2;
                14'd55: pcrc[2] <= sampled_bit2;
                14'd56: pcrc[1] <= sampled_bit2;
                14'd57: pcrc[0] <= sampled_bit2;
                14'd58: vcid[7] <= sampled_bit2;
                14'd59: vcid[6] <= sampled_bit2;
                14'd60: vcid[5] <= sampled_bit2;
                14'd61: vcid[4] <= sampled_bit2;
                14'd62: vcid[3] <= sampled_bit2;
                14'd63: vcid[2] <= sampled_bit2;
                14'd64: vcid[1] <= sampled_bit2;
                14'd65: vcid[0] <= sampled_bit2;
                14'd66: af[31] <= sampled_bit2;
                14'd67: af[30] <= sampled_bit2;
                14'd68: af[29] <= sampled_bit2;
                14'd69: af[28] <= sampled_bit2;
                14'd70: af[27] <= sampled_bit2;
                14'd71: af[26] <= sampled_bit2;
                14'd72: af[25] <= sampled_bit2;
                14'd73: af[24] <= sampled_bit2;
                14'd74: af[23] <= sampled_bit2;
                14'd75: af[22] <= sampled_bit2;
                14'd76: af[21] <= sampled_bit2;
                14'd77: af[20] <= sampled_bit2;
                14'd78: af[19] <= sampled_bit2;
                14'd79: af[18] <= sampled_bit2;
                14'd80: af[17] <= sampled_bit2;
                14'd81: af[16] <= sampled_bit2;
                14'd82: af[15] <= sampled_bit2;
                14'd83: af[14] <= sampled_bit2;
                14'd84: af[13] <= sampled_bit2;
                14'd85: af[12] <= sampled_bit2;
                14'd86: af[11] <= sampled_bit2;
                14'd87: af[10] <= sampled_bit2;
                14'd88: af[9] <= sampled_bit2;
                14'd89: af[8] <= sampled_bit2;
                14'd90: af[7] <= sampled_bit2;
                14'd91: af[6] <= sampled_bit2;
                14'd92: af[5] <= sampled_bit2;
                14'd93: af[4] <= sampled_bit2;
                14'd94: af[3] <= sampled_bit2;
                14'd95: af[2] <= sampled_bit2;
                14'd96: af[1] <= sampled_bit2;
                14'd97: af[0] <= sampled_bit2;
                default: 
                  if (rcvd_bt_cnt >= 14'd98 && rcvd_bt_cnt < 14'd98 + rcvd_dlc * 8) begin
                            rcvd_data_frm[(14'd97 + rcvd_dlc * 8 - rcvd_bt_cnt)] <= sampled_bit2;
                            rcvd_data_len <= rcvd_bt_cnt - 14'd97;
                    end else if (rcvd_bt_cnt >= 14'd98 + rcvd_dlc * 8 && rcvd_bt_cnt < 14'd98 + rcvd_dlc * 8 + 32) begin
                        fcrc[(14'd97 + rcvd_dlc * 8 + 32 - rcvd_bt_cnt)] <= sampled_bit2;
                        if (sec) begin
                        enable1 <= 1'b1;
                        enable2 <= 1'b1;
                        end
                    end else if (rcvd_bt_cnt >= 14'd98 + rcvd_dlc * 8 + 32 && rcvd_bt_cnt < 14'd98 + rcvd_dlc * 8 + 36) begin
                        fcp[(14'd97 + rcvd_dlc * 8 + 36 - rcvd_bt_cnt)] <= sampled_bit2;
                    end else if (rcvd_bt_cnt >= 14'd98 + rcvd_dlc * 8 + 36 && rcvd_bt_cnt < 14'd98 + rcvd_dlc * 8 + 37) begin
                        dah <= sampled_bit2;
                    end else if (rcvd_bt_cnt >= 14'd98 + rcvd_dlc * 8 + 37 && rcvd_bt_cnt < 14'd98 + rcvd_dlc * 8 + 38) begin
                        ah1 <= sampled_bit2;
                    end else if (rcvd_bt_cnt >= 14'd98 + rcvd_dlc * 8 + 38 && rcvd_bt_cnt < 14'd98 + rcvd_dlc * 8 + 39) begin
                        al1 <= sampled_bit2;
                    end else if (rcvd_bt_cnt >= 14'd98 + rcvd_dlc * 8 + 39 && rcvd_bt_cnt < 14'd98 + rcvd_dlc * 8 + 40) begin
                        ah2 <= sampled_bit2;
                    end else if (rcvd_bt_cnt >= 14'd98 + rcvd_dlc * 8 + 40 && rcvd_bt_cnt < 14'd98 + rcvd_dlc * 8 + 41) begin
                        ack_slot <= sampled_bit2;
                    end else if (rcvd_bt_cnt >= 14'd98 + rcvd_dlc * 8 + 41 && rcvd_bt_cnt < 14'd98 + rcvd_dlc * 8 + 42) begin
                        acl_del <= sampled_bit2;
                    end else if (rcvd_bt_cnt >= 14'd98 + rcvd_dlc * 8 + 42 && rcvd_bt_cnt < 14'd98 + rcvd_dlc * 8 + 49) begin
                      	eof[(14'd98 + rcvd_dlc * 8 + 48 - rcvd_bt_cnt)] <= sampled_bit2;
                    end else if (rcvd_bt_cnt >= 14'd98 + rcvd_dlc * 8 + 49 && rcvd_bt_cnt < 14'd98 + rcvd_dlc * 8 + 52) begin
                      	ifs[(14'd98 + rcvd_dlc * 8 + 51 - rcvd_bt_cnt)] <= sampled_bit2;
                    end
            endcase
			 if (rcvd_bt_cnt > 18) adh <= 1'b0;
			 if (rcvd_bt_cnt > (14'd97 + rcvd_dlc * 8 + 14'd32 + 14'd5 ) ) dah <= 1'b0;
			 
          	if (rcvd_bt_cnt == 14'd98 + rcvd_dlc * 8 + 48) begin
                rcvd_eof_flg <= 1'b1; 
            end else if (rcvd_bt_cnt == 14'd98 + rcvd_dlc * 8 + 49) begin
                rcvd_eof_flg <= 1'b0; 
            end  
          if (rcvd_bt_cnt == 14'd98 + rcvd_dlc * 8 + 47) begin
                rcvd_lst_bit_eof <= 1'b1; 
          end else if (rcvd_bt_cnt == 14'd98 + rcvd_dlc * 8 + 48) begin
                rcvd_lst_bit_eof <= 1'b0; 
          end
          if (rcvd_bt_cnt == 14'd98 + rcvd_dlc * 8 + 50) begin
                rcvd_lst_bit_ifs <= 1'b1;  
          end else if (rcvd_bt_cnt == 14'd98 + rcvd_dlc * 8 + 51) begin
                rcvd_lst_bit_ifs <= 1'b0; 
          end
        end
    end

    // Block to increment one_count
    always @ (posedge clk or posedge g_rst)
    begin
        if (g_rst)
            one_count <= 3'd0;
        else if (bit_destf_intl && state == receive && rcvd_bt_cnt < (14'd98 + rcvd_dlc * 8 + 52) && sampled_bit2)
            one_count <= one_count + 3'd1;
        else
            one_count <= 3'd0;
    end

    // Block to increment zero_count
    always @ (posedge clk or posedge g_rst)
    begin
        if (g_rst)
            zero_count <= 3'd0;
        else if (bit_destf_intl && state == receive && rcvd_bt_cnt < (14'd98 + rcvd_dlc * 8 + 52) && ~sampled_bit2)
            zero_count <= zero_count + 3'd1;
        else
            zero_count <= 3'd0;
    end

always @ (posedge clk or posedge g_rst) begin
    if (g_rst) begin
        pcrc_enable <= 1'b0;
        rx_pcrc_intl <= 1'b1;        
    end else if (rcvd_bt_cnt == 14'd0) begin
        pcrc_enable <= 1'b0;
        rx_pcrc_intl <= 1'b1;
    end else if (rcvd_bt_cnt == 14'd2) begin
        pcrc_enable <= 1'b1;
        rx_pcrc_intl <= 1'b0;        
    end else if (rcvd_bt_cnt == 14'd45)begin
        pcrc_enable <= 1'b0;
    end else if (rcvd_bt_cnt == (14'd98 + rcvd_dlc * 8 + 51))begin
        rx_pcrc_intl <= 1'b1;
    end  
end

always @ (posedge clk or posedge g_rst) begin
    if (g_rst) begin
        fcrc_enable <= 1'b0;
        rx_fcrc_intl <= 1'b1;        
    end else if (rcvd_bt_cnt == 14'd0) begin
        fcrc_enable <= 1'b0;
        rx_fcrc_intl <= 1'b1;
    end else if (rcvd_bt_cnt == 14'd2) begin
        fcrc_enable <= 1'b1;
        rx_fcrc_intl <= 1'b0;        
    end else if (sec == 0 && rcvd_bt_cnt == (14'd98 + rcvd_dlc * 8)) begin
        fcrc_enable <= 1'b0;
    end else if (sec == 1 && rcvd_bt_cnt == (14'd98 + (rcvd_dlc - 16) * 8)) begin
        fcrc_enable <= 1'b0;
    end else if (rcvd_bt_cnt == (14'd98 + rcvd_dlc * 8 + 51)) begin
        rx_fcrc_intl <= 1'b1;
    end  
end


always @(posedge clk or posedge g_rst) begin
    if (g_rst) begin
        rcvd_data <= 128'd0; 
    end else if (enable1) begin
        rcvd_data <= rcvd_data_frm[255:128]; 
    end
end
endmodule
         


