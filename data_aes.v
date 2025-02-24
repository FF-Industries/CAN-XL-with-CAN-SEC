module d_aes (
    input clk,
    input g_rst,
    input tx_success,
    input [10:0] dlc,
    input tx_sec,
    input [16532:0] dt_rm_frm,
    input [14:0] dt_rm_frm_len,
    input [127:0] dataout,
    input [127:0] dataout_combined,
    input done,
    input done_combined,
    input bit_stf_intl,
    output reg [16532:0] dt_rm_frm1,
    output reg [14:0] dt_rm_frm_len1,
    output reg bit_stf_intl_1 
);

reg [127:0] temp_dataout; 
reg done_data;
reg [10:0] new_dlc; 


always @ (posedge clk or posedge g_rst) begin
    if (g_rst) begin
        new_dlc <= 11'd0; 
    end else if (tx_sec == 1'b1) begin
        new_dlc <= dlc + 11'd16;
    end else if (tx_success) begin
        new_dlc <= 11'd0; 
    end
end


always @ (posedge clk or posedge g_rst) begin
    if (g_rst) begin
        temp_dataout <= 128'd0;
        done_data <= 1'b0; 
    end else if (tx_success) begin
        temp_dataout <= 128'd0;
        done_data <= 1'b0;
    end else if (done) begin
        temp_dataout <= dataout;        
    end
end


always @ (posedge clk or posedge g_rst) begin
    if (g_rst) begin
        dt_rm_frm1 <= 16533'd0;
        dt_rm_frm_len1 <= 15'd0;
        bit_stf_intl_1 <= 1'b0; 
    end else if (tx_sec == 1'b1) begin
        if (done_combined == 1'b1) begin
            bit_stf_intl_1 <= 1'b1;                
            dt_rm_frm1 <= {1'b0,dt_rm_frm[16531:16503],new_dlc,dt_rm_frm[16491:16380],temp_dataout, dataout_combined, dt_rm_frm[16251:16200],16072'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff};
            dt_rm_frm_len1 <= dt_rm_frm_len + 15'd128; 
            done_data <= 1'b1;
        end else begin
            dt_rm_frm1 <= 16533'd0;
            dt_rm_frm_len1 <= 15'd0;
            bit_stf_intl_1 <= 1'b0; 
        end
    end else begin
        bit_stf_intl_1 <= bit_stf_intl; 
        dt_rm_frm1 <= dt_rm_frm;
        dt_rm_frm_len1 <= dt_rm_frm_len;
    end
end


always @ (posedge clk or posedge g_rst) begin
    if (g_rst) begin
        bit_stf_intl_1 <= 1'b0;
    end else if (done_data == 1'b1) begin
        bit_stf_intl_1 <= 1'b0; 
    end
end

endmodule











