module MixColumns(
    input clk,
    input g_rst,
    input [127:0] data_in,
    input enable,
    output reg [127:0] data_mixed,
    output reg done
);

    wire [127:0] Mixed_columns;

    // Column-wise mixing logic using Galois field multiplication by 2 and 3
    // First column
    wire [7:0] d0 = data_in[127:120];
    wire [7:0] d1 = data_in[119:112];
    wire [7:0] d2 = data_in[111:104];
    wire [7:0] d3 = data_in[103:96];

    wire [7:0] mult_by_2_d0 = (d0[7] == 1) ? (d0 << 1) ^ 8'h1b : d0 << 1;
    wire [7:0] mult_by_2_d1 = (d1[7] == 1) ? (d1 << 1) ^ 8'h1b : d1 << 1;
    wire [7:0] mult_by_2_d2 = (d2[7] == 1) ? (d2 << 1) ^ 8'h1b : d2 << 1;
    wire [7:0] mult_by_2_d3 = (d3[7] == 1) ? (d3 << 1) ^ 8'h1b : d3 << 1;

    wire [7:0] mult_by_3_d0 = mult_by_2_d0 ^ d0;
    wire [7:0] mult_by_3_d1 = mult_by_2_d1 ^ d1;
    wire [7:0] mult_by_3_d2 = mult_by_2_d2 ^ d2;
    wire [7:0] mult_by_3_d3 = mult_by_2_d3 ^ d3;

    assign Mixed_columns[127:120] = mult_by_2_d0 ^ mult_by_3_d1 ^ d2 ^ d3;
    assign Mixed_columns[119:112] = d0 ^ mult_by_2_d1 ^ mult_by_3_d2 ^ d3;
    assign Mixed_columns[111:104] = d0 ^ d1 ^ mult_by_2_d2 ^ mult_by_3_d3;
    assign Mixed_columns[103:96]  = mult_by_3_d0 ^ d1 ^ d2 ^ mult_by_2_d3;

    // Second column
    wire [7:0] d4 = data_in[95:88];
    wire [7:0] d5 = data_in[87:80];
    wire [7:0] d6 = data_in[79:72];
    wire [7:0] d7 = data_in[71:64];

    wire [7:0] mult_by_2_d4 = (d4[7] == 1) ? (d4 << 1) ^ 8'h1b : d4 << 1;
    wire [7:0] mult_by_2_d5 = (d5[7] == 1) ? (d5 << 1) ^ 8'h1b : d5 << 1;
    wire [7:0] mult_by_2_d6 = (d6[7] == 1) ? (d6 << 1) ^ 8'h1b : d6 << 1;
    wire [7:0] mult_by_2_d7 = (d7[7] == 1) ? (d7 << 1) ^ 8'h1b : d7 << 1;

    wire [7:0] mult_by_3_d4 = mult_by_2_d4 ^ d4;
    wire [7:0] mult_by_3_d5 = mult_by_2_d5 ^ d5;
    wire [7:0] mult_by_3_d6 = mult_by_2_d6 ^ d6;
    wire [7:0] mult_by_3_d7 = mult_by_2_d7 ^ d7;

    assign Mixed_columns[95:88]  = mult_by_2_d4 ^ mult_by_3_d5 ^ d6 ^ d7;
    assign Mixed_columns[87:80]  = d4 ^ mult_by_2_d5 ^ mult_by_3_d6 ^ d7;
    assign Mixed_columns[79:72]  = d4 ^ d5 ^ mult_by_2_d6 ^ mult_by_3_d7;
    assign Mixed_columns[71:64]  = mult_by_3_d4 ^ d5 ^ d6 ^ mult_by_2_d7;

    // Third column
    wire [7:0] d8 = data_in[63:56];
    wire [7:0] d9 = data_in[55:48];
    wire [7:0] d10 = data_in[47:40];
    wire [7:0] d11 = data_in[39:32];

    wire [7:0] mult_by_2_d8 = (d8[7] == 1) ? (d8 << 1) ^ 8'h1b : d8 << 1;
    wire [7:0] mult_by_2_d9 = (d9[7] == 1) ? (d9 << 1) ^ 8'h1b : d9 << 1;
    wire [7:0] mult_by_2_d10 = (d10[7] == 1) ? (d10 << 1) ^ 8'h1b : d10 << 1;
    wire [7:0] mult_by_2_d11 = (d11[7] == 1) ? (d11 << 1) ^ 8'h1b : d11 << 1;

    wire [7:0] mult_by_3_d8 = mult_by_2_d8 ^ d8;
    wire [7:0] mult_by_3_d9 = mult_by_2_d9 ^ d9;
    wire [7:0] mult_by_3_d10 = mult_by_2_d10 ^ d10;
    wire [7:0] mult_by_3_d11 = mult_by_2_d11 ^ d11;

    assign Mixed_columns[63:56]  = mult_by_2_d8 ^ mult_by_3_d9 ^ d10 ^ d11;
    assign Mixed_columns[55:48]  = d8 ^ mult_by_2_d9 ^ mult_by_3_d10 ^ d11;
    assign Mixed_columns[47:40]  = d8 ^ d9 ^ mult_by_2_d10 ^ mult_by_3_d11;
    assign Mixed_columns[39:32]  = mult_by_3_d8 ^ d9 ^ d10 ^ mult_by_2_d11;

    // Fourth column
    wire [7:0] d12 = data_in[31:24];
    wire [7:0] d13 = data_in[23:16];
    wire [7:0] d14 = data_in[15:8];
    wire [7:0] d15 = data_in[7:0];

    wire [7:0] mult_by_2_d12 = (d12[7] == 1) ? (d12 << 1) ^ 8'h1b : d12 << 1;
    wire [7:0] mult_by_2_d13 = (d13[7] == 1) ? (d13 << 1) ^ 8'h1b : d13 << 1;
    wire [7:0] mult_by_2_d14 = (d14[7] == 1) ? (d14 << 1) ^ 8'h1b : d14 << 1;
    wire [7:0] mult_by_2_d15 = (d15[7] == 1) ? (d15 << 1) ^ 8'h1b : d15 << 1;

    wire [7:0] mult_by_3_d12 = mult_by_2_d12 ^ d12;
    wire [7:0] mult_by_3_d13 = mult_by_2_d13 ^ d13;
    wire [7:0] mult_by_3_d14 = mult_by_2_d14 ^ d14;
    wire [7:0] mult_by_3_d15 = mult_by_2_d15 ^ d15;

    assign Mixed_columns[31:24]  = mult_by_2_d12 ^ mult_by_3_d13 ^ d14 ^ d15;
    assign Mixed_columns[23:16]  = d12 ^ mult_by_2_d13 ^ mult_by_3_d14 ^ d15;
    assign Mixed_columns[15:8]   = d12 ^ d13 ^ mult_by_2_d14 ^ mult_by_3_d15;
    assign Mixed_columns[7:0]    = mult_by_3_d12 ^ d13 ^ d14 ^ mult_by_2_d15;

    always @(posedge clk or posedge g_rst) begin
        if (g_rst) begin
            data_mixed <= 0;
            done <= 0;
        end else if (enable) begin
            data_mixed <= Mixed_columns;
            done <= 1;
        end else begin
            done <= 0;
        end
    end
endmodule
