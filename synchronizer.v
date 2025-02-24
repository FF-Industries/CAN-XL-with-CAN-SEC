//Synchronizer 

//Module to synchronize receiver to transmitter and send in serial bits
//CHANGES : i have added one more signal as speed_status, 
//which is 0 in arbitration and 1 in Data 

module synchronizer (
    osc_clk, g_rst, can_bus_in, rcvd_lst_bit_ifs, 
    sjw, ovld_err_tx_cmp, txed_lst_bit_ifs, 
    arbtr_sts, clk, bit_destf_intl, sampling_pt, sampled_bit, 
    speed_status
); 

// Inputs 
input osc_clk; 
input g_rst; 
input can_bus_in; 
input [1:0] sjw; 
input arbtr_sts; 
input rcvd_lst_bit_ifs; 
input ovld_err_tx_cmp; 
input txed_lst_bit_ifs;
input speed_status;

output clk; 
output bit_destf_intl; 
output sampling_pt; 
output sampled_bit;


wire clk;
wire DATA_clk;
wire ARB_clk;
reg bit_destf_intl; 
reg sampling_pt; 
reg sampled_bit; 
reg bus_idle; 
reg sync_bit; 
reg edge_detected; 
reg DATA_re_sync; 
reg ARB_re_sync; 

reg [2:0] DATA_prop_seg_cnt; 
reg [2:0] DATA_dly_cnt; 
reg [2:0] DATA_ph_seg1_cnt; 
reg [2:0] DATA_ph_seg2_cnt; 
reg [2:0] DATA_clk_cnt = 3'd7; // what is this cnt 
reg [2:0] DATA_state, DATA_nxt_state; 
reg [5:0] ARB_prop_seg_cnt; 
reg [2:0] ARB_dly_cnt; 
reg [4:0] ARB_ph_seg1_cnt; 
reg [4:0] ARB_ph_seg2_cnt; 
reg [6:0] ARB_clk_cnt; // what is this cnt 
reg [2:0] ARB_state, ARB_nxt_state; 

parameter [2:0] DATA_sof = 3'd0, 
                DATA_prop_seg = 3'd1, 
                DATA_ph_seg1 = 3'd2, 
                DATA_ph_seg2 = 3'd3, 
                DATA_sync_seg = 3'd4; 

parameter [2:0] ARB_sof = 3'd0, 
                ARB_prop_seg = 3'd1, 
                ARB_ph_seg1 = 3'd2, 
                ARB_ph_seg2 = 3'd3, 
                ARB_sync_seg = 3'd4; 

assign DATA_clk = DATA_clk_cnt[2];
assign ARB_clk = ARB_clk_cnt > 6'd38 ? 1:0;
assign clk = speed_status ? DATA_clk:ARB_clk;

// Block to indicate bus_idle 
always @(posedge osc_clk or posedge g_rst) 
begin 
    if (g_rst) 
	begin
		bus_idle <= 1'b1; 
		bit_destf_intl <= 1'b0; 
	end
	// check this out once !!
    else if (((((~arbtr_sts) && (rcvd_lst_bit_ifs || ovld_err_tx_cmp)) || (arbtr_sts && txed_lst_bit_ifs)) && can_bus_in)) 
    begin 
        bus_idle <= 1'b1; 
        bit_destf_intl <= 1'b0; 
    end 
	
    else if ((~can_bus_in) && bus_idle) 
    begin 
        bus_idle <= 1'b0; 
        bit_destf_intl <= 1'b1; 
    end 
end 
 
// Block to sample can bus bit 
always @(posedge osc_clk or posedge g_rst) 
begin 
    if (g_rst) 
    begin 
        sampled_bit <= 1'b1; 
    end 
    else  if (sampling_pt) 
    begin 
        sampled_bit <= can_bus_in; 
    end 
end

//-------------------DATA------------------------------

// Block to increment DATA_prop_seg_cnt 
always @(posedge osc_clk or posedge g_rst) 
begin 
if (speed_status)
begin
    if (g_rst) 
        DATA_prop_seg_cnt <= 3'd1; // changed to 1 from 0 
    else if ((~can_bus_in) && bus_idle) 
        DATA_prop_seg_cnt <= 3'd1; 
    else if ((DATA_nxt_state == DATA_prop_seg) || (DATA_nxt_state == DATA_sof)) 
        DATA_prop_seg_cnt <= DATA_prop_seg_cnt + 3'd1; 
    else 
        DATA_prop_seg_cnt <= 3'd0; 
end
end

// Block to calculate DATA_dly_cnt to delay phase seg 1 
always @(posedge osc_clk or posedge g_rst) 
begin
if (speed_status)
begin 
    if (g_rst) 
        DATA_dly_cnt <= 3'd0; 
    else if ((~can_bus_in) && bus_idle) 
        DATA_dly_cnt <= 3'd0; 
    else if (DATA_re_sync) 
    begin 
        DATA_dly_cnt <= {1'b0, sjw}; 
    end 
    else 
        DATA_dly_cnt <= 3'd0;
end 
end
// Block to increment DATA_phase seg 1 cnt 
always @(posedge osc_clk or posedge g_rst ) 
begin 
if (speed_status)
begin
    if (g_rst) 
        DATA_ph_seg1_cnt <= 3'd0; 
    else if ((~can_bus_in) && bus_idle) 
        DATA_ph_seg1_cnt <= 3'd0; 
    else if (DATA_nxt_state == DATA_ph_seg1) 
        DATA_ph_seg1_cnt <= DATA_ph_seg1_cnt + 3'd1; 
    else 
        DATA_ph_seg1_cnt <= 3'd0; 
end
end

// Block to increment DATA_phase seg 2 cnt 
always @(posedge osc_clk or posedge g_rst) 
begin 
if (speed_status)
begin
    if (g_rst) 
        DATA_ph_seg2_cnt <= 3'd0; 
    else if ((~can_bus_in) && bus_idle) 
        DATA_ph_seg2_cnt <= 3'd0; 
    else if (DATA_nxt_state == DATA_ph_seg2) 
        DATA_ph_seg2_cnt <= DATA_ph_seg2_cnt + 3'd1; 
    else 
        DATA_ph_seg2_cnt <= 3'd0; 
end
end

//-------------------ARB------------------------------

// Block to increment ARB_prop_seg_cnt 
always @(posedge osc_clk or posedge g_rst) 
begin 
if (~speed_status)
begin
    if (g_rst) 
        ARB_prop_seg_cnt <= 6'd1; // changed to 1 from 0 
    else if ((~can_bus_in) && bus_idle) 
        ARB_prop_seg_cnt <= 6'd1; 
    else if ((ARB_nxt_state == ARB_prop_seg) || (ARB_nxt_state == ARB_sof)) 
        ARB_prop_seg_cnt <= ARB_prop_seg_cnt + 6'd1; 
    else 
        ARB_prop_seg_cnt <= 6'd0; 
end
end

// Block to calculate ARB_dly_cnt to delay phase seg 1 
always @(posedge osc_clk or posedge g_rst) 
begin 
if (~speed_status)
begin
    if (g_rst) 
        ARB_dly_cnt <= 3'd0; 
    else if ((~can_bus_in) && bus_idle) 
        ARB_dly_cnt <= 3'd0; 
    else if (ARB_re_sync) 
    begin 
        ARB_dly_cnt <= {1'b0, sjw}; 
    end 
    else 
        ARB_dly_cnt <= 3'd0;
end 
end
// Block to increment ARB_phase seg 1 cnt 
always @(posedge osc_clk or posedge g_rst) 
begin 
if (~speed_status)
begin
    if (g_rst) 
        ARB_ph_seg1_cnt <= 5'd0; 
    else if ((~can_bus_in) && bus_idle) 
        ARB_ph_seg1_cnt <= 5'd0; 
    else if (ARB_nxt_state == ARB_ph_seg1) 
        ARB_ph_seg1_cnt <= ARB_ph_seg1_cnt + 5'd1; 
    else 
        ARB_ph_seg1_cnt <= 5'd0; 
end
end
// Block to increment ARB_phase seg 2 cnt 
always @(posedge osc_clk or posedge g_rst) 
begin 
if (~speed_status)
begin
    if (g_rst) 
        ARB_ph_seg2_cnt <= 5'd0; 
    else if ((~can_bus_in) && bus_idle) 
        ARB_ph_seg2_cnt <= 5'd0; 
    else if (ARB_nxt_state == ARB_ph_seg2) 
        ARB_ph_seg2_cnt <= ARB_ph_seg2_cnt + 5'd1; 
    else 
        ARB_ph_seg2_cnt <= 5'd0; 
end
end

//-------------------------sequential always block--------------

// sequential always block 
always @ (posedge osc_clk or posedge g_rst) 
	begin 
if (speed_status)
begin
		if (g_rst) 
			DATA_state <= DATA_prop_seg; 
		else 
			DATA_state <= DATA_nxt_state; 
	end 
end
	
// sequential always block 
always @ (posedge osc_clk or posedge g_rst) 
	begin
if (~speed_status)
begin 
		if (g_rst) 
			ARB_state <= ARB_prop_seg; 
		else 
			ARB_state <= ARB_nxt_state; 
	end 
end

//-------------------------combinational always block--------------

// combinational always block to determine next state 
always @ (speed_status or DATA_state or ARB_state or bus_idle or edge_detected or DATA_re_sync or ARB_re_sync or DATA_prop_seg_cnt or ARB_prop_seg_cnt or DATA_dly_cnt or DATA_ph_seg1_cnt or DATA_ph_seg2_cnt or ARB_dly_cnt or ARB_ph_seg1_cnt or ARB_ph_seg2_cnt or can_bus_in or sync_bit)
begin
	if (speed_status)
	begin 
		case (DATA_state) 
			DATA_sof: begin 
				if (DATA_prop_seg_cnt < 3'd4) 
					DATA_nxt_state = DATA_sof; 
				else 
					DATA_nxt_state = DATA_ph_seg1; 
			end
			
			DATA_prop_seg: begin 
				if (DATA_prop_seg_cnt < 3'd4)
				begin 
					if ((~can_bus_in) && bus_idle) 
						DATA_nxt_state = DATA_sof; 
					else 
						DATA_nxt_state = DATA_prop_seg; 
				end
				else 
				begin 
					if ((~can_bus_in) && bus_idle) 
						DATA_nxt_state = DATA_sof; 
					else 
						DATA_nxt_state = DATA_ph_seg1; 
				end 
			end
			
			DATA_ph_seg1: begin 
				if (~DATA_re_sync) 
				begin 
					if ((~can_bus_in) && bus_idle) 
						DATA_nxt_state = DATA_sof; 
					else 
						DATA_nxt_state = DATA_ph_seg2; 
				end 
				else 
				begin 
					if (DATA_ph_seg1_cnt < (DATA_dly_cnt) + 3'd1) 
					begin 
						if ((~can_bus_in) && bus_idle) 
							DATA_nxt_state = DATA_sof; 
						else 
							DATA_nxt_state = DATA_ph_seg1; 
					end 
					else 
					begin 
						if ((~can_bus_in) && bus_idle) 
							DATA_nxt_state = DATA_sof; 
						else 
							DATA_nxt_state = DATA_ph_seg2; 
					end 
				end 
			end 
			
			DATA_ph_seg2: 
			begin 
				if ((sync_bit == can_bus_in))
				begin 
					if (DATA_ph_seg2_cnt < 3'd2) 
					begin 
						if ((~can_bus_in) && bus_idle) 
							DATA_nxt_state = DATA_sof; 
						else 
							DATA_nxt_state = DATA_ph_seg2; 
					end 
					else 
					begin 
						if ((~can_bus_in) && bus_idle) 
							DATA_nxt_state = DATA_sof; 
						else 
							DATA_nxt_state = DATA_sync_seg; 
					end 
				end 
				else 
				begin 
					if ((~can_bus_in) && bus_idle) 
						DATA_nxt_state = DATA_sof; 
					else 
						DATA_nxt_state = DATA_prop_seg; 
				end 
			end
			
			DATA_sync_seg: 
			begin 
				if ((~can_bus_in) && bus_idle) 
					DATA_nxt_state = DATA_sof; 
				else 
					DATA_nxt_state = DATA_prop_seg; 
			end 
			
			default:
				DATA_nxt_state = DATA_prop_seg; 
		endcase 
	end
	else if (~speed_status)
	begin 
		case (ARB_state) 
			ARB_sof: begin 
				if (ARB_prop_seg_cnt < 6'd47) 
					ARB_nxt_state = ARB_sof; 
				else 
					ARB_nxt_state = ARB_ph_seg1; 
			end
			
			ARB_prop_seg: begin 
				if (ARB_prop_seg_cnt < 6'd47)
				begin 
					if ((~can_bus_in) && bus_idle) 
						ARB_nxt_state = ARB_sof; 
					else 
						ARB_nxt_state = ARB_prop_seg; 
				end
				else 
				begin 
					if ((~can_bus_in) && bus_idle) 
						ARB_nxt_state = ARB_sof; 
					else 
						ARB_nxt_state = ARB_ph_seg1; 
				 end 
			 end
				
			ARB_ph_seg1: begin 
				if (~ARB_re_sync) 
				begin 
					if ((~can_bus_in) && bus_idle) 
						ARB_nxt_state = ARB_sof; 
					else 
						ARB_nxt_state = ARB_ph_seg2; 
				end 
				else 
				begin 
					if (ARB_ph_seg1_cnt < (ARB_dly_cnt) + 5'd16) 
					begin 
						if ((~can_bus_in) && bus_idle) 
							ARB_nxt_state = ARB_sof; 
						else 
							ARB_nxt_state = ARB_ph_seg1; 
					end 
					else 
					begin 
						if ((~can_bus_in) && bus_idle) 
							ARB_nxt_state = ARB_sof; 
						else 
							ARB_nxt_state = ARB_ph_seg2; 
					end 
				end 
			end 
			
			ARB_ph_seg2: 
			begin 
				if ((sync_bit == can_bus_in))
				begin 
                  if (ARB_ph_seg2_cnt < 5'd16) 
					begin 
						if ((~can_bus_in) && bus_idle) 
							ARB_nxt_state = ARB_sof; 
						else 
							ARB_nxt_state = ARB_ph_seg2; 
					end 
				else 
					begin 
						if ((~can_bus_in) && bus_idle) 
							ARB_nxt_state = ARB_sof; 
						else 
							ARB_nxt_state = ARB_sync_seg; 
					end 
				end 
				else 
				begin 
					if ((~can_bus_in) && bus_idle) 
						ARB_nxt_state = ARB_sof; 
					else 
						ARB_nxt_state = ARB_prop_seg; 
				end 
			end
			
			ARB_sync_seg: 
			begin 
				if ((~can_bus_in) && bus_idle) 
					ARB_nxt_state = ARB_sof; 
				else 
					ARB_nxt_state = ARB_prop_seg; 
			end 
			
			default:
				ARB_nxt_state = ARB_prop_seg; 
		endcase 
	end
end 
// always block to determine next state 
always @ (posedge osc_clk or posedge g_rst)
begin 
	if(speed_status)
	begin 
		if (g_rst) 
		begin 
			edge_detected <=1'b1; 
			sync_bit <= 1'b1;
			DATA_re_sync <= 1'b0; 
			sampling_pt <= 1'b0; 
		end 
		else 
		begin
          case (DATA_state) 
				DATA_sof: 
				begin 
					if (DATA_prop_seg_cnt < 3'd4) 
					begin 
						 edge_detected <=1'b1; 
						 sync_bit <= can_bus_in; 
						 DATA_re_sync <= 1'b0; 
						 sampling_pt <= 1'b0; 
					end 
					else 
					begin 
						 edge_detected <=1'b1; 
						 sync_bit <= sync_bit; 
						 DATA_re_sync <= 1'b0; 
						 sampling_pt <= 1'b0; 
					end 
				end 
				DATA_prop_seg: 
				begin 
					if (DATA_prop_seg_cnt <= 3'd1) 
					begin 
						if (~edge_detected) 
						begin 
							if (sync_bit && (~can_bus_in))
							begin 
								 sync_bit <= can_bus_in;
								 edge_detected <= 1'b1; 
								 DATA_re_sync <= 1'b0; 
								 sampling_pt <= 1'b0; 
							end 
							else if ((~sync_bit) && can_bus_in) 
							begin 
								 sync_bit <= can_bus_in;
								 edge_detected <=1'b1; 
								 DATA_re_sync <= 1'b0; 
								 sampling_pt <= 1'b0; 
							end 
							else 
							begin 
								 sync_bit <= sync_bit; 
								 edge_detected <= 1'b0; 
								 DATA_re_sync <= 1'b0; 
								 sampling_pt <= 1'b0; 
							end 
						end 
						else 
						begin 
							 sync_bit <= sync_bit; 
							 edge_detected <=1'b1; 
							 DATA_re_sync <= 1'b0; 
							 sampling_pt <= 1'b0; 
						end 
					end 
					else if (DATA_prop_seg_cnt > 3'd1 && DATA_prop_seg_cnt < 3'd4) 
					begin 
						 if (~edge_detected) 
							begin 
								 if (sync_bit && (~can_bus_in))
									begin 
										 sync_bit <= can_bus_in;
										 edge_detected <=1'b1; 
										 DATA_re_sync <= 1'b1; 
										 sampling_pt <= 1'b0; //changed
									end 
								else if ((~sync_bit) && can_bus_in) 
								begin 
									 sync_bit <= can_bus_in;
									 edge_detected <=1'b1; 
									 DATA_re_sync <= 1'b0; 
									 sampling_pt <= 1'b0; 
								end 
								else 
								begin 
									 sync_bit <= sync_bit; 
									 edge_detected <= 1'b0; 
									 DATA_re_sync <= 1'b0; 
									 sampling_pt <= 1'b0; 
								end 
							end 
						else 
						begin 
								sync_bit <= sync_bit; 
								edge_detected <=1'b1; 
								DATA_re_sync <= DATA_re_sync; 
								sampling_pt <= 1'b0; 
						end 
					end 
					else 
					begin 
						 if (~edge_detected) 
							 begin 
								 if (sync_bit && (~can_bus_in)) 
									 begin 
										 sync_bit <= can_bus_in;
										 edge_detected <=1'b1; 
										 DATA_re_sync <= 1'b1; 
										 sampling_pt <= 1'b0; //changed
									end 
								else if ((~sync_bit) && can_bus_in) 
								begin 
									 sync_bit <= can_bus_in;
									 edge_detected <=1'b1; 
									 DATA_re_sync <= 1'b0; 
									 sampling_pt <= 1'b0; 
								end 
								else 
								begin 
									sync_bit <= sync_bit; 
									edge_detected <= 1'b0; 
									DATA_re_sync <= 1'b0; 
									sampling_pt <= 1'b0; 
								end 
							end
						else 
						begin 
							 sync_bit <= sync_bit; 
							 edge_detected <= 1'b1; 
							 DATA_re_sync <= DATA_re_sync; 
							 sampling_pt <= 1'b0; 
						end 
					 end 
				end 
				DATA_ph_seg1: 
				begin 
					 if (~DATA_re_sync) 
						begin 
							 edge_detected <= 1'b0; 
							 sync_bit <= sync_bit; 
							 sampling_pt <= 1'b1; 
							 DATA_re_sync <= 1'b0; 
						end 
					else 
						begin 
							// adding new code
							if (edge_detected)
								begin
									edge_detected <= 1'b0; 
									sync_bit <= sync_bit; 
									sampling_pt <= 1'b1; // changed to 1
									DATA_re_sync <= 1'b0;
								end							
							else if (DATA_ph_seg1_cnt < (DATA_dly_cnt + 3'd1)) 
								begin 
									edge_detected <= 1'b0; 
									sync_bit <= sync_bit; 
									sampling_pt <= 1'b0; //changed
									DATA_re_sync <= 1'b1; 
								end 
							else 
								begin 
									 edge_detected <= 1'b0; 
									 sync_bit <= sync_bit; 
									 sampling_pt <= 1'b1; 
									 DATA_re_sync <= 1'b1; 
								end 
						end 
				end 
				DATA_ph_seg2: 
				begin 
					 if ((sync_bit == can_bus_in)) 
						begin 
							if (DATA_ph_seg2_cnt < 3'd2) 
								 begin 
									 sync_bit <= sync_bit; 
									 edge_detected <= 1'b0; 
									 sampling_pt <= 1'b0; 
									 DATA_re_sync <= 1'b0; 
								 end 
							else 
								begin 
									 sync_bit <= sync_bit; 
									 edge_detected <= 1'b0; 
									 sampling_pt <= 1'b0; 
									 DATA_re_sync <= 1'b0; 
								end 
						end 
					else 
						begin 
							sync_bit <= can_bus_in; 
							edge_detected <=1'b1; 
							sampling_pt <= 1'b0; 
							DATA_re_sync <= 1'b0; 
						end  
				end
				DATA_sync_seg: 
				begin 
					 if (sync_bit == can_bus_in) 
						 begin 
							 sync_bit <= sync_bit; 
							 sampling_pt <= 1'b0; 
							 edge_detected <= 1'b0; 
							 DATA_re_sync <= 1'b0; 
						 end 
					else 
						begin 
							sync_bit <= can_bus_in; 
							sampling_pt <= 1'b0; 
							edge_detected <=1'b1; 
							DATA_re_sync <= 1'b0; 
						end 
				end 
				default:
					begin 
						sync_bit <= can_bus_in; 
						sampling_pt <= 1'b0; 
						edge_detected <= 1'b0; 
						DATA_re_sync <= 1'b0; 
					end 
			endcase 
		end 
	end
	else if (~speed_status)
	begin 
		if (g_rst) 
		begin 
			edge_detected <=1'b1; 
			sync_bit <= 1'b1;
			ARB_re_sync <= 1'b0; 
			sampling_pt <= 1'b0; 
		end 
		else 
		begin
          case (ARB_state) 
				ARB_sof: 
				begin 
					if (ARB_prop_seg_cnt < 6'd47) 
						begin 
							edge_detected <=1'b1; 
							 sync_bit <= can_bus_in; 
							 ARB_re_sync <= 1'b0; 
							 sampling_pt <= 1'b0; 
						end 
					else 
						begin 
							 edge_detected <=1'b1; 
							 sync_bit <= sync_bit; 
							 ARB_re_sync <= 1'b0; 
							 sampling_pt <= 1'b0; 
						end 
				end 
				ARB_prop_seg: 
				begin 
					if (ARB_prop_seg_cnt <= 6'd1) 
						begin 
							if (~edge_detected) 
								begin 
									if (sync_bit && (~can_bus_in))
										begin 
											 sync_bit <= can_bus_in;
											 edge_detected <= 1'b1; 
											 ARB_re_sync <= 1'b0; 
											 sampling_pt <= 1'b0; 
										end 
									else if ((~sync_bit) && can_bus_in) 
										begin 
											 sync_bit <= can_bus_in;
											 edge_detected <=1'b1; 
											 ARB_re_sync <= 1'b0; 
											 sampling_pt <= 1'b0; 
										end 
									else 
										begin 
											 sync_bit <= sync_bit; 
											 edge_detected <= 1'b0; 
											 ARB_re_sync <= 1'b0; 
											 sampling_pt <= 1'b0; 
										end 
								end 
							else 
								begin 
									 sync_bit <= sync_bit; 
									 edge_detected <=1'b1; 
									 ARB_re_sync <= 1'b0; 
									 sampling_pt <= 1'b0; 
								end 
						end 
					else if (ARB_prop_seg_cnt > 6'd1 && ARB_prop_seg_cnt < 6'd47) 
						begin 
							 if (~edge_detected) 
								begin 
									 if (sync_bit && (~can_bus_in))
										begin 
											 sync_bit <= can_bus_in;
											 edge_detected <=1'b1; 
											 ARB_re_sync <= 1'b1; 
											 sampling_pt <= 1'b0; //changed 
										end 
									else if ((~sync_bit) && can_bus_in) 
										begin 
											 sync_bit <= can_bus_in;
											 edge_detected <=1'b1; 
											 ARB_re_sync <= 1'b0; 
											 sampling_pt <= 1'b0; 
										end 
									else 
										begin 
											 sync_bit <= sync_bit; 
											 edge_detected <= 1'b0; 
											 ARB_re_sync <= 1'b0; 
											 sampling_pt <= 1'b0; 
										end 
								end 
							else 
							begin 
									sync_bit <= sync_bit; 
									edge_detected <=1'b1; 
									ARB_re_sync <= ARB_re_sync; 
									sampling_pt <= 1'b0; 
							end 
						end 
					else 
					begin 
						 if (~edge_detected) 
							 begin 
								 if (sync_bit && (~can_bus_in)) 
									 begin 
										 sync_bit <= can_bus_in;
										 edge_detected <=1'b1; 
										 ARB_re_sync <= 1'b1; 
										 sampling_pt <= 1'b0; //chnaged 
									end 
								else if ((~sync_bit) && can_bus_in) 
								begin 
									 sync_bit <= can_bus_in;
									 edge_detected <=1'b1; 
									 ARB_re_sync <= 1'b0; 
									 sampling_pt <= 1'b0; 
								end 
								else 
								begin 
									sync_bit <= sync_bit; 
									edge_detected <= 1'b0; 
									ARB_re_sync <= 1'b0; 
									sampling_pt <= 1'b0; 
								end 
							end
						else 
						begin 
							 sync_bit <= sync_bit; 
							 edge_detected <= 1'b1; 
							 ARB_re_sync <= ARB_re_sync; 
							 sampling_pt <= 1'b0; 
						end 
					 end 
				end 
				ARB_ph_seg1: 
				begin 
					 if (~ARB_re_sync) 
						begin 
							 edge_detected <= 1'b0; 
							 sync_bit <= sync_bit; 
							 sampling_pt <= 1'b1; 
							 ARB_re_sync <= 1'b0; 
						end 
					else 
						begin 
							// adding new code
							if (edge_detected)
								begin
									edge_detected <= 1'b0; 
									sync_bit <= sync_bit; 
									sampling_pt <= 1'b1; // changed to 1
									ARB_re_sync <= 1'b0;
								end
							else if (ARB_ph_seg1_cnt < (ARB_dly_cnt + 5'd15)) 
								begin 
									edge_detected <= 1'b0; 
									sync_bit <= sync_bit; 
									sampling_pt <= 1'b0; // changed to 1
									ARB_re_sync <= 1'b1; 
								end 
							else 
								begin 
									 edge_detected <= 1'b0; 
									 sync_bit <= sync_bit; 
									 sampling_pt <= 1'b1; 
									 ARB_re_sync <= 1'b1; 
								end 
						end 
				end 
				ARB_ph_seg2: 
				begin 
					 if ((sync_bit == can_bus_in)) 
						begin 
							if (ARB_ph_seg2_cnt < 5) 
								 begin 
									 sync_bit <= sync_bit; 
									 edge_detected <= 1'b0; 
									 sampling_pt <= 1'b0; 
									 ARB_re_sync <= 1'b0; 
								 end 
							else 
								begin 
									 sync_bit <= sync_bit; 
									 edge_detected <= 1'b0; 
									 sampling_pt <= 1'b0; 
									 ARB_re_sync <= 1'b0; 
								end 
						end 
					else 
						begin 
							sync_bit <= can_bus_in; 
							edge_detected <=1'b1; 
							sampling_pt <= 1'b0; 
							ARB_re_sync <= 1'b0; 
						end  
				end
				ARB_sync_seg: 
				begin 
					 if (sync_bit == can_bus_in) 
						 begin 
							 sync_bit <= sync_bit; 
							 sampling_pt <= 1'b0; 
							 edge_detected <= 1'b0; 
							 ARB_re_sync <= 1'b0; 
						 end 
					else 
						begin 
							sync_bit <= can_bus_in; 
							sampling_pt <= 1'b0; 
							edge_detected <=1'b1; 
							ARB_re_sync <= 1'b0; 
						end 
				end 
				default:
					begin 
						sync_bit <= can_bus_in; 
						sampling_pt <= 1'b0; 
						edge_detected <= 1'b0; 
						ARB_re_sync <= 1'b0; 
					end 
			endcase 
		end 
	end
end

always @ (posedge osc_clk or posedge g_rst)
begin
    if (speed_status) begin
        if (g_rst || (~can_bus_in && bus_idle))
            DATA_clk_cnt <= 3'd7; // Equivalent to 3'd7
    
else if(DATA_clk_cnt <=0)
DATA_clk_cnt <=3'd7;
    else
            DATA_clk_cnt <= DATA_clk_cnt - 1;
    end
    else begin
        if (g_rst || (~can_bus_in && bus_idle))
            ARB_clk_cnt <= 7'd79; // Equivalent to 3'd7
else if(ARB_clk_cnt <=0)
ARB_clk_cnt <=7'd79;
        else
            ARB_clk_cnt <= ARB_clk_cnt - 1;
    end
end

endmodule
