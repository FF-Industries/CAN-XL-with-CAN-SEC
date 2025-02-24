module bit_stuff_monitor (clk, g_rst, serial_in, arbtr_fld, one_count, zero_count,one_count1, zero_count1, bit_count, stf_err,rcvd_bt_cnt);

input clk;
input g_rst;
input serial_in;
input arbtr_fld;
input [2:0] one_count;
input [2:0] zero_count;
input [2:0] one_count1;
input [2:0] zero_count1;  
input [4:0] bit_count;
input [14:0] rcvd_bt_cnt;

output stf_err;

reg stf_err;

always @(posedge clk or posedge g_rst) begin
    if (g_rst) begin
        stf_err <= 1'b0;
    end else if (arbtr_fld) begin
        stf_err <= 1'b0;
     end else if ((one_count == 3'd5) && (rcvd_bt_cnt <= 5'd14)) begin
        if (serial_in) begin
            stf_err <= 1'b1;
        end else begin
            stf_err <= 1'b0;
        end
    end else if ((zero_count == 3'd5) && (rcvd_bt_cnt <= 5'd14)) begin
        if (~serial_in) begin
            stf_err <= 1'b1;
        end else begin
            stf_err <= 1'b0;
        end
    end else if (bit_count == 5'd15) begin
        if (one_count1 > 0) begin
            if (~serial_in) begin
                stf_err <= 1'b1; 
            end else begin
                stf_err <= 1'b0;
            end
        end else if (zero_count1 > 0) begin
            if (serial_in) begin
                stf_err <= 1'b1;
            end else begin
                stf_err <= 1'b0;
            end
        end else begin
            stf_err <= 1'b0;
        end
    end else begin
        stf_err <= 1'b0;
    end
end
endmodule
