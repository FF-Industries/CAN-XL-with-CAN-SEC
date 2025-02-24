module dt_rm_frame_gen (clk, g_rst, frame_gen_intl, tx_success, 
tx_buff_1, tx_buff_2, tx_buff_3, tx_buff_4, tx_buff_5, tx_buff_6, 
tx_buff_7, tx_buff_8, tx_buff_9, tx_buff_10, tx_buff_11, tx_buff_12, tx_buff_13, tx_buff_14, tx_buff_15, tx_buff_16, tx_buff_17, tx_buff_18, tx_buff_19, tx_buff_20, tx_buff_21, tx_buff_22, tx_buff_23, tx_buff_24, tx_buff_25, tx_buff_26, tx_buff_27, tx_buff_28, tx_buff_29, tx_buff_30, tx_buff_31, tx_buff_32, tx_buff_33, tx_buff_34, tx_buff_35, tx_buff_36, tx_buff_37, tx_buff_38, tx_buff_39, tx_buff_40, tx_buff_41, tx_buff_42, tx_buff_43, tx_buff_44, tx_buff_45, tx_buff_46, tx_buff_47, tx_buff_48, tx_buff_49, tx_buff_50, tx_buff_51, tx_buff_52, tx_buff_53, tx_buff_54, tx_buff_55, tx_buff_56, tx_buff_57, tx_buff_58, tx_buff_59, tx_buff_60, tx_buff_61, tx_buff_62, tx_buff_63, tx_buff_64, tx_buff_65,
dlc, tx_fcrc_frm_cmp, tx_pcrc_frm_cmp, tx_pcrc_frm, tx_fcrc_frm, par_ser_data,par_ser_data1, par_ser_intl,par_ser_intl1, dt_rm_frm, bit_stf_intl, 
dt_rm_frm_len,datain,enable,datain1,tx_sec); 

input clk;
input g_rst;
input tx_success;
input frame_gen_intl;
input [10:0] dlc;
input [255:0] tx_buff_1;
input [255:0] tx_buff_2;
input [255:0] tx_buff_3;
input [255:0] tx_buff_4;
input [255:0] tx_buff_5;
input [255:0] tx_buff_6;
input [255:0] tx_buff_7;
input [255:0] tx_buff_8;
input [255:0] tx_buff_9;
input [255:0] tx_buff_10;
input [255:0] tx_buff_11;
input [255:0] tx_buff_12;
input [255:0] tx_buff_13;
input [255:0] tx_buff_14;
input [255:0] tx_buff_15;
input [255:0] tx_buff_16;
input [255:0] tx_buff_17;
input [255:0] tx_buff_18;
input [255:0] tx_buff_19;
input [255:0] tx_buff_20;
input [255:0] tx_buff_21;
input [255:0] tx_buff_22;
input [255:0] tx_buff_23;
input [255:0] tx_buff_24;
input [255:0] tx_buff_25;
input [255:0] tx_buff_26;
input [255:0] tx_buff_27;
input [255:0] tx_buff_28;
input [255:0] tx_buff_29;
input [255:0] tx_buff_30;
input [255:0] tx_buff_31;
input [255:0] tx_buff_32;
input [255:0] tx_buff_33;
input [255:0] tx_buff_34;
input [255:0] tx_buff_35;
input [255:0] tx_buff_36;
input [255:0] tx_buff_37;
input [255:0] tx_buff_38;
input [255:0] tx_buff_39;
input [255:0] tx_buff_40;
input [255:0] tx_buff_41;
input [255:0] tx_buff_42;
input [255:0] tx_buff_43;
input [255:0] tx_buff_44;
input [255:0] tx_buff_45;
input [255:0] tx_buff_46;
input [255:0] tx_buff_47;
input [255:0] tx_buff_48;
input [255:0] tx_buff_49;
input [255:0] tx_buff_50;
input [255:0] tx_buff_51;
input [255:0] tx_buff_52;
input [255:0] tx_buff_53;
input [255:0] tx_buff_54;
input [255:0] tx_buff_55;
input [255:0] tx_buff_56;
input [255:0] tx_buff_57;
input [255:0] tx_buff_58;
input [255:0] tx_buff_59;
input [255:0] tx_buff_60;
input [255:0] tx_buff_61;
input [255:0] tx_buff_62;
input [255:0] tx_buff_63;
input [255:0] tx_buff_64;
input [255:0] tx_buff_65;
input tx_pcrc_frm_cmp; 
input tx_fcrc_frm_cmp; 
input [12:0] tx_pcrc_frm;
input [31:0] tx_fcrc_frm;
input tx_sec;

output [43:0] par_ser_data;
output [16480:0] par_ser_data1;
output  [127:0] datain;
output  [127:0] datain1;
output enable;
output par_ser_intl; 
output par_ser_intl1;
output [16532:0] dt_rm_frm; 
output bit_stf_intl; 
output [14:0] dt_rm_frm_len;  

reg [43:0] par_ser_data; 
reg [16480:0] par_ser_data1; 
reg [127:0] datain;
reg [127:0] datain1;
reg par_ser_intl; 
reg par_ser_intl1; 
reg enable;
reg enable_signal;
reg [16532:0] dt_rm_frm; 
reg bit_stf_intl;
reg [14:0] dt_rm_frm_len;
reg [2:0] state;
reg [10:0] new_dlc;

parameter [2:0] 
    idle = 3'd0, 
    dt_frm = 3'd1,
    dt_frm_1 = 3'd2, 
    par_ser = 3'd3, 
    app_msg = 3'd4,
    frm_cmp = 3'd5; 

// block to determine next state
always @ (posedge clk or posedge g_rst) 
    begin
        if (g_rst) 
            state <= idle;
        else 
            begin
                case (state)
                    idle:
                        begin
                            if (frame_gen_intl)
                                begin
                                    state <= dt_frm; 
                                end
                            else
                                begin
                                    state <= idle;
                                end
                        end

                    dt_frm:
                        begin
                        if (tx_pcrc_frm_cmp)begin
                        state <= dt_frm_1; 
                        end else begin
                        state <= dt_frm; 
                        end
                        end
                        
                    dt_frm_1:
                        begin
                        state <= par_ser; 
                        end 
                        
                    par_ser: begin
                        if (tx_fcrc_frm_cmp) 
                              begin 
                                 state <= app_msg; 
                              end  
                           else begin 
                              state <= par_ser;  
                            end  
                        end    
                    app_msg:
                        begin 
                            state <= frm_cmp; 
                        end

                    frm_cmp:
                        begin 
                            if (tx_success) 
                                begin 
                                    state <= idle; 
                                end
                            else 
                                begin 
                                    state <= frm_cmp; 
                                end 
                        end

                    default: 
                        begin 
                            state <= idle; 
                        end
                endcase
            end
    end
	
// block to determne output 
always @ (posedge clk or posedge g_rst) 
	begin 
		if (g_rst) 
			begin
				par_ser_intl <= 1'b0;
				par_ser_intl1 <= 1'b0;  
				par_ser_data <= 44'd0;
				par_ser_data1 <= 16481'd0;  
				dt_rm_frm <= 16533'd0; 
				dt_rm_frm_len <= 15'd0; 
				bit_stf_intl <= 1'b0;
				datain <= 128'b0;
				datain1 <= 128'b0;
				enable <= 1'b0; 
				enable_signal <= 1'b0;
				new_dlc <= 11'b0;
				
			end
		else
			begin
				case(state) 
					idle:
						begin 
							par_ser_intl <= 1'b0;
							par_ser_intl1 <= 1'b0;  
							par_ser_data <= 44'd0;
							par_ser_data1 <= 16481'd0; 
							dt_rm_frm <= 16533'd0; 
							dt_rm_frm_len <= 15'd0; 
							bit_stf_intl <= 1'b0;
							datain <= 128'b0;
							datain1 <= 128'b0;
							enable <= 1'b0;
							new_dlc <= 11'b0;
						end
					dt_frm:
						begin 
						if(tx_sec)begin
							case(dlc)
                                11'b00000001000:
									begin
									    
										par_ser_data <= {1'b0,tx_buff_1[255:227] , dlc + 11'd16 , tx_buff_1[215:213]};
										par_ser_intl <= 1'b1;
										
									end

								11'b00000010111:
									begin
									    
										par_ser_data <= {1'b0,tx_buff_1[255:227] , dlc + 11'd16 , tx_buff_1[215:213]};
										par_ser_intl <= 1'b1;
										
									end									
								endcase
						end else begin
						case(dlc)
                                11'b00000001000:
									begin
										par_ser_data <= {1'b0,tx_buff_1[255:213]};
										par_ser_intl <= 1'b1;
										
									end

								11'b00000010111:
									begin
										par_ser_data <= {1'b0,tx_buff_1[255:213]};
										par_ser_intl <= 1'b1;
										
									end									
								endcase
						end
						end				
							
					dt_frm_1:
						begin 
						if(tx_sec)begin
							case(dlc)
                                11'b00000001000:
									begin
									    new_dlc <= dlc + 11'd16;
										par_ser_data1 <= {1'b0,tx_buff_1[255:227] , dlc + 11'd16 , tx_buff_1[215:213], tx_pcrc_frm, tx_buff_1[199:96], 16320'd0 };
										par_ser_intl1 <= 1'b1;
										
									end

								11'b00000010111:
									begin
									    new_dlc <= dlc + 11'd16;
										par_ser_data1 <= {1'b0,tx_buff_1[255:227] , dlc + 11'd16 , tx_buff_1[215:213], tx_pcrc_frm, tx_buff_1[199:0],tx_buff_2[255:232], 16200'd0 };
										par_ser_intl1 <= 1'b1;
										
									end									
								endcase
						end else begin
						case(dlc)
                                11'b00000001000:
									begin
										par_ser_data1 <= {1'b0,tx_buff_1[255:213], tx_pcrc_frm, tx_buff_1[199:96], 16320'd0 };
										par_ser_intl1 <= 1'b1;
										
									end

								11'b00000010111:
									begin
										par_ser_data1 <= {1'b0,tx_buff_1[255:213], tx_pcrc_frm, tx_buff_1[199:0],tx_buff_2[255:232], 16200'd0 };
										par_ser_intl1 <= 1'b1;
										
									end									
								endcase
						end
						end				
								
					par_ser:
						begin 
							 par_ser_data <= par_ser_data;
							 par_ser_data1 <= par_ser_data1;
							 par_ser_intl <= 1'b0;
							 par_ser_intl1 <= 1'b0; 
						end 			
				    app_msg:
                        begin 
                             bit_stf_intl <= 1'b1; 
                        case(dlc) 
									11'b00000010111:
										begin
											dt_rm_frm <= {1'b0,tx_buff_1[255:213], tx_pcrc_frm, tx_buff_1[199:0],tx_buff_2[255:232], tx_fcrc_frm, tx_buff_2[199:180], 16200'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff};
											dt_rm_frm_len <= 15'd333;
										end	
									11'b00000001000:
										begin
                                            dt_rm_frm <= {1'b0,tx_buff_1[255:213], tx_pcrc_frm, tx_buff_1[199:96], tx_fcrc_frm  , tx_buff_1[63:44] , 16320'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff};
											dt_rm_frm_len <= 15'd213;
										end	
                            default:
                                begin 
                                    dt_rm_frm <= 16533'd0; 
                                    dt_rm_frm_len <= 15'd0; 
                                    datain <= 128'b0;
                                    datain1 <= 128'b0;
                                end 
                        endcase
                    end

					frm_cmp:
						begin 
							bit_stf_intl <= 1'b0; 
							datain <= dt_rm_frm[16380:16252];
							datain1 <= {dt_rm_frm[16436:16379],71'h0};
							enable_signal <= dt_rm_frm[16504];
							if(enable_signal == 1'b1)
							   enable <= 1'b1;
							else
							   enable <= 1'b0;   
						end 		
					
					default: 
					begin 
							par_ser_intl <= 1'b0; 
							par_ser_intl1 <= 1'b1;
							par_ser_data <= 44'd0; 
							par_ser_data1 <= 16481'd0; 
							dt_rm_frm <= 16533'd0; 
							dt_rm_frm_len <= 15'd0; 
							datain <= 128'b0;
							datain1 <= 128'b0;
							
					end
				endcase
			end
	end

endmodule 	
