module par_ser_conv1 (
    input clk,
    input g_rst,
    input [10:0] dlc,
    input par_ser_intl1,
    input tx_success,
    input [16480:0] par_ser_data1,
    
    output reg tx_serial_out1,
    output reg tx_fcrc_intl,
    output reg tx_fcrc_enable,
    output reg tx_fcrc_frm_cmp
);

    reg [1:0] state;  
    reg [16480:0] temp_data; 
    reg [14:0] count;  // Updated to 15 bits to reach up to 16481
  
    parameter [1:0] idle = 2'd0, 
                    load = 2'd1, 
                    slz = 2'd2, 
                    slz_comp = 2'd3;

    // Always block to determine next state        
    always @ (posedge clk or posedge g_rst) begin
        if (g_rst)  
            state <= idle; 
        else begin
            case (state) 
                idle: begin
                    if (par_ser_intl1)
                        state <= load;
                    else
                        state <= idle;
                end

                load: begin
                    state <= slz;
                end

                slz: begin
                    // Updated to 15-bit constants
                    if (count < (15'd98 + (15'd8 * (15'd1024 * dlc[10] + 15'd512 * dlc[9] + 15'd256 * dlc[8] + 
                                  15'd128 * dlc[7] + 15'd64 * dlc[6] + 15'd32 * dlc[5] + 15'd16 * dlc[4] + 
                                  15'd8 * dlc[3] + 15'd4 * dlc[2] + 15'd2 * dlc[1] + 15'd1 * dlc[0])))) begin
                        state <= slz;
                    end else begin
                        state <= slz_comp;
                    end
                end

                slz_comp: begin
                    if (tx_success)
                        state <= idle;
                    else
                        state <= slz_comp;
                end

                default: begin
                    state <= idle;
                end
            endcase
        end
    end

    // Always block to determine outputs and internal signals
    always @ (posedge clk or posedge g_rst) begin
        if (g_rst) begin  
            tx_fcrc_intl <= 1'b1; 
            temp_data <= 16481'd0; 
            tx_serial_out1 <= 1'b0; 
            tx_fcrc_enable <= 1'b0; 
            tx_fcrc_frm_cmp <= 1'b0; 
            count <= 15'd0;  // Reset count to 15-bit 0
        end else begin
            case (state)
                idle: begin
                    if (par_ser_intl1) begin
                        tx_fcrc_intl <= 1'b0; 
                        temp_data <= 16481'd0;  
                        tx_serial_out1 <= 1'b0; 
                        tx_fcrc_enable <= 1'b0; 
                        tx_fcrc_frm_cmp <= 1'b0; 
                        count <= 15'd0;  // Reset count in idle state
                    end else begin
                        tx_fcrc_intl <= 1'b1; 
                        temp_data <= 16481'd0; 
                        tx_serial_out1 <= 1'b0; 
                        tx_fcrc_enable <= 1'b0; 
                        tx_fcrc_frm_cmp <= 1'b0; 
                        count <= 15'd0;
                    end
                end

                load: begin
                    tx_fcrc_intl <= 1'b0; 
                    temp_data <= par_ser_data1; 
                    tx_serial_out1 <= 1'b0; 
                    tx_fcrc_enable <= 1'b1; 
                    tx_fcrc_frm_cmp <= 1'b0; 
                    count <= count + 15'd1;  // Increment count as 15-bit
                end

                slz: begin
                    // Updated to 15-bit constants in the condition
                    if (count < (15'd98 + (15'd8 * (15'd1024 * dlc[10] + 15'd512 * dlc[9] + 15'd256 * dlc[8] + 
                                  15'd128 * dlc[7] + 15'd64 * dlc[6] + 15'd32 * dlc[5] + 15'd16 * dlc[4] + 
                                  15'd8 * dlc[3] + 15'd4 * dlc[2] + 15'd2 * dlc[1] + 15'd1 * dlc[0])))) begin
                        tx_fcrc_intl <= 1'b0;
                        tx_serial_out1 <= temp_data[16480];
                        temp_data <= temp_data << 1;
                        tx_fcrc_enable <= 1'b1;
                        count <= count + 15'd1;
                    end else begin
                        tx_fcrc_intl <= 1'b0;
                        temp_data <= 16481'd0;
                        tx_serial_out1 <= 1'b0;
                        tx_fcrc_enable <= 1'b0;
                        tx_fcrc_frm_cmp <= 1'b1;
                        count <= 15'd0;
                    end
                end

                slz_comp: begin
                    tx_fcrc_frm_cmp <= 1'b0; 
                    tx_fcrc_intl <= 1'b0; 
                    temp_data <= 16481'd0; 
                    tx_serial_out1 <= 1'b0; 
                    tx_fcrc_enable <= 1'b0; 
                end

                default: begin
                    tx_fcrc_intl <= 1'b1; 
                    temp_data <= 16481'd0; 
                    tx_serial_out1 <= 1'b0; 
                    tx_fcrc_enable <= 1'b0; 
                    tx_fcrc_frm_cmp <= 1'b0; 
                end
            endcase
        end
    end
endmodule
