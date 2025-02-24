module Shift_Row(
    input clk, g_rst,
    input enable,
    input wire [127:0] data_in,
    output reg [127:0] data_Shifted,
    output reg done
);

    wire [127:0] shifted_rows;

    // Shift row transformation logic
    assign shifted_rows[127:96] = {data_in[127:120], data_in[87:80], data_in[47:40], data_in[7:0]};
    assign shifted_rows[95:64]  = {data_in[95:88], data_in[55:48], data_in[15:8], data_in[103:96]};
    assign shifted_rows[63:32]  = {data_in[63:56], data_in[23:16], data_in[111:104], data_in[71:64]};
    assign shifted_rows[31:0]   = {data_in[31:24], data_in[119:112], data_in[79:72], data_in[39:32]};

    always @(posedge clk or posedge g_rst) begin
        if (g_rst) begin
            data_Shifted <= 0;
            done <= 0;
        end else if (enable) begin
            data_Shifted <= shifted_rows;
            done <= 1;
        end else begin
            done <= 0;
        end
    end
endmodule
