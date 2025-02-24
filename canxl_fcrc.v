module canxl_fcrc (clk, g_rst, data, fcrc_enable, initialize, tx_success,
rx_success, fcrc_frm);
input clk;
input g_rst;
input data;
input fcrc_enable;
input initialize;
input tx_success;
input rx_success;
output [31:0] fcrc_frm;
reg [31:0] fcrc_frm;
wire fcrc_next;
wire [31:0] fcrc_tmp;
assign fcrc_next = data ^ fcrc_frm[31];
assign fcrc_tmp = {fcrc_frm[30:0], 1'b0};

always @ (posedge clk or posedge g_rst)
begin
 if(g_rst)
 fcrc_frm <= 32'h0;
 else if (tx_success || rx_success)
 fcrc_frm <= 32'h0;
 else if (initialize)
 fcrc_frm <= 32'h0;
  else if (fcrc_enable)
 begin
   if (fcrc_next)
 fcrc_frm <= fcrc_tmp ^ 32'hFA567D89;
 else
 begin
 fcrc_frm <= fcrc_tmp;
 end
 end
end
endmodule 