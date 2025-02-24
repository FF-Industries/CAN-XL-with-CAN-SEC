module Security (
    input clk,
    input g_rst,
    input rx_success,
    input rcvd_done_combined,
    input sec,
    input [16383:0] rcvd_data_frm,
    input [127:0] rcvd_dataout_combined,
    input enable1,
    output reg security_err,
    output reg [31:0] fv
);

reg [127:0] icv;
reg [127:0] rcvd_icv;
reg icv_ready;
reg [31:0] old_fv;
reg [31:0] temp;
reg rcvd_fv;

always @ (posedge clk or posedge g_rst) begin
    if (g_rst || rx_success) begin
        icv <= 128'b0;
    end else if (sec && enable1) begin
        icv <= rcvd_data_frm[127:0];
    end
end

always @ (posedge clk or posedge g_rst) begin
    if (g_rst || rx_success) begin
        rcvd_icv <= 128'b0;
        icv_ready <= 1'b0;
    end else if (rcvd_done_combined) begin
        rcvd_icv <= rcvd_dataout_combined;
        icv_ready <= 1'b1;
    end
end

always @ (posedge clk or posedge g_rst) begin
    if (g_rst || rx_success) begin
        security_err <= 1'b0;
    end else if (sec) begin
        if (rcvd_done_combined && icv_ready) begin
            if (icv == rcvd_icv) begin
                security_err <= 1'b0;
            end else begin
                security_err <= 1'b1;
            end
        end
    end else begin
        security_err <= 1'b0;
    end
end

always @ (posedge clk or posedge g_rst) begin
    if (g_rst || rx_success) begin
        fv <= 32'b0;
        rcvd_fv <= 1'b0;
    end else if (sec && enable1) begin
        fv <= rcvd_data_frm[386:256];
        rcvd_fv <= 1'b1;
    end
end

always @ (posedge clk or posedge g_rst) begin
    if (g_rst || rx_success) begin
        old_fv <= 1'b0;
    end else if (rcvd_fv) begin
        if((old_fv < fv) || (old_fv == 32'b0))begin
        security_err <= 1'b0;
        end else
        security_err <= 1'b1;     
    end
end


always @ (posedge clk or posedge g_rst) begin
    if (g_rst) begin
        temp <= 32'b0; 
    end else if (rx_success) begin
        temp <= old_fv + 1'b1; 
    end
end
endmodule
