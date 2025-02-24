module rx_pcrc (
    clk, g_rst, data, pcrc_enable, initialize, tx_success,
    rx_success, pcrc_frm, de_stuff
);
    input clk;
    input g_rst;
    input data;
    input pcrc_enable;
    input initialize;
    input tx_success;
    input rx_success;
    input de_stuff;
    output [12:0] pcrc_frm;
    
    reg [12:0] pcrc_frm;
    wire pcrc_next;
    wire [12:0] pcrc_tmp;
    
    assign pcrc_next = data ^ pcrc_frm[12];
    assign pcrc_tmp = {pcrc_frm[11:0], 1'b0};

    always @ (posedge clk or posedge g_rst) begin
        if (g_rst) begin
            pcrc_frm <= 13'h0;
        end else if (tx_success || rx_success) begin
            pcrc_frm <= 13'h0;
        end else if (initialize) begin
            pcrc_frm <= 13'h0;
        end else if (pcrc_enable && !de_stuff) begin
            if (pcrc_next) 
                pcrc_frm <= pcrc_tmp ^ 13'h19E7;
            else
                pcrc_frm <= pcrc_tmp;
        end
    end
endmodule
