module registry (clk, g_rst, data_in, param_ld, mask_param, code_param, 
sjw); 

input clk; 
input g_rst;  
input [255:0] data_in; 
input param_ld; 
output [10:0] mask_param; 
output [10:0] code_param; 

output [1:0] sjw; 

reg [255:0] data_reg; 
reg [255:0] data_reg_in; 
reg [10:0] mask_param; 
reg [10:0] code_param; 
reg [1:0] sjw; 
reg [1:0] state; 
reg param_ld_en; 
reg param_ld_in;

parameter [1:0] 
				 idle = 2'd0, 
				 prmtr_0 = 2'd1, 
				 prmtr_ld_comp = 2'd2;
				 
// Block to enable parameter load 
always @ (posedge clk or posedge g_rst) 
	begin 
		if (g_rst) 
			param_ld_in <= 1'b0; 
		else if (param_ld) 
			param_ld_in <= 1'b1; 
		else param_ld_in <= 1'b0; 
	end
	
// Block to enable parameter load 
always @ (posedge clk or posedge g_rst) 
	begin 
		if (g_rst) 
			param_ld_en <= 1'b0; 
		else if (param_ld_in) 
			param_ld_en <= 1'b1; 
		else param_ld_en <= 1'b0; 
	end
	
//Blocks to synchronize data_in 
always @ (posedge clk or posedge g_rst) 
	begin 
		if(g_rst) 
			data_reg_in <= 256'd0; 
		else data_reg_in <= data_in; 
	end
	
always @ (posedge clk or posedge g_rst) 
	begin 
		if(g_rst) 
			data_reg <= 256'd0; 
		else data_reg <= data_reg_in; 
	end 

//Block to determine output 
always @ (posedge clk or posedge g_rst) 
	begin 
		if(g_rst) 
			begin 
				mask_param <= 15'd0; 
				code_param <= 15'd0; 
				sjw <= 2'd0; 
			end 
		else 
			begin 
				case(state) 
					idle:
						begin 
							mask_param <= 15'd0; 
							code_param <= 15'd0; 
							sjw <= 2'd0; 
						end
						
					prmtr_0:
						begin	
							mask_param <= {data_reg[170:160]};
							code_param <= {data_reg[255:245]};
							sjw <= {data_reg[159:158]};
						end
							
					prmtr_ld_comp:
						begin 
							mask_param <= mask_param; 
							code_param <= code_param; 
							sjw <= sjw; 
						end 
						
					default: 
						begin 
							mask_param <= 15'd0; 
							code_param <= 15'd0; 
							sjw <= 2'd0; 
						end
				endcase 
			end
	end

//Block to determine nxt_state 
always @ (posedge clk or posedge g_rst) 
	begin 
		if (g_rst) 
			state <= idle; 
		else 
			begin 
				case (state) 
					idle:
						begin 
							if (param_ld_en) 
								begin 
									state <= prmtr_0; 
								end 
							else 
								begin 
									state <= idle; 
								end 
						end 
	
					prmtr_0:
						begin 
							state <= prmtr_ld_comp;  
						end
					
					prmtr_ld_comp:
						begin 
							if (param_ld_en) 
								state <= prmtr_0; 
							else 
								begin 
									state <= prmtr_ld_comp; 
								end 
						end 
						
					default: 
						begin 
							state <= idle; 
						end
				endcase
	end
end 

endmodule
