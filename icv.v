module AES_control_combined(
    input clk, g_rst, enable,
    input [127:0] dataout,  
    input [127:0] dataout1, 
    input done,             
    input done1,            
    input tx_success,       
    output reg [127:0] dataout_combined, 
    output reg done_combined             
);

    reg ADD_Round_en, KeyExpansion_en, Shift_Row_en, MixColumns_en;
    wire ADD_Round_done, Shift_Row_done, MixColumns_done;
    wire [127:0] addround_out, subbyte_out, Shift_Row_out, MixColumns_out, KeyExpansion_out;
    reg [127:0] addround_data_in, addround_key_in;
    reg [3:0] round_reg, round_next;
    reg [127:0] key_reg, key_next;
    reg [2:0] state_reg, state_next;
    reg [127:0] dataout_reg;
    reg done_reg;
    reg [127:0] datain; 
    reg xor_done; 

    localparam [127:0] key = 128'h3c4fcf0984d901fa3248c273efa53945; 

    always @(posedge clk or posedge g_rst) begin
        if (g_rst) begin
            datain <= 128'b0;
            xor_done <= 0;
        end else if (done && done1 && !xor_done) begin
            datain <= dataout ^ dataout1;
            xor_done <= 1; 
        end
    end

    AddRoundKey AddRoundKey_U1 (
        .clk(clk),
        .g_rst(g_rst),
        .enable(ADD_Round_en),
        .data_in(addround_data_in),
        .Key_in(addround_key_in),
        .data_rounded(addround_out),
        .done(ADD_Round_done)
    );

    // Subbytes instances
    Subytes Subytes_U1 (.sboxw(addround_out[127:96]), .new_sboxw(subbyte_out[127:96]));
    Subytes Subytes_U2 (.sboxw(addround_out[95:64]), .new_sboxw(subbyte_out[95:64]));
    Subytes Subytes_U3 (.sboxw(addround_out[63:32]), .new_sboxw(subbyte_out[63:32]));
    Subytes Subytes_U4 (.sboxw(addround_out[31:0]), .new_sboxw(subbyte_out[31:0]));

    Shift_Row Shift_Row_U1 (
        .clk(clk),
        .g_rst(g_rst),
        .enable(Shift_Row_en),
        .data_in(subbyte_out),
        .data_Shifted(Shift_Row_out),
        .done(Shift_Row_done)
    );

    MixColumns MixColumns_U1 (
        .clk(clk),
        .g_rst(g_rst),
        .enable(MixColumns_en),
        .data_in(Shift_Row_out),
        .data_mixed(MixColumns_out),
        .done(MixColumns_done)
    );

    KeyExpansion KeyExpansion_U1 (
        .clk(clk),
        .g_rst(g_rst),
        .enable(KeyExpansion_en),
        .round(round_reg),
        .key_in(key_reg),
        .key_out(KeyExpansion_out)
    );

    // State machine states
    localparam START = 0, SHIFT = 1, MIX = 2, ADDROUND = 3;

    always @(posedge clk or posedge g_rst) begin
        if (g_rst) begin
            state_reg <= START;
            round_reg <= 0;
            key_reg <= key;
            dataout_reg <= 128'b0;
            done_reg <= 0;
            dataout_combined <= 128'b0;
            done_combined <= 0;
        end else if (tx_success) begin
            dataout_combined <= 128'b0;
            done_combined <= 0;
        end else if (enable && xor_done) begin
            state_reg <= state_next;
            round_reg <= round_next;
            key_reg <= key_next;
            dataout_reg <= (round_reg == 11) ? addround_out : dataout_reg;
            done_reg <= (round_reg == 11) ? 1 : 0;
            
            if (round_reg == 11) begin
                dataout_combined <= addround_out;
                done_combined <= 1;
            end
        end
    end

    always @(*) begin
        round_next = round_reg;
        state_next = state_reg;
        key_next = key_reg;
        if (enable && xor_done) begin
            // Encryption process
            if (round_reg <= 11) begin
                case (state_reg)
                    START: begin
                        addround_data_in = datain; 
                        addround_key_in = key;
                        MixColumns_en = 0;
                        KeyExpansion_en = 1;
                        Shift_Row_en = 0;
                        ADD_Round_en = 1;
                        round_next = round_reg + 1;
                        state_next = SHIFT;
                    end
                    SHIFT: begin
                        if (ADD_Round_done) begin
                            KeyExpansion_en = 1;
                            MixColumns_en = 0;
                            Shift_Row_en = 1;
                            ADD_Round_en = 0;

                            if (round_reg < 10)
                                state_next = MIX;
                            else
                                state_next = ADDROUND;
                        end
                    end
                    MIX: begin
                        if (Shift_Row_done) begin
                            KeyExpansion_en = 1;
                            MixColumns_en = 1;
                            Shift_Row_en = 0;
                            ADD_Round_en = 0;
                            state_next = ADDROUND;
                        end
                    end
                    ADDROUND: begin
                        if (MixColumns_done || (Shift_Row_done && (round_reg >= 10))) begin
                            MixColumns_en = 0;
                            Shift_Row_en = 0;
                            KeyExpansion_en = 1;
                            ADD_Round_en = 1;

                            addround_data_in = (round_reg < 10) ? MixColumns_out : Shift_Row_out;
                            addround_key_in = KeyExpansion_out;
                            key_next = KeyExpansion_out;
                            round_next = round_reg + 1;
                            state_next = SHIFT;
                        end
                    end
                endcase
            end else begin
                KeyExpansion_en = 0;
                Shift_Row_en = 0;
                MixColumns_en = 0;
                ADD_Round_en = 0;
                round_next = 0;
                state_next = START;
                xor_done = 0; 
            end
        end else begin
            KeyExpansion_en = 0;
            Shift_Row_en = 0;
            MixColumns_en = 0;
            ADD_Round_en = 0;
        end
    end

endmodule
