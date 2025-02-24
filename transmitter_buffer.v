module tx_buff (clk, g_rst, data_in, tx_buff_ld, tx_success, frame_gen_intl, tx_buff_busy, 
tx_buff_1, tx_buff_2, tx_buff_3, tx_buff_4, tx_buff_5, tx_buff_6, tx_buff_7, 
tx_buff_8, tx_buff_9, tx_buff_10, tx_buff_11, tx_buff_12, tx_buff_13, tx_buff_14, 
tx_buff_15, tx_buff_16, tx_buff_17, tx_buff_18, tx_buff_19, tx_buff_20, tx_buff_21, 
tx_buff_22, tx_buff_23, tx_buff_24, tx_buff_25, tx_buff_26, tx_buff_27, tx_buff_28, 
tx_buff_29, tx_buff_30, tx_buff_31, tx_buff_32, tx_buff_33, tx_buff_34, tx_buff_35, 
tx_buff_36, tx_buff_37, tx_buff_38, tx_buff_39, tx_buff_40, tx_buff_41, tx_buff_42, 
tx_buff_43, tx_buff_44, tx_buff_45, tx_buff_46, tx_buff_47, tx_buff_48, tx_buff_49, 
tx_buff_50, tx_buff_51, tx_buff_52, tx_buff_53, tx_buff_54, tx_buff_55, tx_buff_56, 
tx_buff_57, tx_buff_58, tx_buff_59, tx_buff_60, tx_buff_61, tx_buff_62, tx_buff_63, 
tx_buff_64, tx_buff_65,dlc,tx_sec
);
    input clk; 
    input g_rst; 
    input [255:0] data_in; 
    input tx_buff_ld; 
    input tx_success; 
    output reg frame_gen_intl; 
    output reg tx_buff_busy; 
    output reg [255:0] tx_buff_1;  
    output reg [255:0] tx_buff_2;  
    output reg [255:0] tx_buff_3;  
    output reg [255:0] tx_buff_4;  
    output reg [255:0] tx_buff_5;   
    output reg [255:0] tx_buff_6;  
    output reg [255:0] tx_buff_7;   
    output reg [255:0] tx_buff_8;   
    output reg [255:0] tx_buff_9;  
    output reg [255:0] tx_buff_10;  
    output reg [255:0] tx_buff_11; 
    output reg [255:0] tx_buff_12; 
    output reg [255:0] tx_buff_13; 
    output reg [255:0] tx_buff_14;  
    output reg [255:0] tx_buff_15; 
    output reg [255:0] tx_buff_16;  
    output reg [255:0] tx_buff_17;  
    output reg [255:0] tx_buff_18;  
    output reg [255:0] tx_buff_19;  
    output reg [255:0] tx_buff_20; 
    output reg [255:0] tx_buff_21; 
    output reg [255:0] tx_buff_22; 
    output reg [255:0] tx_buff_23;  
    output reg [255:0] tx_buff_24;  
    output reg [255:0] tx_buff_25;  
    output reg [255:0] tx_buff_26; 
    output reg [255:0] tx_buff_27;  
    output reg [255:0] tx_buff_28; 
    output reg [255:0] tx_buff_29;  
    output reg [255:0] tx_buff_30;  
    output reg [255:0] tx_buff_31; 
    output reg [255:0] tx_buff_32; 
    output reg [255:0] tx_buff_33;  
    output reg [255:0] tx_buff_34; 
    output reg [255:0] tx_buff_35; 
    output reg [255:0] tx_buff_36; 
    output reg [255:0] tx_buff_37; 
    output reg [255:0] tx_buff_38;  
    output reg [255:0] tx_buff_39; 
    output reg [255:0] tx_buff_40; 
    output reg [255:0] tx_buff_41; 
    output reg [255:0] tx_buff_42; 
    output reg [255:0] tx_buff_43; 
    output reg [255:0] tx_buff_44;  
    output reg [255:0] tx_buff_45;  
    output reg [255:0] tx_buff_46;  
    output reg [255:0] tx_buff_47; 
    output reg [255:0] tx_buff_48;  
    output reg [255:0] tx_buff_49;  
    output reg [255:0] tx_buff_50; 
    output reg [255:0] tx_buff_51;  
    output reg [255:0] tx_buff_52;  
    output reg [255:0] tx_buff_53;  
    output reg [255:0] tx_buff_54; 
    output reg [255:0] tx_buff_55;  
    output reg [255:0] tx_buff_56;  
    output reg [255:0] tx_buff_57;  
    output reg [255:0] tx_buff_58;  
    output reg [255:0] tx_buff_59;  
    output reg [255:0] tx_buff_60; 
    output reg [255:0] tx_buff_61; 
    output reg [255:0] tx_buff_62; 
    output reg [255:0] tx_buff_63; 
    output reg [255:0] tx_buff_64; 
    output reg [255:0] tx_buff_65; 
    output reg [10:0] dlc; 
    output reg tx_sec;

    parameter [8:0] 
        idle = 8'd0, 
        buf0 = 8'd1, 
        buf1 = 8'd2, 
        buf2 = 8'd3, 
        buf3 = 8'd4, 
        buf4 = 8'd5, 
        buf5 = 8'd6, 
        buf6 = 8'd7, 
        buf7 = 8'd8, 
        buf8 = 8'd9, 
        buf9 = 8'd10, 
        buf10 = 8'd11, 
        buf11 = 8'd12, 
        buf12 = 8'd13, 
        buf13 = 8'd14, 
        buf14 = 8'd15, 
        buf15 = 8'd16, 
        buf16 = 8'd17, 
        buf17 = 8'd18, 
        buf18 = 8'd19, 
        buf19 = 8'd20, 
        buf20 = 8'd21, 
        buf21 = 8'd22, 
        buf22 = 8'd23, 
        buf23 = 8'd24, 
        buf24 = 8'd25, 
        buf25 = 8'd26, 
        buf26 = 8'd27, 
        buf27 = 8'd28, 
        buf28 = 8'd29, 
        buf29 = 8'd30, 
        buf30 = 8'd31, 
        buf31 = 8'd32, 
        buf32 = 8'd33, 
        buf33 = 8'd34, 
        buf34 = 8'd35, 
        buf35 = 8'd36, 
        buf36 = 8'd37, 
        buf37 = 8'd38, 
        buf38 = 8'd39, 
        buf39 = 8'd40, 
        buf40 = 8'd41, 
        buf41 = 8'd42, 
        buf42 = 8'd43, 
        buf43 = 8'd44, 
        buf44 = 8'd45, 
        buf45 = 8'd46, 
        buf46 = 8'd47, 
        buf47 = 8'd48, 
        buf48 = 8'd49, 
        buf49 = 8'd50, 
        buf50 = 8'd51, 
        buf51 = 8'd52, 
        buf52 = 8'd53, 
        buf53 = 8'd54, 
        buf54 = 8'd55, 
        buf55 = 8'd56, 
        buf56 = 8'd57, 
        buf57 = 8'd58, 
        buf58 = 8'd59, 
        buf59 = 8'd60, 
        buf60 = 8'd61, 
        buf61 = 8'd62, 
        buf62 = 8'd63, 
        buf63 = 8'd64, 
        buf64 = 8'd65, 
        buf_ld_comp = 8'd66;
    reg [8:0] state;
    reg tx_buff_ld_en;
    reg [255:0] data_reg;
    reg [255:0] data_reg_in;
    reg tx_buff_ld_en_in;

    // Control signal for enabling transmitter buffer loading
    always @ (posedge clk or posedge g_rst) begin
        if (g_rst)
            tx_buff_ld_en_in <= 1'b0;
        else if (tx_buff_ld)
            tx_buff_ld_en_in <= 1'b1;
        else
            tx_buff_ld_en_in <= 1'b0;
    end

    // Load enable signal logic
    always @ (posedge clk or posedge g_rst) begin
        if (g_rst)
            tx_buff_ld_en <= 1'b0;
        else if (tx_buff_ld_en_in)
            tx_buff_ld_en <= 1'b1;
        else
            tx_buff_ld_en <= 1'b0;
    end

    // Data synchronization logic
    always @ (posedge clk or posedge g_rst) begin
        if(g_rst)
            data_reg_in <= 256'd0;
        else
            data_reg_in <= data_in;
    end

    always @ (posedge clk or posedge g_rst) begin
        if(g_rst)
            data_reg <= 256'd0;
        else
            data_reg <= data_reg_in;
    end

    // Output logic and state transitions
    always @ (posedge clk or posedge g_rst) begin
        if (g_rst) begin
            frame_gen_intl <= 1'b0;
            tx_buff_busy <= 1'b0;
            tx_buff_1 <= 256'd0;
            tx_buff_2 <= 256'd0;
            tx_buff_3 <= 256'd0;
            tx_buff_4 <= 256'd0;
            tx_buff_5 <= 256'd0;
            tx_buff_6 <= 256'd0;
            tx_buff_7 <= 256'd0;
            tx_buff_8 <= 256'd0;
            tx_buff_9 <= 256'd0;
            tx_buff_10 <= 256'd0;
            tx_buff_11 <= 256'd0;
            tx_buff_12 <= 256'd0;
            tx_buff_13 <= 256'd0;
            tx_buff_14 <= 256'd0;
            tx_buff_15 <= 256'd0;
            tx_buff_16 <= 256'd0;
            tx_buff_17 <= 256'd0;
            tx_buff_18 <= 256'd0;
            tx_buff_19 <= 256'd0;
            tx_buff_20 <= 256'd0;
            tx_buff_21 <= 256'd0;
            tx_buff_22 <= 256'd0;
            tx_buff_23 <= 256'd0;
            tx_buff_24 <= 256'd0;
            tx_buff_25 <= 256'd0;
            tx_buff_26 <= 256'd0;
            tx_buff_27 <= 256'd0;
            tx_buff_28 <= 256'd0;
            tx_buff_29 <= 256'd0;
            tx_buff_30 <= 256'd0;
            tx_buff_31 <= 256'd0;
            tx_buff_32 <= 256'd0;
            tx_buff_33 <= 256'd0;
            tx_buff_34 <= 256'd0;
            tx_buff_35 <= 256'd0;
            tx_buff_36 <= 256'd0;
            tx_buff_37 <= 256'd0;
            tx_buff_38 <= 256'd0;
            tx_buff_39 <= 256'd0;
            tx_buff_40 <= 256'd0;
            tx_buff_41 <= 256'd0;
            tx_buff_42 <= 256'd0;
            tx_buff_43 <= 256'd0;
            tx_buff_44 <= 256'd0;
            tx_buff_45 <= 256'd0;
            tx_buff_46 <= 256'd0;
            tx_buff_47 <= 256'd0;
            tx_buff_48 <= 256'd0;
            tx_buff_49 <= 256'd0;
            tx_buff_50 <= 256'd0;
            tx_buff_51 <= 256'd0;
            tx_buff_52 <= 256'd0;
            tx_buff_53 <= 256'd0;
            tx_buff_54 <= 256'd0;
            tx_buff_55 <= 256'd0;
            tx_buff_56 <= 256'd0;
            tx_buff_57 <= 256'd0;
            tx_buff_58 <= 256'd0;
            tx_buff_59 <= 256'd0;
            tx_buff_60 <= 256'd0;
            tx_buff_61 <= 256'd0;
            tx_buff_62 <= 256'd0;
            tx_buff_63 <= 256'd0;
            tx_buff_64 <= 256'd0;
            tx_buff_65 <= 256'd0;
            dlc <= 11'd0;
            tx_sec <= 1'b0;            
        end
        else begin
            case (state)
                idle: begin
                    frame_gen_intl <= 1'b0;
                    tx_buff_busy <= 1'b0;
                    tx_buff_1 <= 256'd0;
                    tx_buff_2 <= 256'd0;
                    tx_buff_3 <= 256'd0;
                    tx_buff_4 <= 256'd0;
                    tx_buff_5 <= 256'd0;
                    tx_buff_6 <= 256'd0;
                    tx_buff_7 <= 256'd0;
                    tx_buff_8 <= 256'd0;
                    tx_buff_9 <= 256'd0;
                    tx_buff_10 <= 256'd0;
                    tx_buff_11 <= 256'd0;
                    tx_buff_12 <= 256'd0;
                    tx_buff_13 <= 256'd0;
                    tx_buff_14 <= 256'd0;
                    tx_buff_15 <= 256'd0;
                    tx_buff_16 <= 256'd0;
                    tx_buff_17 <= 256'd0;
                    tx_buff_18 <= 256'd0;
                    tx_buff_19 <= 256'd0;
                    tx_buff_20 <= 256'd0;
                    tx_buff_21 <= 256'd0;
                    tx_buff_22 <= 256'd0;
                    tx_buff_23 <= 256'd0;
                    tx_buff_24 <= 256'd0;
                    tx_buff_25 <= 256'd0;
                    tx_buff_26 <= 256'd0;
                    tx_buff_27 <= 256'd0;
                    tx_buff_28 <= 256'd0;
                    tx_buff_29 <= 256'd0;
                    tx_buff_30 <= 256'd0;
                    tx_buff_31 <= 256'd0;
                    tx_buff_32 <= 256'd0;
                    tx_buff_33 <= 256'd0;
                    tx_buff_34 <= 256'd0;
                    tx_buff_35 <= 256'd0;
                    tx_buff_36 <= 256'd0;
                    tx_buff_37 <= 256'd0;
                    tx_buff_38 <= 256'd0;
                    tx_buff_39 <= 256'd0;
                    tx_buff_40 <= 256'd0;
                    tx_buff_41 <= 256'd0;
                    tx_buff_42 <= 256'd0;
                    tx_buff_43 <= 256'd0;
                    tx_buff_44 <= 256'd0;
                    tx_buff_45 <= 256'd0;
                    tx_buff_46 <= 256'd0;
                    tx_buff_47 <= 256'd0;
                    tx_buff_48 <= 256'd0;
                    tx_buff_49 <= 256'd0;
                    tx_buff_50 <= 256'd0;
                    tx_buff_51 <= 256'd0;
                    tx_buff_52 <= 256'd0;
                    tx_buff_53 <= 256'd0;
                    tx_buff_54 <= 256'd0;
                    tx_buff_55 <= 256'd0;
                    tx_buff_56 <= 256'd0;
                    tx_buff_57 <= 256'd0;
                    tx_buff_58 <= 256'd0;
                    tx_buff_59 <= 256'd0;
                    tx_buff_60 <= 256'd0;
                    tx_buff_61 <= 256'd0;
                    tx_buff_62 <= 256'd0;
                    tx_buff_63 <= 256'd0;
                    tx_buff_64 <= 256'd0;
                    tx_buff_65 <= 256'd0;
                    dlc <= 11'd0;
                    tx_sec <= 1'b0;
                    
                end
                buf0: begin
                    tx_buff_1 <= data_reg; 
                    dlc <= data_reg[226:216]; 
                    tx_sec <= data_reg[227];
                end
               buf1:
			begin 
				 tx_buff_1 <= tx_buff_1; 
				 tx_buff_2 <= data_reg;
			end
		buf2: 
			begin
				tx_buff_2 <= tx_buff_2;
				tx_buff_3 <= data_reg;
			end

		buf3: 
			begin
				tx_buff_3 <= tx_buff_3;
				tx_buff_4 <= data_reg;
			end

		buf4: 
			begin
				tx_buff_4 <= tx_buff_4;
				tx_buff_5 <= data_reg;
			end

		buf5: 
			begin
				tx_buff_5 <= tx_buff_5;
				tx_buff_6 <= data_reg;
			end
		buf6: 
			begin
				tx_buff_6 <= tx_buff_6;
				tx_buff_7 <= data_reg;
			end

		buf7: 
			begin
				tx_buff_7 <= tx_buff_7;
				tx_buff_8 <= data_reg;
			end

		buf8: 
			begin
				tx_buff_8 <= tx_buff_8;
				tx_buff_9 <= data_reg;
			end

		buf9: 
			begin
				tx_buff_9 <= tx_buff_9;
				tx_buff_10 <= data_reg;
			end

		buf10: 
			begin
				tx_buff_10 <= tx_buff_10;
				tx_buff_11 <= data_reg;
			end
		buf11:
			begin 
				 tx_buff_11 <= tx_buff_11; 
				 tx_buff_12 <= data_reg;
			end
		buf12: 
			begin
				tx_buff_12 <= tx_buff_12;
				tx_buff_13 <= data_reg;
			end

		buf13: 
			begin
				tx_buff_13 <= tx_buff_13;
				tx_buff_14 <= data_reg;
			end

		buf14: 
			begin
				tx_buff_14 <= tx_buff_14;
				tx_buff_15 <= data_reg;
			end

		buf15: 
			begin
				tx_buff_15 <= tx_buff_15;
				tx_buff_16 <= data_reg;
			end
		buf16: 
			begin
				tx_buff_16 <= tx_buff_16;
				tx_buff_17 <= data_reg;
			end

		buf17: 
			begin
				tx_buff_17 <= tx_buff_17;
				tx_buff_18 <= data_reg;
			end

		buf18: 
			begin
				tx_buff_18 <= tx_buff_18;
				tx_buff_19 <= data_reg;
			end

		buf19: 
			begin
				tx_buff_19 <= tx_buff_19;
				tx_buff_20 <= data_reg;
			end

		buf20: 
			begin
				tx_buff_20 <= tx_buff_20;
				tx_buff_21 <= data_reg;
			end
			
		buf21: 
			begin
				tx_buff_21 <= tx_buff_21;
				tx_buff_22 <= data_reg;
			end

		buf22: 
			begin
				tx_buff_22 <= tx_buff_22;
				tx_buff_23 <= data_reg;
			end

		buf23: 
			begin
				tx_buff_23 <= tx_buff_23;
				tx_buff_24 <= data_reg;
			end

		buf24: 
			begin
				tx_buff_24 <= tx_buff_24;
				tx_buff_25 <= data_reg;
			end

		buf25: 
			begin
				tx_buff_25 <= tx_buff_25;
				tx_buff_26 <= data_reg;
			end

		buf26: 
			begin
				tx_buff_26 <= tx_buff_26;
				tx_buff_27 <= data_reg;
			end

		buf27: 
			begin
				tx_buff_27 <= tx_buff_27;
				tx_buff_28 <= data_reg;
			end

		buf28: 
			begin
				tx_buff_28 <= tx_buff_28;
				tx_buff_29 <= data_reg;
			end

		buf29: 
			begin
				tx_buff_29 <= tx_buff_29;
				tx_buff_30 <= data_reg;
			end
		buf30: 
			begin
				tx_buff_30 <= tx_buff_30;
				tx_buff_31 <= data_reg;
			end

		buf31: 
			begin
				tx_buff_31 <= tx_buff_31;
				tx_buff_32 <= data_reg;
			end

		buf32: 
			begin
				tx_buff_32 <= tx_buff_32;
				tx_buff_33 <= data_reg;
			end

		buf33: 
			begin
				tx_buff_33 <= tx_buff_33;
				tx_buff_34 <= data_reg;
			end

		buf34: 
			begin
				tx_buff_34 <= tx_buff_34;
				tx_buff_35 <= data_reg;
			end

		buf35: 
			begin
				tx_buff_35 <= tx_buff_35;
				tx_buff_36 <= data_reg;
			end

		buf36: 
			begin
				tx_buff_36 <= tx_buff_36;
				tx_buff_37 <= data_reg;
			end

		buf37: 
			begin
				tx_buff_37 <= tx_buff_37;
				tx_buff_38 <= data_reg;
			end

		buf38: 
			begin
				tx_buff_38 <= tx_buff_38;
				tx_buff_39 <= data_reg;
			end

		buf39: 
			begin
				tx_buff_39 <= tx_buff_39;
				tx_buff_40 <= data_reg;
			end

		buf40: 
			begin
				tx_buff_40 <= tx_buff_40;
				tx_buff_41 <= data_reg;
			end
		buf41:
			begin
				tx_buff_41 <= tx_buff_41;
				tx_buff_42 <= data_reg;
			end

		buf42:
			begin
				tx_buff_42 <= tx_buff_42;
				tx_buff_43 <= data_reg;
			end

		buf43:
			begin
				tx_buff_43 <= tx_buff_43;
				tx_buff_44 <= data_reg;
			end

		buf44:
			begin
				tx_buff_44 <= tx_buff_44;
				tx_buff_45 <= data_reg;
			end

		buf45:
			begin
				tx_buff_45 <= tx_buff_45;
				tx_buff_46 <= data_reg;
			end

		buf46:
			begin
				tx_buff_46 <= tx_buff_46;
				tx_buff_47 <= data_reg;
			end

		buf47:
			begin
				tx_buff_47 <= tx_buff_47;
				tx_buff_48 <= data_reg;
			end

		buf48:
			begin
				tx_buff_48 <= tx_buff_48;
				tx_buff_49 <= data_reg;
			end

		buf49:
			begin
				tx_buff_49 <= tx_buff_49;
				tx_buff_50 <= data_reg;
			end

		buf50:
			begin
				tx_buff_50 <= tx_buff_50;
				tx_buff_51 <= data_reg;
			end
		buf51:
			begin
				tx_buff_51 <= tx_buff_51;
				tx_buff_52 <= data_reg;
			end

		buf52:
			begin
				tx_buff_52 <= tx_buff_52;
				tx_buff_53 <= data_reg;
			end

		buf53:
			begin
				tx_buff_53 <= tx_buff_53;
				tx_buff_54 <= data_reg;
			end

		buf54:
			begin
				tx_buff_54 <= tx_buff_54;
				tx_buff_55 <= data_reg;
			end

		buf55:
			begin
				tx_buff_55 <= tx_buff_55;
				tx_buff_56 <= data_reg;
			end

		buf56:
			begin
				tx_buff_56 <= tx_buff_56;
				tx_buff_57 <= data_reg;
			end

		buf57:
			begin
				tx_buff_57 <= tx_buff_57;
				tx_buff_58 <= data_reg;
			end

		buf58:
			begin
				tx_buff_58 <= tx_buff_58;
				tx_buff_59 <= data_reg;
			end

		buf59:
			begin
				tx_buff_59 <= tx_buff_59;
				tx_buff_60 <= data_reg;
			end

		buf60:
			begin
				tx_buff_60 <= tx_buff_60;
				tx_buff_61 <= data_reg;
			end
		buf61:
			begin
				tx_buff_61 <= tx_buff_61;
				tx_buff_62 <= data_reg;
			end

		buf62:
			begin
				tx_buff_62 <= tx_buff_62;
				tx_buff_63 <= data_reg;
			end

		buf63:
			begin
				tx_buff_63 <= tx_buff_63;
				tx_buff_64 <= data_reg;
			end

		buf64:
			begin
				tx_buff_64 <= tx_buff_64;
				tx_buff_65 <= data_reg;
				frame_gen_intl <= 1'b1; 
			end
		buf_ld_comp: 
			begin 
				 tx_buff_65 <= tx_buff_65; 
				 tx_buff_busy <= 1'b1; 
				 frame_gen_intl <= 1'b0; 
			end
                default: begin 
                    frame_gen_intl <= 1'b0;
                    tx_buff_busy <= 1'b0;
                    tx_buff_1 <= 256'd0;
                    tx_buff_2 <= 256'd0;
                    tx_buff_3 <= 256'd0;
                    tx_buff_4 <= 256'd0;
                    tx_buff_5 <= 256'd0;
                    tx_buff_6 <= 256'd0;
                    tx_buff_7 <= 256'd0;
                    tx_buff_8 <= 256'd0;
                    tx_buff_9 <= 256'd0;
                    tx_buff_10 <= 256'd0;
                    tx_buff_11 <= 256'd0;
                    tx_buff_12 <= 256'd0;
                    tx_buff_13 <= 256'd0;
                    tx_buff_14 <= 256'd0;
                    tx_buff_15 <= 256'd0;
                    tx_buff_16 <= 256'd0;
                    tx_buff_17 <= 256'd0;
                    tx_buff_18 <= 256'd0;
                    tx_buff_19 <= 256'd0;
                    tx_buff_20 <= 256'd0;
                    tx_buff_21 <= 256'd0;
                    tx_buff_22 <= 256'd0;
                    tx_buff_23 <= 256'd0;
                    tx_buff_24 <= 256'd0;
                    tx_buff_25 <= 256'd0;
                    tx_buff_26 <= 256'd0;
                    tx_buff_27 <= 256'd0;
                    tx_buff_28 <= 256'd0;
                    tx_buff_29 <= 256'd0;
                    tx_buff_30 <= 256'd0;
                    tx_buff_31 <= 256'd0;
                    tx_buff_32 <= 256'd0;
                    tx_buff_33 <= 256'd0;
                    tx_buff_34 <= 256'd0;
                    tx_buff_35 <= 256'd0;
                    tx_buff_36 <= 256'd0;
                    tx_buff_37 <= 256'd0;
                    tx_buff_38 <= 256'd0;
                    tx_buff_39 <= 256'd0;
                    tx_buff_40 <= 256'd0;
                    tx_buff_41 <= 256'd0;
                    tx_buff_42 <= 256'd0;
                    tx_buff_43 <= 256'd0;
                    tx_buff_44 <= 256'd0;
                    tx_buff_45 <= 256'd0;
                    tx_buff_46 <= 256'd0;
                    tx_buff_47 <= 256'd0;
                    tx_buff_48 <= 256'd0;
                    tx_buff_49 <= 256'd0;
                    tx_buff_50 <= 256'd0;
                    tx_buff_51 <= 256'd0;
                    tx_buff_52 <= 256'd0;
                    tx_buff_53 <= 256'd0;
                    tx_buff_54 <= 256'd0;
                    tx_buff_55 <= 256'd0;
                    tx_buff_56 <= 256'd0;
                    tx_buff_57 <= 256'd0;
                    tx_buff_58 <= 256'd0;
                    tx_buff_59 <= 256'd0;
                    tx_buff_60 <= 256'd0;
                    tx_buff_61 <= 256'd0;
                    tx_buff_62 <= 256'd0;
                    tx_buff_63 <= 256'd0;
                    tx_buff_64 <= 256'd0;
                    tx_buff_65 <= 256'd0;
                    dlc <= 11'd0;
                    tx_sec <= 1'b0;
                    
                end 
            endcase
        end
    end

    // State transition logic
    always @ (posedge clk or posedge g_rst) begin 
        if (g_rst) 
            state <= idle; 
        else begin 
            case (state) 
                idle: begin 
                    if (tx_buff_ld_en) 
                        state <= buf0; 
                    else 
                        state <= idle; 
                end
                buf0: state <= buf1;
                buf1: state <= buf2;
                buf2: state <= buf3;
                buf3: state <= buf4;
                buf4: state <= buf5;
                buf5: state <= buf6;
                buf6: state <= buf7;
                buf7: state <= buf8;
                buf8: state <= buf9;
                buf9: state <= buf10;
                buf10: state <= buf11;
                buf11: state <= buf12;
                buf12: state <= buf13;
                buf13: state <= buf14;
                buf14: state <= buf15;
                buf15: state <= buf16;
                buf16: state <= buf17;
                buf17: state <= buf18;
                buf18: state <= buf19;
                buf19: state <= buf20;
                buf20: state <= buf21;
                buf21: state <= buf22;
                buf22: state <= buf23;
                buf23: state <= buf24;
                buf24: state <= buf25;
                buf25: state <= buf26;
                buf26: state <= buf27;
                buf27: state <= buf28;
                buf28: state <= buf29;
                buf29: state <= buf30;
                buf30: state <= buf31;
                buf31: state <= buf32;
                buf32: state <= buf33;
                buf33: state <= buf34;
                buf34: state <= buf35;
                buf35: state <= buf36;
                buf36: state <= buf37;
                buf37: state <= buf38;
                buf38: state <= buf39;
                buf39: state <= buf40;
                buf40: state <= buf41;
                buf41: state <= buf42;
                buf42: state <= buf43;
                buf43: state <= buf44;
                buf44: state <= buf45;
                buf45: state <= buf46;
                buf46: state <= buf47;
                buf47: state <= buf48;
                buf48: state <= buf49;
                buf49: state <= buf50;
                buf50: state <= buf51;
                buf51: state <= buf52;
                buf52: state <= buf53;
                buf53: state <= buf54;
                buf54: state <= buf55;
                buf55: state <= buf56;
                buf56: state <= buf57;
                buf57: state <= buf58;
                buf58: state <= buf59;
                buf59: state <= buf60;
                buf60: state <= buf61;
                buf61: state <= buf62;
                buf62: state <= buf63;
                buf63: state <= buf64;
                buf64: state <= buf_ld_comp;
                buf_ld_comp: begin 
                    if (tx_success) 
                        state <= idle; 
                    else 
                        state <= buf_ld_comp; 
                end 
                default: state <= idle; 
            endcase
        end
    end
endmodule
