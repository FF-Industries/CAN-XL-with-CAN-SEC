module par_ser_conv (
    input clk,
    input g_rst,
    input par_ser_intl,
    input tx_success,
    input [43:0] par_ser_data,
    
    output reg tx_serial_out,
    output reg tx_pcrc_intl,
    output reg tx_pcrc_enable,
    output reg tx_pcrc_frm_cmp
);
  
    reg [1:0] state;  
    reg [43:0] temp_data; 
    reg [5:0] count; 
  
    parameter [1:0] idle = 2'd0,
                    load = 2'd1,
                    slz = 2'd2,
                    slz_comp = 2'd3;
 
    // Always block to determine the next state        
    always @ (posedge clk or posedge g_rst) begin
        if (g_rst)  
            state <= idle;
        else begin
            case (state)
                idle: begin
                    if (par_ser_intl)
                        state <= load;
                    else
                        state <= idle;
                end

                load: begin
                    state <= slz;
                end

                slz: begin
                    if (count < 6'd45)
                        state <= slz;
                    else
                        state <= slz_comp;
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
            tx_pcrc_intl <= 1'b1; 
            temp_data <= 44'd0; 
            tx_serial_out <= 1'b0; 
            tx_pcrc_enable <= 1'b0; 
            tx_pcrc_frm_cmp <= 1'b0; 
            count <= 6'd0; 
        end else begin
            case (state)
                idle: begin
                    if (par_ser_intl) begin
                        tx_pcrc_intl <= 1'b0; 
                        temp_data <= 44'd0;  
                        tx_serial_out <= 1'b0; 
                        tx_pcrc_enable <= 1'b0; 
                        tx_pcrc_frm_cmp <= 1'b0; 
                        count <= 6'd0; 
                    end else begin
                        tx_pcrc_intl <= 1'b1; 
                        temp_data <= 44'd0; 
                        tx_serial_out <= 1'b0; 
                        tx_pcrc_enable <= 1'b0; 
                        tx_pcrc_frm_cmp <= 1'b0; 
                        count <= 6'd0; 
                    end
                end

                load: begin
                    tx_pcrc_intl <= 1'b0; 
                    temp_data <= par_ser_data; 
                    tx_serial_out <= 1'b0; 
                    tx_pcrc_enable <= 1'b1; 
                    tx_pcrc_frm_cmp <= 1'b0; 
                    count <= count + 6'd1; 
                end

                slz: begin
                    if (count < 6'd45) begin
                        tx_pcrc_intl <= 1'b0;
                        tx_serial_out <= temp_data[43];
                        temp_data <= temp_data << 1;
                        tx_pcrc_enable <= 1'b1;
                        count <= count + 6'd1;
                    end else begin
                        tx_pcrc_intl <= 1'b0;
                        temp_data <= 44'd0;
                        tx_serial_out <= 1'b0;
                        tx_pcrc_enable <= 1'b0;
                        tx_pcrc_frm_cmp <= 1'b1;
                        count <= 6'd0;
                    end
                end

                slz_comp: begin
                    tx_pcrc_frm_cmp <= 1'b0; 
                    tx_pcrc_intl <= 1'b0; 
                    temp_data <= 44'd0; 
                    tx_serial_out <= 1'b0; 
                    tx_pcrc_enable <= 1'b0; 
                end

                default: begin
                    tx_pcrc_intl <= 1'b1; 
                    temp_data <= 44'd0; 
                    tx_serial_out <= 1'b0; 
                    tx_pcrc_enable <= 1'b0; 
                    tx_pcrc_frm_cmp <= 1'b0; 
                end
            endcase
        end
    end
endmodule
