module rx_buff (clk, g_rst, acpt_sts, rd_en, rcvd_prio_id,
rcvd_dlc, rcvd_data_frm,rcvd_rrs, ide, fdf, xlf, resXL, sdt, vcid,sec, buff_rdy, rx_buff_0_wrtn, rx_buff_1_wrtn, 
data_out);

input clk; 
input g_rst; 
input acpt_sts; 
input rd_en; 
input [10:0] rcvd_prio_id;  
input [10:0] rcvd_dlc; 
input [16383:0] rcvd_data_frm;
input rcvd_rrs; 
input ide;
input fdf;
input xlf;
input resXL;
input [7:0] sdt;
input [7:0] vcid;
input sec;

output [255:0] data_out; 
output buff_rdy; 
output rx_buff_0_wrtn; 
output rx_buff_1_wrtn;

reg [255:0] data_out; 
reg rd_en_in; 
reg read_en; 
reg [255:0] rx_buff0 [0:64]; 
reg [255:0] rx_buff1 [0:64]; 
reg [7:0] read_count; 

reg rx_buff_0_wrtn; 
reg rx_buff_1_wrtn; 
reg rx_buff_0_read; 
reg rx_buff_1_read; 
reg rx_buff_0_wr_stat; 
reg rx_buff_1_wr_stat; 
reg rx_buff_0_active; 
reg rx_buff_1_active; 
reg buff_rdy; 

//block to synchronize rd_en signal 
always @ (posedge clk or posedge g_rst) 
	begin 
		 if (g_rst) 
			rd_en_in <= 1'b1; 
		 else if (~rd_en) 
			rd_en_in <= 1'b0; 
		 else 
			rd_en_in <= 1'b1; 
	end 

always @ (posedge clk or posedge g_rst) 
	begin 
		if (g_rst)
			read_en <= 1'b1; 
		else if (~rd_en_in) 
			 read_en <= 1'b0; 
		else 
			 read_en <= 1'b1; 
	end

// block to indicate buffers are ready 
always @ (posedge clk or posedge g_rst) 
	 begin 
		 if (g_rst) 
			buff_rdy <= 1'b0; 
		 else if (rx_buff_0_wrtn || rx_buff_1_wrtn) 
			buff_rdy <= 1'b1; 
		 else 
			buff_rdy <= 1'b0; 
	 end 	

// block to load receive buffers with accepted message 
always @(posedge clk or posedge g_rst) 
	 begin 
		 if(g_rst) 
			begin 
				rx_buff_0_wr_stat <= 1'b1; 
				rx_buff_0_wrtn <= 1'b0; 
				rx_buff0[0] <= 256'd0; 
				rx_buff0[1] <= 256'd0; 
				rx_buff0[2] <= 256'd0; 
				rx_buff0[3] <= 256'd0; 
				rx_buff0[4] <= 256'd0; 
				rx_buff0[5] <= 256'd0; 
				rx_buff0[6] <= 256'd0; 
				rx_buff0[7] <= 256'd0; 
				rx_buff0[8] <= 256'd0; 
				rx_buff0[9] <= 256'd0;
				rx_buff0[10] <= 256'd0; 
				rx_buff0[11] <= 256'd0; 
				rx_buff0[12] <= 256'd0; 
				rx_buff0[13] <= 256'd0; 
				rx_buff0[14] <= 256'd0; 
				rx_buff0[15] <= 256'd0; 
				rx_buff0[16] <= 256'd0; 
				rx_buff0[17] <= 256'd0; 
				rx_buff0[18] <= 256'd0; 
				rx_buff0[19] <= 256'd0; 
				rx_buff0[20] <= 256'd0; 
				rx_buff0[21] <= 256'd0; 
				rx_buff0[22] <= 256'd0; 
				rx_buff0[23] <= 256'd0; 
				rx_buff0[24] <= 256'd0; 
				rx_buff0[25] <= 256'd0; 
				rx_buff0[26] <= 256'd0; 
				rx_buff0[27] <= 256'd0; 
				rx_buff0[28] <= 256'd0; 
				rx_buff0[29] <= 256'd0; 
				rx_buff0[30] <= 256'd0; 
				rx_buff0[31] <= 256'd0; 
				rx_buff0[32] <= 256'd0; 
				rx_buff0[33] <= 256'd0; 
				rx_buff0[34] <= 256'd0; 
				rx_buff0[35] <= 256'd0; 
				rx_buff0[36] <= 256'd0; 
				rx_buff0[37] <= 256'd0; 
				rx_buff0[38] <= 256'd0; 
				rx_buff0[39] <= 256'd0; 
				rx_buff0[40] <= 256'd0; 
				rx_buff0[41] <= 256'd0; 
				rx_buff0[42] <= 256'd0; 
				rx_buff0[43] <= 256'd0; 
				rx_buff0[44] <= 256'd0; 
				rx_buff0[45] <= 256'd0; 
				rx_buff0[46] <= 256'd0; 
				rx_buff0[47] <= 256'd0; 
				rx_buff0[48] <= 256'd0; 
				rx_buff0[49] <= 256'd0; 
				rx_buff0[50] <= 256'd0; 
				rx_buff0[51] <= 256'd0; 
				rx_buff0[52] <= 256'd0; 
				rx_buff0[53] <= 256'd0; 
				rx_buff0[54] <= 256'd0; 
				rx_buff0[55] <= 256'd0; 
				rx_buff0[56] <= 256'd0; 
				rx_buff0[57] <= 256'd0; 
				rx_buff0[58] <= 256'd0; 
				rx_buff0[59] <= 256'd0; 
				rx_buff0[60] <= 256'd0; 
				rx_buff0[61] <= 256'd0; 
				rx_buff0[62] <= 256'd0; 
				rx_buff0[63] <= 256'd0; 
				rx_buff0[64] <= 256'd0;
				 
				rx_buff_1_wr_stat <= 1'b1; 
				rx_buff_1_wrtn <= 1'b0; 
				rx_buff1[0]  <= 256'd0; 
				rx_buff1[1]  <= 256'd0; 
				rx_buff1[2]  <= 256'd0; 
				rx_buff1[3]  <= 256'd0; 
				rx_buff1[4]  <= 256'd0; 
				rx_buff1[5]  <= 256'd0; 
				rx_buff1[6]  <= 256'd0; 
				rx_buff1[7]  <= 256'd0; 
				rx_buff1[8]  <= 256'd0; 
				rx_buff1[9]  <= 256'd0; 
				rx_buff1[10] <= 256'd0; 
				rx_buff1[11] <= 256'd0; 
				rx_buff1[12] <= 256'd0; 
				rx_buff1[13] <= 256'd0; 
				rx_buff1[14] <= 256'd0; 
				rx_buff1[15] <= 256'd0; 
				rx_buff1[16] <= 256'd0; 
				rx_buff1[17] <= 256'd0; 
				rx_buff1[18] <= 256'd0; 
				rx_buff1[19] <= 256'd0; 
				rx_buff1[20] <= 256'd0; 
				rx_buff1[21] <= 256'd0; 
				rx_buff1[22] <= 256'd0; 
				rx_buff1[23] <= 256'd0; 
				rx_buff1[24] <= 256'd0; 
				rx_buff1[25] <= 256'd0; 
				rx_buff1[26] <= 256'd0; 
				rx_buff1[27] <= 256'd0; 
				rx_buff1[28] <= 256'd0; 
				rx_buff1[29] <= 256'd0; 
				rx_buff1[30] <= 256'd0; 
				rx_buff1[31] <= 256'd0; 
				rx_buff1[32] <= 256'd0; 
				rx_buff1[33] <= 256'd0; 
				rx_buff1[34] <= 256'd0; 
				rx_buff1[35] <= 256'd0; 
				rx_buff1[36] <= 256'd0; 
				rx_buff1[37] <= 256'd0; 
				rx_buff1[38] <= 256'd0; 
				rx_buff1[39] <= 256'd0; 
				rx_buff1[40] <= 256'd0; 
				rx_buff1[41] <= 256'd0; 
				rx_buff1[42] <= 256'd0; 
				rx_buff1[43] <= 256'd0; 
				rx_buff1[44] <= 256'd0; 
				rx_buff1[45] <= 256'd0; 
				rx_buff1[46] <= 256'd0; 
				rx_buff1[47] <= 256'd0; 
				rx_buff1[48] <= 256'd0; 
				rx_buff1[49] <= 256'd0; 
				rx_buff1[50] <= 256'd0; 
				rx_buff1[51] <= 256'd0; 
				rx_buff1[52] <= 256'd0; 
				rx_buff1[53] <= 256'd0; 
				rx_buff1[54] <= 256'd0; 
				rx_buff1[55] <= 256'd0; 
				rx_buff1[56] <= 256'd0; 
				rx_buff1[57] <= 256'd0; 
				rx_buff1[58] <= 256'd0; 
				rx_buff1[59] <= 256'd0; 
				rx_buff1[60] <= 256'd0; 
				rx_buff1[61] <= 256'd0; 
				rx_buff1[62] <= 256'd0; 
				rx_buff1[63] <= 256'd0; 
				rx_buff1[64] <= 256'd0;
			end
		else if (rx_buff_0_read) 
			begin 
				rx_buff0[0] <= 256'd0; 
				rx_buff0[1] <= 256'd0; 
				rx_buff0[2] <= 256'd0; 
				rx_buff0[3] <= 256'd0; 
				rx_buff0[4] <= 256'd0; 
				rx_buff0[5] <= 256'd0; 
				rx_buff0[6] <= 256'd0; 
				rx_buff0[7] <= 256'd0; 
				rx_buff0[8] <= 256'd0; 
				rx_buff0[9] <= 256'd0;
				rx_buff0[10] <= 256'd0; 
				rx_buff0[11] <= 256'd0; 
				rx_buff0[12] <= 256'd0; 
				rx_buff0[13] <= 256'd0; 
				rx_buff0[14] <= 256'd0; 
				rx_buff0[15] <= 256'd0; 
				rx_buff0[16] <= 256'd0; 
				rx_buff0[17] <= 256'd0; 
				rx_buff0[18] <= 256'd0; 
				rx_buff0[19] <= 256'd0; 
				rx_buff0[20] <= 256'd0; 
				rx_buff0[21] <= 256'd0; 
				rx_buff0[22] <= 256'd0; 
				rx_buff0[23] <= 256'd0; 
				rx_buff0[24] <= 256'd0; 
				rx_buff0[25] <= 256'd0; 
				rx_buff0[26] <= 256'd0; 
				rx_buff0[27] <= 256'd0; 
				rx_buff0[28] <= 256'd0; 
				rx_buff0[29] <= 256'd0; 
				rx_buff0[30] <= 256'd0; 
				rx_buff0[31] <= 256'd0; 
				rx_buff0[32] <= 256'd0; 
				rx_buff0[33] <= 256'd0; 
				rx_buff0[34] <= 256'd0; 
				rx_buff0[35] <= 256'd0; 
				rx_buff0[36] <= 256'd0; 
				rx_buff0[37] <= 256'd0; 
				rx_buff0[38] <= 256'd0; 
				rx_buff0[39] <= 256'd0; 
				rx_buff0[40] <= 256'd0; 
				rx_buff0[41] <= 256'd0; 
				rx_buff0[42] <= 256'd0; 
				rx_buff0[43] <= 256'd0; 
				rx_buff0[44] <= 256'd0; 
				rx_buff0[45] <= 256'd0; 
				rx_buff0[46] <= 256'd0; 
				rx_buff0[47] <= 256'd0; 
				rx_buff0[48] <= 256'd0; 
				rx_buff0[49] <= 256'd0; 
				rx_buff0[50] <= 256'd0; 
				rx_buff0[51] <= 256'd0; 
				rx_buff0[52] <= 256'd0; 
				rx_buff0[53] <= 256'd0; 
				rx_buff0[54] <= 256'd0; 
				rx_buff0[55] <= 256'd0; 
				rx_buff0[56] <= 256'd0; 
				rx_buff0[57] <= 256'd0; 
				rx_buff0[58] <= 256'd0; 
				rx_buff0[59] <= 256'd0; 
				rx_buff0[60] <= 256'd0; 
				rx_buff0[61] <= 256'd0; 
				rx_buff0[62] <= 256'd0; 
				rx_buff0[63] <= 256'd0; 
				rx_buff0[64] <= 256'd0;
				
				rx_buff_0_wr_stat <= 1'b1; 
				rx_buff_0_wrtn <= 1'b0; 
			end
			
		else if (rx_buff_1_read) 
			begin
				rx_buff1[0]  <= 256'd0; 
				rx_buff1[1]  <= 256'd0; 
				rx_buff1[2]  <= 256'd0; 
				rx_buff1[3]  <= 256'd0; 
				rx_buff1[4]  <= 256'd0; 
				rx_buff1[5]  <= 256'd0; 
				rx_buff1[6]  <= 256'd0; 
				rx_buff1[7]  <= 256'd0; 
				rx_buff1[8]  <= 256'd0; 
				rx_buff1[9]  <= 256'd0; 
				rx_buff1[10] <= 256'd0; 
				rx_buff1[11] <= 256'd0; 
				rx_buff1[12] <= 256'd0; 
				rx_buff1[13] <= 256'd0; 
				rx_buff1[14] <= 256'd0; 
				rx_buff1[15] <= 256'd0; 
				rx_buff1[16] <= 256'd0; 
				rx_buff1[17] <= 256'd0; 
				rx_buff1[18] <= 256'd0; 
				rx_buff1[19] <= 256'd0; 
				rx_buff1[20] <= 256'd0; 
				rx_buff1[21] <= 256'd0; 
				rx_buff1[22] <= 256'd0; 
				rx_buff1[23] <= 256'd0; 
				rx_buff1[24] <= 256'd0; 
				rx_buff1[25] <= 256'd0; 
				rx_buff1[26] <= 256'd0; 
				rx_buff1[27] <= 256'd0; 
				rx_buff1[28] <= 256'd0; 
				rx_buff1[29] <= 256'd0; 
				rx_buff1[30] <= 256'd0; 
				rx_buff1[31] <= 256'd0; 
				rx_buff1[32] <= 256'd0; 
				rx_buff1[33] <= 256'd0; 
				rx_buff1[34] <= 256'd0; 
				rx_buff1[35] <= 256'd0; 
				rx_buff1[36] <= 256'd0; 
				rx_buff1[37] <= 256'd0; 
				rx_buff1[38] <= 256'd0; 
				rx_buff1[39] <= 256'd0; 
				rx_buff1[40] <= 256'd0; 
				rx_buff1[41] <= 256'd0; 
				rx_buff1[42] <= 256'd0; 
				rx_buff1[43] <= 256'd0; 
				rx_buff1[44] <= 256'd0; 
				rx_buff1[45] <= 256'd0; 
				rx_buff1[46] <= 256'd0; 
				rx_buff1[47] <= 256'd0; 
				rx_buff1[48] <= 256'd0; 
				rx_buff1[49] <= 256'd0; 
				rx_buff1[50] <= 256'd0; 
				rx_buff1[51] <= 256'd0; 
				rx_buff1[52] <= 256'd0; 
				rx_buff1[53] <= 256'd0; 
				rx_buff1[54] <= 256'd0; 
				rx_buff1[55] <= 256'd0; 
				rx_buff1[56] <= 256'd0; 
				rx_buff1[57] <= 256'd0; 
				rx_buff1[58] <= 256'd0; 
				rx_buff1[59] <= 256'd0; 
				rx_buff1[60] <= 256'd0; 
				rx_buff1[61] <= 256'd0; 
				rx_buff1[62] <= 256'd0; 
				rx_buff1[63] <= 256'd0; 
				rx_buff1[64] <= 256'd0;
				
				rx_buff_1_wr_stat <= 1'b1; 
				rx_buff_1_wrtn <= 1'b0; 
			end 
		
		else if(acpt_sts) 
			begin 
				if (rx_buff_0_wr_stat) 
					begin
						if (sec)begin
                            rx_buff0[0] <= {rcvd_prio_id, rcvd_rrs, ide, fdf, xlf, resXL, sdt, sec, rcvd_dlc - 11'd16, vcid, 211'b0};
                        end else begin
                            rx_buff0[0] <= {rcvd_prio_id, rcvd_rrs, ide, fdf, xlf, resXL, sdt, sec, rcvd_dlc, vcid, 211'b0};
                        end
                        rx_buff0[1] <= rcvd_data_frm[16383:16128];
						rx_buff0[2] <= rcvd_data_frm[16127:15872];
						rx_buff0[3] <= rcvd_data_frm[15871:15616];
						rx_buff0[4] <= rcvd_data_frm[15615:15360];
						rx_buff0[5] <= rcvd_data_frm[15359:15104];
						rx_buff0[6] <= rcvd_data_frm[15103:14848];
						rx_buff0[7] <= rcvd_data_frm[14847:14592];
						rx_buff0[8] <= rcvd_data_frm[14591:14336];
						rx_buff0[9]  <= rcvd_data_frm[14335:14080];
						rx_buff0[10] <= rcvd_data_frm[14079:13824];
						rx_buff0[11] <= rcvd_data_frm[13823:13568];
						rx_buff0[12] <= rcvd_data_frm[13567:13312];
						rx_buff0[13] <= rcvd_data_frm[13311:13056];
						rx_buff0[14] <= rcvd_data_frm[13055:12800];
						rx_buff0[15] <= rcvd_data_frm[12799:12544];
						rx_buff0[16] <= rcvd_data_frm[12543:12288];
						rx_buff0[17] <= rcvd_data_frm[12287:12032];
						rx_buff0[18] <= rcvd_data_frm[12031:11776];
						rx_buff0[19] <= rcvd_data_frm[11775:11520];
						rx_buff0[20] <= rcvd_data_frm[11519:11264];
						rx_buff0[21] <= rcvd_data_frm[11263:11008];
						rx_buff0[22] <= rcvd_data_frm[11007:10752];
						rx_buff0[23] <= rcvd_data_frm[10751:10496];
						rx_buff0[24] <= rcvd_data_frm[10495:10240];
						rx_buff0[25] <= rcvd_data_frm[10239:9984];
						rx_buff0[26] <= rcvd_data_frm[9983:9728];
						rx_buff0[27] <= rcvd_data_frm[9727:9472];
						rx_buff0[28] <= rcvd_data_frm[9471:9216];
						rx_buff0[29] <= rcvd_data_frm[9215:8960];
						rx_buff0[30] <= rcvd_data_frm[8959:8704];
						rx_buff0[31] <= rcvd_data_frm[8703:8448];
						rx_buff0[32] <= rcvd_data_frm[8447:8192];
						rx_buff0[33] <= rcvd_data_frm[8191:7936];
						rx_buff0[34] <= rcvd_data_frm[7935:7680];
						rx_buff0[35] <= rcvd_data_frm[7679:7424];
						rx_buff0[36] <= rcvd_data_frm[7423:7168];
						rx_buff0[37] <= rcvd_data_frm[7167:6912];
						rx_buff0[38] <= rcvd_data_frm[6911:6656];
						rx_buff0[39] <= rcvd_data_frm[6655:6400];
						rx_buff0[40] <= rcvd_data_frm[6399:6144];
						rx_buff0[41] <= rcvd_data_frm[6143:5888];
						rx_buff0[42] <= rcvd_data_frm[5887:5632];
						rx_buff0[43] <= rcvd_data_frm[5631:5376];
						rx_buff0[44] <= rcvd_data_frm[5375:5120];
						rx_buff0[44] <= rcvd_data_frm[5375:5120];
						rx_buff0[45] <= rcvd_data_frm[5119:4864];
						rx_buff0[46] <= rcvd_data_frm[4863:4608];
						rx_buff0[47] <= rcvd_data_frm[4607:4352];
						rx_buff0[48] <= rcvd_data_frm[4351:4096];
						rx_buff0[49] <= rcvd_data_frm[4095:3840];
						rx_buff0[50] <= rcvd_data_frm[3839:3584];
						rx_buff0[51] <= rcvd_data_frm[3583:3328];
						rx_buff0[52] <= rcvd_data_frm[3327:3072];
						rx_buff0[53] <= rcvd_data_frm[3071:2816];
						rx_buff0[54] <= rcvd_data_frm[2815:2560];
						rx_buff0[55] <= rcvd_data_frm[2559:2304];
						rx_buff0[56] <= rcvd_data_frm[2303:2048];
						rx_buff0[57] <= rcvd_data_frm[2047:1792];
						rx_buff0[58] <= rcvd_data_frm[1791:1536];
						rx_buff0[59] <= rcvd_data_frm[1535:1280];
						rx_buff0[60] <= rcvd_data_frm[1279:1024];
						rx_buff0[61] <= rcvd_data_frm[1023:768];
						rx_buff0[62] <= rcvd_data_frm[767:512];
						rx_buff0[63] <= rcvd_data_frm[511:256];
						rx_buff0[64] <= rcvd_data_frm[255:0];
						rx_buff_0_wrtn <= 1'b1; 
						rx_buff_0_wr_stat <= 1'b0;
					end
				else if (rx_buff_1_wr_stat) 
					begin
						if (sec)begin
                            rx_buff0[0] <= {rcvd_prio_id, rcvd_rrs, ide, fdf, xlf, resXL, sdt, sec, rcvd_dlc - 11'd16, vcid, 211'b0};
                        end else begin
                            rx_buff0[0] <= {rcvd_prio_id, rcvd_rrs, ide, fdf, xlf, resXL, sdt, sec, rcvd_dlc, vcid, 211'b0};
                        end
                        rx_buff1[1] <= rcvd_data_frm[16383:16128];
						rx_buff1[2] <= rcvd_data_frm[16127:15872];
						rx_buff1[3] <= rcvd_data_frm[15871:15616];
						rx_buff1[4] <= rcvd_data_frm[15615:15360];
						rx_buff1[5] <= rcvd_data_frm[15359:15104];
						rx_buff1[6] <= rcvd_data_frm[15103:14848];
						rx_buff1[7] <= rcvd_data_frm[14847:14592];
						rx_buff1[8] <= rcvd_data_frm[14591:14336];
						rx_buff1[9]  <= rcvd_data_frm[14335:14080];
						rx_buff1[10] <= rcvd_data_frm[14079:13824];
						rx_buff1[11] <= rcvd_data_frm[13823:13568];
						rx_buff1[12] <= rcvd_data_frm[13567:13312];
						rx_buff1[13] <= rcvd_data_frm[13311:13056];
						rx_buff1[14] <= rcvd_data_frm[13055:12800];
						rx_buff1[15] <= rcvd_data_frm[12799:12544];
						rx_buff1[16] <= rcvd_data_frm[12543:12288];
						rx_buff1[17] <= rcvd_data_frm[12287:12032];
						rx_buff1[18] <= rcvd_data_frm[12031:11776];
						rx_buff1[19] <= rcvd_data_frm[11775:11520];
						rx_buff1[20] <= rcvd_data_frm[11519:11264];
						rx_buff1[21] <= rcvd_data_frm[11263:11008];
						rx_buff1[22] <= rcvd_data_frm[11007:10752];
						rx_buff1[23] <= rcvd_data_frm[10751:10496];
						rx_buff1[24] <= rcvd_data_frm[10495:10240];
						rx_buff1[25] <= rcvd_data_frm[10239:9984];
						rx_buff1[26] <= rcvd_data_frm[9983:9728];
						rx_buff1[27] <= rcvd_data_frm[9727:9472];
						rx_buff1[28] <= rcvd_data_frm[9471:9216];
						rx_buff1[29] <= rcvd_data_frm[9215:8960];
						rx_buff1[30] <= rcvd_data_frm[8959:8704];
						rx_buff1[31] <= rcvd_data_frm[8703:8448];
						rx_buff1[32] <= rcvd_data_frm[8447:8192];
						rx_buff1[33] <= rcvd_data_frm[8191:7936];
						rx_buff1[34] <= rcvd_data_frm[7935:7680];
						rx_buff1[35] <= rcvd_data_frm[7679:7424];
						rx_buff1[36] <= rcvd_data_frm[7423:7168];
						rx_buff1[37] <= rcvd_data_frm[7167:6912];
						rx_buff1[38] <= rcvd_data_frm[6911:6656];
						rx_buff1[39] <= rcvd_data_frm[6655:6400];
						rx_buff1[40] <= rcvd_data_frm[6399:6144];
						rx_buff1[41] <= rcvd_data_frm[6143:5888];
						rx_buff1[42] <= rcvd_data_frm[5887:5632];
						rx_buff1[43] <= rcvd_data_frm[5631:5376];
						rx_buff1[44] <= rcvd_data_frm[5375:5120];
						rx_buff1[44] <= rcvd_data_frm[5375:5120];
						rx_buff1[45] <= rcvd_data_frm[5119:4864];
						rx_buff1[46] <= rcvd_data_frm[4863:4608];
						rx_buff1[47] <= rcvd_data_frm[4607:4352];
						rx_buff1[48] <= rcvd_data_frm[4351:4096];
						rx_buff1[49] <= rcvd_data_frm[4095:3840];
						rx_buff1[50] <= rcvd_data_frm[3839:3584];
						rx_buff1[51] <= rcvd_data_frm[3583:3328];
						rx_buff1[52] <= rcvd_data_frm[3327:3072];
						rx_buff1[53] <= rcvd_data_frm[3071:2816];
						rx_buff1[54] <= rcvd_data_frm[2815:2560];
						rx_buff1[55] <= rcvd_data_frm[2559:2304];
						rx_buff1[56] <= rcvd_data_frm[2303:2048];
						rx_buff1[57] <= rcvd_data_frm[2047:1792];
						rx_buff1[58] <= rcvd_data_frm[1791:1536];
						rx_buff1[59] <= rcvd_data_frm[1535:1280];
						rx_buff1[60] <= rcvd_data_frm[1279:1024];
						rx_buff1[61] <= rcvd_data_frm[1023:768];
						rx_buff1[62] <= rcvd_data_frm[767:512];
						rx_buff1[63] <= rcvd_data_frm[511:256];
						rx_buff1[64] <= rcvd_data_frm[255:0];
						rx_buff_1_wrtn <= 1'b1; 
						rx_buff_1_wr_stat <= 1'b0;
					end
				
				else 
					begin
						rx_buff_1_wr_stat <= rx_buff_1_wr_stat; 
						rx_buff_1_wrtn <= rx_buff_1_wrtn;
						rx_buff1[0] <= rx_buff1[0]; 
						rx_buff1[1] <= rx_buff1[1]; 
						rx_buff1[2] <= rx_buff1[2]; 
						rx_buff1[3] <= rx_buff1[3]; 
						rx_buff1[4] <= rx_buff1[4]; 
						rx_buff1[5] <= rx_buff1[5]; 
						rx_buff1[6] <= rx_buff1[6]; 
						rx_buff1[7] <= rx_buff1[7]; 
						rx_buff1[8] <= rx_buff1[8];  
						rx_buff1[9] <= rx_buff1[9]; 
						rx_buff1[10] <= rx_buff1[10];
						rx_buff1[11] <= rx_buff1[11];
						rx_buff1[12] <= rx_buff1[12];
						rx_buff1[13] <= rx_buff1[13];
						rx_buff1[14] <= rx_buff1[14];
						rx_buff1[15] <= rx_buff1[15];
						rx_buff1[16] <= rx_buff1[16];
						rx_buff1[17] <= rx_buff1[17];
						rx_buff1[18] <= rx_buff1[18];
						rx_buff1[19] <= rx_buff1[19];
						rx_buff1[20] <= rx_buff1[20];
						rx_buff1[21] <= rx_buff1[21];
						rx_buff1[22] <= rx_buff1[22];
						rx_buff1[23] <= rx_buff1[23];
						rx_buff1[24] <= rx_buff1[24];
						rx_buff1[25] <= rx_buff1[25];
						rx_buff1[26] <= rx_buff1[26];
						rx_buff1[27] <= rx_buff1[27];
						rx_buff1[28] <= rx_buff1[28];
						rx_buff1[29] <= rx_buff1[29];
						rx_buff1[30] <= rx_buff1[30];
						rx_buff1[31] <= rx_buff1[31];
						rx_buff1[32] <= rx_buff1[32];
						rx_buff1[33] <= rx_buff1[33];
						rx_buff1[34] <= rx_buff1[34];
						rx_buff1[35] <= rx_buff1[35];
						rx_buff1[36] <= rx_buff1[36];
						rx_buff1[37] <= rx_buff1[37];
						rx_buff1[38] <= rx_buff1[38];
						rx_buff1[39] <= rx_buff1[39];
						rx_buff1[40] <= rx_buff1[40];
						rx_buff1[41] <= rx_buff1[41];
						rx_buff1[42] <= rx_buff1[42];
						rx_buff1[43] <= rx_buff1[43];
						rx_buff1[44] <= rx_buff1[44];
						rx_buff1[45] <= rx_buff1[45];
						rx_buff1[46] <= rx_buff1[46];
						rx_buff1[47] <= rx_buff1[47];
						rx_buff1[48] <= rx_buff1[48];
						rx_buff1[49] <= rx_buff1[49];
						rx_buff1[50] <= rx_buff1[50];
						rx_buff1[51] <= rx_buff1[51];
						rx_buff1[52] <= rx_buff1[52];
						rx_buff1[53] <= rx_buff1[53];
						rx_buff1[54] <= rx_buff1[54];
						rx_buff1[55] <= rx_buff1[55];
						rx_buff1[56] <= rx_buff1[56];
						rx_buff1[57] <= rx_buff1[57];
						rx_buff1[58] <= rx_buff1[58];
						rx_buff1[59] <= rx_buff1[59];
						rx_buff1[60] <= rx_buff1[60];
						rx_buff1[61] <= rx_buff1[61];
						rx_buff1[62] <= rx_buff1[62];
						rx_buff1[63] <= rx_buff1[63];
						rx_buff1[64] <= rx_buff1[64];
						
						rx_buff_0_wr_stat <= rx_buff_0_wr_stat; 
						rx_buff_0_wrtn <= rx_buff_0_wrtn; 
						
						rx_buff0[0] <= rx_buff0[0]; 
						rx_buff0[1] <= rx_buff0[1]; 
						rx_buff0[2] <= rx_buff0[2]; 
						rx_buff0[3] <= rx_buff0[3]; 
						rx_buff0[4] <= rx_buff0[4]; 
						rx_buff0[5] <= rx_buff0[5]; 
						rx_buff0[6] <= rx_buff0[6]; 
						rx_buff0[7] <= rx_buff0[7]; 
						rx_buff0[8] <= rx_buff0[8];  
						rx_buff0[9] <= rx_buff0[9]; 
						rx_buff0[10] <= rx_buff0[10];
						rx_buff0[11] <= rx_buff0[11];
						rx_buff0[12] <= rx_buff0[12];
						rx_buff0[13] <= rx_buff0[13];
						rx_buff0[14] <= rx_buff0[14];
						rx_buff0[15] <= rx_buff0[15];
						rx_buff0[16] <= rx_buff0[16];
						rx_buff0[17] <= rx_buff0[17];
						rx_buff0[18] <= rx_buff0[18];
						rx_buff0[19] <= rx_buff0[19];
						rx_buff0[20] <= rx_buff0[20];
						rx_buff0[21] <= rx_buff0[21];
						rx_buff0[22] <= rx_buff0[22];
						rx_buff0[23] <= rx_buff0[23];
						rx_buff0[24] <= rx_buff0[24];
						rx_buff0[25] <= rx_buff0[25];
						rx_buff0[26] <= rx_buff0[26];
						rx_buff0[27] <= rx_buff0[27];
						rx_buff0[28] <= rx_buff0[28];
						rx_buff0[29] <= rx_buff0[29];
						rx_buff0[30] <= rx_buff0[30];
						rx_buff0[31] <= rx_buff0[31];
						rx_buff0[32] <= rx_buff0[32];
						rx_buff0[33] <= rx_buff0[33];
						rx_buff0[34] <= rx_buff0[34];
						rx_buff0[35] <= rx_buff0[35];
						rx_buff0[36] <= rx_buff0[36];
						rx_buff0[37] <= rx_buff0[37];
						rx_buff0[38] <= rx_buff0[38];
						rx_buff0[39] <= rx_buff0[39];
						rx_buff0[40] <= rx_buff0[40];
						rx_buff0[41] <= rx_buff0[41];
						rx_buff0[42] <= rx_buff0[42];
						rx_buff0[43] <= rx_buff0[43];
						rx_buff0[44] <= rx_buff0[44];
						rx_buff0[45] <= rx_buff0[45];
						rx_buff0[46] <= rx_buff0[46];
						rx_buff0[47] <= rx_buff0[47];
						rx_buff0[48] <= rx_buff0[48];
						rx_buff0[49] <= rx_buff0[49];
						rx_buff0[50] <= rx_buff0[50];
						rx_buff0[51] <= rx_buff0[51];
						rx_buff0[52] <= rx_buff0[52];
						rx_buff0[53] <= rx_buff0[53];
						rx_buff0[54] <= rx_buff0[54];
						rx_buff0[55] <= rx_buff0[55];
						rx_buff0[56] <= rx_buff0[56];
						rx_buff0[57] <= rx_buff0[57];
						rx_buff0[58] <= rx_buff0[58];
						rx_buff0[59] <= rx_buff0[59];
						rx_buff0[60] <= rx_buff0[60];
						rx_buff0[61] <= rx_buff0[61];
						rx_buff0[62] <= rx_buff0[62];
						rx_buff0[63] <= rx_buff0[63];
						rx_buff0[64] <= rx_buff0[64];
					end
			end
		else 
			begin 
				rx_buff_1_wr_stat <= rx_buff_1_wr_stat; 
				rx_buff_1_wrtn <= rx_buff_1_wrtn; 
				rx_buff1[0] <= rx_buff1[0]; 
				rx_buff1[1] <= rx_buff1[1]; 
				rx_buff1[2] <= rx_buff1[2]; 
				rx_buff1[3] <= rx_buff1[3]; 
				rx_buff1[4] <= rx_buff1[4]; 
				rx_buff1[5] <= rx_buff1[5]; 
				rx_buff1[6] <= rx_buff1[6]; 
				rx_buff1[7] <= rx_buff1[7]; 
				rx_buff1[8] <= rx_buff1[8];  
				rx_buff1[9] <= rx_buff1[9]; 
				rx_buff1[10] <= rx_buff1[10];
				rx_buff1[11] <= rx_buff1[11];
				rx_buff1[12] <= rx_buff1[12];
				rx_buff1[13] <= rx_buff1[13];
				rx_buff1[14] <= rx_buff1[14];
				rx_buff1[15] <= rx_buff1[15];
				rx_buff1[16] <= rx_buff1[16];
				rx_buff1[17] <= rx_buff1[17];
				rx_buff1[18] <= rx_buff1[18];
				rx_buff1[19] <= rx_buff1[19];
				rx_buff1[20] <= rx_buff1[20];
				rx_buff1[21] <= rx_buff1[21];
				rx_buff1[22] <= rx_buff1[22];
				rx_buff1[23] <= rx_buff1[23];
				rx_buff1[24] <= rx_buff1[24];
				rx_buff1[25] <= rx_buff1[25];
				rx_buff1[26] <= rx_buff1[26];
				rx_buff1[27] <= rx_buff1[27];
				rx_buff1[28] <= rx_buff1[28];
				rx_buff1[29] <= rx_buff1[29];
				rx_buff1[30] <= rx_buff1[30];
				rx_buff1[31] <= rx_buff1[31];
				rx_buff1[32] <= rx_buff1[32];
				rx_buff1[33] <= rx_buff1[33];
				rx_buff1[34] <= rx_buff1[34];
				rx_buff1[35] <= rx_buff1[35];
				rx_buff1[36] <= rx_buff1[36];
				rx_buff1[37] <= rx_buff1[37];
				rx_buff1[38] <= rx_buff1[38];
				rx_buff1[39] <= rx_buff1[39];
				rx_buff1[40] <= rx_buff1[40];
				rx_buff1[41] <= rx_buff1[41];
				rx_buff1[42] <= rx_buff1[42];
				rx_buff1[43] <= rx_buff1[43];
				rx_buff1[44] <= rx_buff1[44];
				rx_buff1[45] <= rx_buff1[45];
				rx_buff1[46] <= rx_buff1[46];
				rx_buff1[47] <= rx_buff1[47];						
				rx_buff1[48] <= rx_buff1[48];
				rx_buff1[49] <= rx_buff1[49];
				rx_buff1[50] <= rx_buff1[50];
				rx_buff1[51] <= rx_buff1[51];
				rx_buff1[52] <= rx_buff1[52];
				rx_buff1[53] <= rx_buff1[53];
				rx_buff1[54] <= rx_buff1[54];						
				rx_buff1[55] <= rx_buff1[55];
				rx_buff1[56] <= rx_buff1[56];
				rx_buff1[57] <= rx_buff1[57];
				rx_buff1[58] <= rx_buff1[58];
				rx_buff1[59] <= rx_buff1[59];
				rx_buff1[60] <= rx_buff1[60];
				rx_buff1[61] <= rx_buff1[61];				
				rx_buff1[62] <= rx_buff1[62];
				rx_buff1[63] <= rx_buff1[63];
				rx_buff1[64] <= rx_buff1[64];
					
				rx_buff_0_wr_stat <= rx_buff_0_wr_stat; 
				rx_buff_0_wrtn <= rx_buff_0_wrtn;
				
				rx_buff0[0] <= rx_buff0[0]; 
				rx_buff0[1] <= rx_buff0[1]; 
				rx_buff0[2] <= rx_buff0[2]; 
				rx_buff0[3] <= rx_buff0[3]; 
				rx_buff0[4] <= rx_buff0[4]; 						
				rx_buff0[5] <= rx_buff0[5]; 
				rx_buff0[6] <= rx_buff0[6]; 
				rx_buff0[7] <= rx_buff0[7]; 
				rx_buff0[8] <= rx_buff0[8];  
				rx_buff0[9] <= rx_buff0[9]; 
				rx_buff0[10] <= rx_buff0[10];					
				rx_buff0[11] <= rx_buff0[11];
				rx_buff0[12] <= rx_buff0[12];
				rx_buff0[13] <= rx_buff0[13];
				rx_buff0[14] <= rx_buff0[14];
				rx_buff0[15] <= rx_buff0[15];
				rx_buff0[16] <= rx_buff0[16];
				rx_buff0[17] <= rx_buff0[17];
				rx_buff0[18] <= rx_buff0[18];
				rx_buff0[19] <= rx_buff0[19];				
				rx_buff0[20] <= rx_buff0[20];
				rx_buff0[21] <= rx_buff0[21];
				rx_buff0[22] <= rx_buff0[22];
				rx_buff0[23] <= rx_buff0[23];
				rx_buff0[24] <= rx_buff0[24];
				rx_buff0[25] <= rx_buff0[25];
				rx_buff0[26] <= rx_buff0[26];
				rx_buff0[27] <= rx_buff0[27];
				rx_buff0[28] <= rx_buff0[28];
				rx_buff0[29] <= rx_buff0[29];
				rx_buff0[30] <= rx_buff0[30];
				rx_buff0[31] <= rx_buff0[31];						
				rx_buff0[32] <= rx_buff0[32];
				rx_buff0[33] <= rx_buff0[33];
				rx_buff0[34] <= rx_buff0[34];
				rx_buff0[35] <= rx_buff0[35];							
				rx_buff0[36] <= rx_buff0[36];
				rx_buff0[37] <= rx_buff0[37];
				rx_buff0[38] <= rx_buff0[38];
				rx_buff0[39] <= rx_buff0[39];
				rx_buff0[40] <= rx_buff0[40];
				rx_buff0[41] <= rx_buff0[41];
				rx_buff0[42] <= rx_buff0[42];
				rx_buff0[43] <= rx_buff0[43];
				rx_buff0[44] <= rx_buff0[44];
				rx_buff0[45] <= rx_buff0[45];
				rx_buff0[46] <= rx_buff0[46];
				rx_buff0[47] <= rx_buff0[47];
				rx_buff0[48] <= rx_buff0[48];
				rx_buff0[49] <= rx_buff0[49];
				rx_buff0[50] <= rx_buff0[50];
				rx_buff0[51] <= rx_buff0[51];
				rx_buff0[52] <= rx_buff0[52];
				rx_buff0[53] <= rx_buff0[53];
				rx_buff0[54] <= rx_buff0[54];
				rx_buff0[55] <= rx_buff0[55];
				rx_buff0[56] <= rx_buff0[56];
				rx_buff0[57] <= rx_buff0[57];
				rx_buff0[58] <= rx_buff0[58];
				rx_buff0[59] <= rx_buff0[59];						
				rx_buff0[60] <= rx_buff0[60];
				rx_buff0[61] <= rx_buff0[61];
				rx_buff0[62] <= rx_buff0[62];
				rx_buff0[63] <= rx_buff0[63];						
				rx_buff0[64] <= rx_buff0[64];
			end
	end

// block to read data from receive bufers
always @ (posedge clk or posedge g_rst) 
	begin 
		if (g_rst) 
			begin 
				 data_out <= 256'd0; 
				 rx_buff_0_read <= 1'b0; 
				 rx_buff_1_read <= 1'b0; 
				 rx_buff_0_active <= 1'b0; 
				 rx_buff_1_active <= 1'b0; 
			end 
		else if(read_en) 
			 begin 
				 data_out <= 256'd0; 
				 rx_buff_0_read <= 1'b0; 
				 rx_buff_1_read <= 1'b0; 
				 rx_buff_0_active <= 1'b0; 
				 rx_buff_1_active <= 1'b0; 
			 end 
		else if (~read_en) 
			begin 
				 if (rx_buff_0_wrtn && (~rx_buff_1_active)) 
					 begin 
						 rx_buff_1_read <= 1'b0; 
							case (read_count) 
								7'd0 :
									begin 
										 if (~rx_buff_0_read) 
											 begin 
												 rx_buff_0_read <= 1'b0; 
												 rx_buff_0_active <= 1'b1; 
											 end 
										else 
											begin 
												 rx_buff_0_read <= 1'b0; 
												 rx_buff_0_active <= 1'b0; 
											end 
									end
								
								7'd1 :data_out <= rx_buff0[0]; 
								7'd2 :data_out <= rx_buff0[1]; 
								7'd3 :data_out <= rx_buff0[2]; 
								7'd4 :data_out <= rx_buff0[3]; 
								7'd5 :data_out <= rx_buff0[4]; 
								7'd6 :data_out <= rx_buff0[5]; 
								7'd7 :data_out <= rx_buff0[6]; 
								7'd8 :data_out <= rx_buff0[7]; 
								7'd9 :data_out <= rx_buff0[8]; 
								7'd10 : data_out <= rx_buff0[9];
								7'd11 : data_out <= rx_buff0[10];
								7'd12 : data_out <= rx_buff0[11];
								7'd13 : data_out <= rx_buff0[12];
								7'd14 : data_out <= rx_buff0[13];
								7'd15 : data_out <= rx_buff0[14];
								7'd16 : data_out <= rx_buff0[15];
								7'd17 : data_out <= rx_buff0[16];
								7'd18 : data_out <= rx_buff0[17];
								7'd19 : data_out <= rx_buff0[18];
								7'd20 : data_out <= rx_buff0[19];
								7'd21 : data_out <= rx_buff0[20];
								7'd22 : data_out <= rx_buff0[21];
								7'd23 : data_out <= rx_buff0[22];
								7'd24 : data_out <= rx_buff0[23];
								7'd25 : data_out <= rx_buff0[24];
								7'd26 : data_out <= rx_buff0[25];
								7'd27 : data_out <= rx_buff0[26];
								7'd28 : data_out <= rx_buff0[27];
								7'd29 : data_out <= rx_buff0[28];
								7'd30 : data_out <= rx_buff0[29];
								7'd31 : data_out <= rx_buff0[30];
								7'd32 : data_out <= rx_buff0[31];
								7'd33 : data_out <= rx_buff0[32];
								7'd34 : data_out <= rx_buff0[33];
								7'd35 : data_out <= rx_buff0[34];
								7'd36 : data_out <= rx_buff0[35];
								7'd37 : data_out <= rx_buff0[36];
								7'd38 : data_out <= rx_buff0[37];
								7'd39 : data_out <= rx_buff0[38];
								7'd40 : data_out <= rx_buff0[39];
								7'd41 : data_out <= rx_buff0[40];
								7'd42 : data_out <= rx_buff0[41];
								7'd43 : data_out <= rx_buff0[42];
								7'd44 : data_out <= rx_buff0[43];
								7'd45 : data_out <= rx_buff0[44];
								7'd46 : data_out <= rx_buff0[45];
								7'd47 : data_out <= rx_buff0[46];
								7'd48 : data_out <= rx_buff0[47];
								7'd49 : data_out <= rx_buff0[48];
								7'd50 : data_out <= rx_buff0[49];
								7'd51 : data_out <= rx_buff0[50];
								7'd52 : data_out <= rx_buff0[51];
								7'd53 : data_out <= rx_buff0[52];
								7'd54 : data_out <= rx_buff0[53];
								7'd55 : data_out <= rx_buff0[54];
								7'd56 : data_out <= rx_buff0[55];
								7'd57 : data_out <= rx_buff0[56];
								7'd58 : data_out <= rx_buff0[57];
								7'd59 : data_out <= rx_buff0[58];
								7'd60 : data_out <= rx_buff0[59];
								7'd61 : data_out <= rx_buff0[60];
								7'd62 : data_out <= rx_buff0[61];
								7'd63 : data_out <= rx_buff0[62];
								7'd64 : data_out <= rx_buff0[63]; 
								7'd65 : 
									begin 
										data_out <= rx_buff0[64]; 
										rx_buff_0_read <= 1'b1; 
										rx_buff_0_active <= 1'b0; 
											if (rx_buff_1_wrtn) 
												rx_buff_1_active <= 1'b1; 
											else rx_buff_1_active <= 1'b0; 
									 end 
								default :
									begin 
										 data_out <= 8'd0; 
										 rx_buff_0_read <= 1'b0; 
										 rx_buff_0_active <= 1'b0; 
									end 
							endcase 
					end
					
				else if (rx_buff_1_wrtn && (~rx_buff_0_active))
					begin 
						rx_buff_0_read <= 1'b0; 
						case (read_count) 
							7'd0 :
								begin 
									if (~rx_buff_1_read) 
										begin 
											 rx_buff_1_read <= 1'b0; 
											 rx_buff_1_active <= 1'b1; 
										end 
									else 
										begin 
											 rx_buff_1_read <= 1'b0; 
											 rx_buff_1_active <= 1'b0; 
										end 
								end 
							7'd1 :data_out <= rx_buff1[0]; 
							7'd2 :data_out <= rx_buff1[1]; 
							7'd3 :data_out <= rx_buff1[2]; 
							7'd4 :data_out <= rx_buff1[3]; 
							7'd5 :data_out <= rx_buff1[4]; 
							7'd6 :data_out <= rx_buff1[5]; 
							7'd7 :data_out <= rx_buff1[6]; 
							7'd8 :data_out <= rx_buff1[7]; 
							7'd9 :data_out <= rx_buff1[8]; 
							7'd10 : data_out <= rx_buff1[9];
							7'd11 : data_out <= rx_buff1[10];
							7'd12 : data_out <= rx_buff1[11];
							7'd13 : data_out <= rx_buff1[12];
							7'd14 : data_out <= rx_buff1[13];
							7'd15 : data_out <= rx_buff1[14];
							7'd16 : data_out <= rx_buff1[15];
							7'd17 : data_out <= rx_buff1[16];
							7'd18 : data_out <= rx_buff1[17];
							7'd19 : data_out <= rx_buff1[18];
							7'd20 : data_out <= rx_buff1[19];
							7'd21 : data_out <= rx_buff1[20];
							7'd22 : data_out <= rx_buff1[21];
							7'd23 : data_out <= rx_buff1[22];
							7'd24 : data_out <= rx_buff1[23];
							7'd25 : data_out <= rx_buff1[24];
							7'd26 : data_out <= rx_buff1[25];
							7'd27 : data_out <= rx_buff1[26];
							7'd28 : data_out <= rx_buff1[27];
							7'd29 : data_out <= rx_buff1[28];
							7'd30 : data_out <= rx_buff1[29];
							7'd31 : data_out <= rx_buff1[30];
							7'd32 : data_out <= rx_buff1[31];
							7'd33 : data_out <= rx_buff1[32];
							7'd34 : data_out <= rx_buff1[33];
							7'd35 : data_out <= rx_buff1[34];
							7'd36 : data_out <= rx_buff1[35];
							7'd37 : data_out <= rx_buff1[36];
							7'd38 : data_out <= rx_buff1[37];
							7'd39 : data_out <= rx_buff1[38];
							7'd40 : data_out <= rx_buff1[39];
							7'd41 : data_out <= rx_buff1[40];
							7'd42 : data_out <= rx_buff1[41];
							7'd43 : data_out <= rx_buff1[42];
							7'd44 : data_out <= rx_buff1[43];
							7'd45 : data_out <= rx_buff1[44];
							7'd46 : data_out <= rx_buff1[45];
							7'd47 : data_out <= rx_buff1[46];
							7'd48 : data_out <= rx_buff1[47];
							7'd49 : data_out <= rx_buff1[48];
							7'd50 : data_out <= rx_buff1[49];
							7'd51 : data_out <= rx_buff1[50];
							7'd52 : data_out <= rx_buff1[51];
							7'd53 : data_out <= rx_buff1[52];
							7'd54 : data_out <= rx_buff1[53];
							7'd55 : data_out <= rx_buff1[54];
							7'd56 : data_out <= rx_buff1[55];
							7'd57 : data_out <= rx_buff1[56];
							7'd58 : data_out <= rx_buff1[57];
							7'd59 : data_out <= rx_buff1[58];
							7'd60 : data_out <= rx_buff1[59];
							7'd61 : data_out <= rx_buff1[60];
							7'd62 : data_out <= rx_buff1[61];
							7'd63 : data_out <= rx_buff1[62];
							7'd64 : data_out <= rx_buff1[63]; 
						    7'd65 : 
								begin
									data_out <= rx_buff1[64]; 
									rx_buff_1_read <= 1'b1; 
									rx_buff_1_active <= 1'b0; 
									if (rx_buff_0_wrtn) 
										rx_buff_0_active <= 1'b1; 
									else rx_buff_0_active <= 1'b0; 
								end 
							default:
								begin 
									 data_out <= 8'd0; 
									 rx_buff_1_read <= 1'b0; 
									 rx_buff_1_active <= 1'b0; 
								end 
						endcase
					end
				else
					begin	
						data_out <= 256'd0; 
						rx_buff_0_active <= 1'b0; 
						rx_buff_1_active <= 1'b0; 
						rx_buff_0_read <= 1'b0; 
						rx_buff_1_read <= 1'b0;
					end
			end
		else
			begin
				data_out <= 256'd0; 
				rx_buff_0_active <= 1'b0; 
				rx_buff_1_active <= 1'b0; 
				rx_buff_0_read <= 1'b0; 
				rx_buff_1_read <= 1'b0; 
			end
	end
	
// Block to increment read_count 
always @ (posedge clk or posedge g_rst) 
begin 
    if (g_rst) 
        read_count <= 7'd0;  
    else if ((read_count == 7'd65) || ((~rx_buff_1_wrtn) && (~rx_buff_0_wrtn))) 
        read_count <= 7'd0; 
    else if ((rx_buff_0_active) || (rx_buff_1_active)) 
        read_count<= read_count + 7'd1; 
end 
endmodule