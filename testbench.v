module CAN_XL_tst;
reg osc_clk;
reg g_rst;
reg init_err_st;
wire can_bus_in;
wire can_bus_in_0;
wire can_bus_in_1;
wire can_bus_in_2;
wire can_bus_in_3;
reg param_ld;

reg [255:0] data_in_0, data_in_1, data_in_2, data_in_3;
reg tx_buff_ld_0, tx_buff_ld_1, tx_buff_ld_2, tx_buff_ld_3;
reg rd_en_0, rd_en_1, rd_en_2, rd_en_3;
wire tx_buff_busy_0, tx_buff_busy_1, tx_buff_busy_2, tx_buff_busy_3;
wire can_bus_out_0, can_bus_out_1, can_bus_out_2, can_bus_out_3;
wire buff_rdy_0, buff_rdy_1, buff_rdy_2, buff_rdy_3;
wire [255:0] data_out_0, data_out_1, data_out_2, data_out_3;

assign can_bus_in = (can_bus_out_0 & can_bus_out_1 & can_bus_out_2 &
can_bus_out_3);
assign can_bus_in_0 = can_bus_in;
assign can_bus_in_1 = can_bus_in;
assign can_bus_in_2 = can_bus_in;
assign can_bus_in_3 = can_bus_in;
initial begin
 osc_clk = 1;
 g_rst = 0;
 init_err_st = 0;
 param_ld = 0;

 tx_buff_ld_0 = 0;
 data_in_0 = 0; 
 rd_en_0 = 1;

 tx_buff_ld_1 = 0;
 data_in_1 = 0;
 rd_en_1 = 1;

 tx_buff_ld_2 = 0;
 data_in_2 = 0;
 rd_en_2 = 1;

 tx_buff_ld_3 = 0;
 data_in_3 = 0;
 rd_en_3 = 1;
 #6.25;
end
  always #(6.25) osc_clk = ~osc_clk;
always
 begin
 #6.25;
 g_rst = 1;
 #18.25
 g_rst = 0;
 #1000
 param_ld = 1;

 tx_buff_ld_0 = 1;
 tx_buff_ld_1 = 1;
 tx_buff_ld_2 = 1;	
 tx_buff_ld_3 = 1;
 //1
 #1000
 //10100110111                                                   
 data_in_0 = 256'b 10100110111_0_0_1_1_0_1110_00001111_1_00000010111_000_0000000000000_00000001_0000_0000_0000_0000_0000_0100_0101_0111_0001_1000_0000_0010_0001_1000_0000_0000_0000_0000_0000_0000_0000_0001_0000_0000_0001_0001_0010_0010_0011_0011_0100_0100_0101_0101_0110_0110_0111_0111_1000_1000_1001_1001_1010_1010_1011_1011_1100_1100;
//11110100111
 data_in_1 = 256'b 11110110111_0_0_1_1_0_1110_00000100_0_00000001000_000_0000000000000_00000001_0000_0000_0000_0000_0101_0101_1011_0001_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_00000000000000000000000000000000_1100_1101_0_1_1111111_111_0000000000000_0000000000_0000000000_00000000000;
 //11110110111
 data_in_2 = 256'b 11110010111_0_0_1_1_0_1110_00000100_0_00000001000_000_0000000000000_00000001_0000_0000_0000_0000_0101_0101_1110_0001_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_00000000000000000000000000000000_1100_1101_0_1_1111111_111_0000000000000_0000000000_0000000000_00000000000;
 //11101101111
 data_in_3 = 256'b 10110110111_0_0_1_1_0_1110_00000100_0_00000001000_000_0000000000000_00000001_0000_0000_0000_0000_0101_0101_0111_0001_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_1111_00000000000000000000000000000000_1100_1101_0_1_1111111_111_0000000000000_0000000000_0000000000_00000000000;
 param_ld = 0;
//2

 #1000
 data_in_0 = 256'b 1101_1101_1110_1110_1111_1111_00000000000000000000000000000000_1100_1101_0_1_1111111_111_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000_0000;
 data_in_1 = 256'b 0;
 data_in_2 = 256'b 0;
 data_in_3 = 256'b 0;

//3
 #1000
 data_in_0 = 256'b 0;
 data_in_1 = 256'b 0;
 data_in_2 = 256'b 0;
 data_in_3 = 256'b 0;
 
//4
 #1000
 data_in_0 = 256'b 0;
 data_in_1 = 256'b 0;
 data_in_2 = 256'b 0;
 data_in_3 = 256'b 0;
 
//5
 #1000
 data_in_0 = 256'b 0;
 data_in_1 = 256'b 0;
 data_in_2 = 256'b 0;
 data_in_3 = 256'b 0;
 
//6
 #1000
 data_in_0 = 256'b 0;
 data_in_1 = 256'b 0;
 data_in_2 = 256'b 0;
 data_in_3 = 256'b 0;
 
//7
 #1000
 data_in_0 = 256'b 0;
 data_in_1 = 256'b 0;
 data_in_2 = 256'b 0;
 data_in_3 = 256'b 0;
 
//8
 #1000
 data_in_0 = 256'b 0;
 data_in_1 = 256'b 0;
 data_in_2 = 256'b 0;
 data_in_3 = 256'b 0;
 
//9
 #1000
 data_in_0 = 256'b 0;
 data_in_1 = 256'b 0;
 data_in_2 = 256'b 0;
 data_in_3 = 256'b 0;
 
//10
 #1000
 data_in_0 = 256'b 0;
 data_in_1 = 256'b 0;
 data_in_2 = 256'b 0;
 data_in_3 = 256'b 0;
 
//11
 #1000
 data_in_0 = 256'b 0;
 data_in_1 = 256'b 0;
 data_in_2 = 256'b 0;
 data_in_3 = 256'b 0;

//12
 #1000
 data_in_0 = 256'b 0;
 data_in_1 = 256'b 0;
 data_in_2 = 256'b 0;
 data_in_3 = 256'b 0;
 
//13
 #1000
 data_in_0 = 256'b 0;
 data_in_1 = 256'b 0;
 data_in_2 = 256'b 0;
 data_in_3 = 256'b 0;
 
//14
 #1000
 data_in_0 = 256'b 0;
 data_in_1 = 256'b 0;
 data_in_2 = 256'b 0;
 data_in_3 = 256'b 0;
 
//15 
 #1000
 data_in_0 = 256'b 0;
 data_in_1 = 256'b 0;
 data_in_2 = 256'b 0;
 data_in_3 = 256'b 0;
 
//16
 #1000
 data_in_0 = 256'b 0;
 data_in_1 = 256'b 0;
 data_in_2 = 256'b 0;
 data_in_3 = 256'b 0;
 
//17
 #1000
 data_in_0 = 256'b 0;
 data_in_1 = 256'b 0;
 data_in_2 = 256'b 0;
 data_in_3 = 256'b 0;
 
//18
 #1000
 data_in_0 = 256'b 0;
 data_in_1 = 256'b 0;
 data_in_2 = 256'b 0;
 data_in_3 = 256'b 0;
 
//19
 #1000
 data_in_0 = 256'b 0;
 data_in_1 = 256'b 0;
 data_in_2 = 256'b 0;
 data_in_3 = 256'b 0;
 
//20
 #1000
 data_in_0 = 256'b 0;
 data_in_1 = 256'b 0;
 data_in_2 = 256'b 0;
 data_in_3 = 256'b 0;
 
//21
 #1000
 data_in_0 = 256'b 0;
 data_in_1 = 256'b 0;
 data_in_2 = 256'b 0;
 data_in_3 = 256'b 0;

//22
 #1000
 data_in_0 = 256'b 0;
 data_in_1 = 256'b 0;
 data_in_2 = 256'b 0;
 data_in_3 = 256'b 0;
 
//23
 #1000
 data_in_0 = 256'b 0;
 data_in_1 = 256'b 0;
 data_in_2 = 256'b 0;
 data_in_3 = 256'b 0;
 
//24
 #1000
 data_in_0 = 256'b 0;
 data_in_1 = 256'b 0;
 data_in_2 = 256'b 0;
 data_in_3 = 256'b 0;
 
//25
 #1000
 data_in_0 = 256'b 0;
 data_in_1 = 256'b 0;
 data_in_2 = 256'b 0;
 data_in_3 = 256'b 0;
 
//26
 #1000
 data_in_0 = 256'b 0;
 data_in_1 = 256'b 0;
 data_in_2 = 256'b 0;
 data_in_3 = 256'b 0;
 
//27
 #1000
 data_in_0 = 256'b 0;
 data_in_1 = 256'b 0;
 data_in_2 = 256'b 0;
 data_in_3 = 256'b 0;
 
//28
 #1000
 data_in_0 = 256'b 0;
 data_in_1 = 256'b 0;
 data_in_2 = 256'b 0;
 data_in_3 = 256'b 0;
 
//29
 #1000
 data_in_0 = 256'b 0;
 data_in_1 = 256'b 0;
 data_in_2 = 256'b 0;
 data_in_3 = 256'b 0;
 
//30
 #1000
 data_in_0 = 256'b 0;
 data_in_1 = 256'b 0;
 data_in_2 = 256'b 0;
 data_in_3 = 256'b 0;
 
//31
 #1000
 data_in_0 = 256'b 0;
 data_in_1 = 256'b 0;
 data_in_2 = 256'b 0;
 data_in_3 = 256'b 0;

//32
 #1000
 data_in_0 = 256'b 0;
 data_in_1 = 256'b 0;
 data_in_2 = 256'b 0;
 data_in_3 = 256'b 0;
 
//33
 #1000
 data_in_0 = 256'b 0;
 data_in_1 = 256'b 0;
 data_in_2 = 256'b 0;
 data_in_3 = 256'b 0;
 
//34
 #1000
 data_in_0 = 256'b 0;
 data_in_1 = 256'b 0;
 data_in_2 = 256'b 0;
 data_in_3 = 256'b 0;
 
//35
 #1000
 data_in_0 = 256'b 0;
 data_in_1 = 256'b 0;
 data_in_2 = 256'b 0;
 data_in_3 = 256'b 0;
 
//36
 #1000
 data_in_0 = 256'b 0;
 data_in_1 = 256'b 0;
 data_in_2 = 256'b 0;
 data_in_3 = 256'b 0;
 
//37
 #1000
 data_in_0 = 256'b 0;
 data_in_1 = 256'b 0;
 data_in_2 = 256'b 0;
 data_in_3 = 256'b 0;
 
//38
 #1000
 data_in_0 = 256'b 0;
 data_in_1 = 256'b 0;
 data_in_2 = 256'b 0;
 data_in_3 = 256'b 0;
 
//39
 #1000
 data_in_0 = 256'b 0;
 data_in_1 = 256'b 0;
 data_in_2 = 256'b 0;
 data_in_3 = 256'b 0;
 
//40
 #1000
 data_in_0 = 256'b 0;
 data_in_1 = 256'b 0;
 data_in_2 = 256'b 0;
 data_in_3 = 256'b 0;
 
//41
 #1000
 data_in_0 = 256'b 0;
 data_in_1 = 256'b 0;
 data_in_2 = 256'b 0;
 data_in_3 = 256'b 0;

//42
 #1000
 data_in_0 = 256'b 0;
 data_in_1 = 256'b 0;
 data_in_2 = 256'b 0;
 data_in_3 = 256'b 0;
 
//43
 #1000
 data_in_0 = 256'b 0;
 data_in_1 = 256'b 0;
 data_in_2 = 256'b 0;
 data_in_3 = 256'b 0;
 
//44
 #1000
 data_in_0 = 256'b 0;
 data_in_1 = 256'b 0;
 data_in_2 = 256'b 0;
 data_in_3 = 256'b 0;
 
//45
 #1000
 data_in_0 = 256'b 0;
 data_in_1 = 256'b 0;
 data_in_2 = 256'b 0;
 data_in_3 = 256'b 0;
 
//46
 #1000
 data_in_0 = 256'b 0;
 data_in_1 = 256'b 0;
 data_in_2 = 256'b 0;
 data_in_3 = 256'b 0;
 
//47
 #1000
 data_in_0 = 256'b 0;
 data_in_1 = 256'b 0;
 data_in_2 = 256'b 0;
 data_in_3 = 256'b 0;
 
//48
 #1000
 data_in_0 = 256'b 0;
 data_in_1 = 256'b 0;
 data_in_2 = 256'b 0;
 data_in_3 = 256'b 0;
 
//49
 #1000
 data_in_0 = 256'b 0;
 data_in_1 = 256'b 0;
 data_in_2 = 256'b 0;
 data_in_3 = 256'b 0;
 
//50
 #1000
 data_in_0 = 256'b 0;
 data_in_1 = 256'b 0;
 data_in_2 = 256'b 0;
 data_in_3 = 256'b 0;
 
//51
 #1000
 data_in_0 = 256'b 0;
 data_in_1 = 256'b 0;
 data_in_2 = 256'b 0;
 data_in_3 = 256'b 0;

//52
 #1000
 data_in_0 = 256'b 0;
 data_in_1 = 256'b 0;
 data_in_2 = 256'b 0;
 data_in_3 = 256'b 0;
 
//53
 #1000
 data_in_0 = 256'b 0;
 data_in_1 = 256'b 0;
 data_in_2 = 256'b 0;
 data_in_3 = 256'b 0;
 
//54
 #1000
 data_in_0 = 256'b 0;
 data_in_1 = 256'b 0;
 data_in_2 = 256'b 0;
 data_in_3 = 256'b 0;
 
//55
 #1000
 data_in_0 = 256'b 0;
 data_in_1 = 256'b 0;
 data_in_2 = 256'b 0;
 data_in_3 = 256'b 0;
 
//56
 #1000
 data_in_0 = 256'b 0;
 data_in_1 = 256'b 0;
 data_in_2 = 256'b 0;
 data_in_3 = 256'b 0;
 
//57
 #1000
 data_in_0 = 256'b 0;
 data_in_1 = 256'b 0;
 data_in_2 = 256'b 0;
 data_in_3 = 256'b 0;
 
//58
 #1000
 data_in_0 = 256'b 0;
 data_in_1 = 256'b 0;
 data_in_2 = 256'b 0;
 data_in_3 = 256'b 0;
 
//59
 #1000
 data_in_0 = 256'b 0;
 data_in_1 = 256'b 0;
 data_in_2 = 256'b 0;
 data_in_3 = 256'b 0;

//60
 #1000
 data_in_0 = 256'b 0;
 data_in_1 = 256'b 0;
 data_in_2 = 256'b 0;
 data_in_3 = 256'b 0;
 
//61
  #1000
 data_in_0 = 256'b 0;
 data_in_1 = 256'b 0;
 data_in_2 = 256'b 0;
 data_in_3 = 256'b 0;

//62
 #1000
 data_in_0 = 256'b 0;
 data_in_1 = 256'b 0;
 data_in_2 = 256'b 0;
 data_in_3 = 256'b 0;
 
//63
 #1000
 data_in_0 = 256'b 0;
 data_in_1 = 256'b 0;
 data_in_2 = 256'b 0;
 data_in_3 = 256'b 0;
 
//64
 #1000
 data_in_0 = 256'b 0;
 data_in_1 = 256'b 0;
 data_in_2 = 256'b 0;
 data_in_3 = 256'b 0;
 
//65
 #1000
 data_in_0 = 256'b 0;
  tx_buff_ld_0 = 0;
 data_in_1 = 256'b 0;
  tx_buff_ld_1 = 0;
 data_in_2 = 256'b 0;
  tx_buff_ld_2 = 0;
 data_in_3 = 256'b 0;
  tx_buff_ld_3 = 0;


 #146400
 rd_en_0 = 0;
 rd_en_1 = 0;
 rd_en_2 = 0;
 rd_en_3 = 0; //Comment out to create overload condition
 # 2000000
 $stop;
 end
CAN_XL can_0 (osc_clk, g_rst, init_err_st, can_bus_in_0, param_ld,
data_in_0, tx_buff_ld_0, rd_en_0, tx_buff_busy_0, can_bus_out_0,
buff_rdy_0, data_out_0);
CAN_XL can_1 (osc_clk, g_rst, init_err_st, can_bus_in_1, param_ld,
data_in_1, tx_buff_ld_1, rd_en_1, tx_buff_busy_1, can_bus_out_1,
buff_rdy_1, data_out_1);
CAN_XL can_2 (osc_clk, g_rst, init_err_st, can_bus_in_2, param_ld,
data_in_2, tx_buff_ld_2, rd_en_2, tx_buff_busy_2, can_bus_out_2,
buff_rdy_2, data_out_2);
CAN_XL can_3 (osc_clk, g_rst, init_err_st, can_bus_in_3, param_ld,
data_in_3, tx_buff_ld_3, rd_en_3, tx_buff_busy_3, can_bus_out_3,
buff_rdy_3, data_out_3);
    initial begin
    $dumpvars;
      $dumpfile("CANxl.vcd");
  end
endmodule 