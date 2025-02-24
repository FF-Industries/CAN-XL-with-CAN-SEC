module AddRoundKey(
    input clk, g_rst, enable,
    input [127:0] data_in, Key_in,
    output reg [127:0] data_rounded,
    output reg done
);
    wire [127:0] Data_round;

    assign Data_round = data_in ^ Key_in;

    always @(posedge clk or posedge g_rst) begin
        if (g_rst) begin
            data_rounded <= 0;
            done <= 0;
        end else if (enable) begin
            data_rounded <= Data_round;
            done <= 1;
        end else begin
            done <= 0;
        end
    end
endmodule
