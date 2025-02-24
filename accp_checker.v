module accp_checker (clk, g_rst, arbtr_sts, mask_param, code_param, 
rcvd_lst_bit_eof, stf_frm_crc_err_pre,bt_ack_err_pre, rcvd_prio_id, 
acpt_sts); 
 
input clk; 
input g_rst; 
input arbtr_sts; 
input rcvd_lst_bit_eof; 
input [10:0] rcvd_prio_id;             
input bt_ack_err_pre; 
input stf_frm_crc_err_pre;               
input [10:0] mask_param;      
input [10:0] code_param; 
 
output acpt_sts; 
 
reg acpt_sts; 
reg arbtr_sts_en; 
 
always @ (posedge clk or posedge g_rst)  
   begin 
      if (g_rst) 
         arbtr_sts_en <= 1'b0;  
      else if (arbtr_sts) 
         arbtr_sts_en <= 1'b1;  
      else arbtr_sts_en <= 1'b0;     
    end   
 
always @ (posedge clk or posedge g_rst) 
   begin 
      if(g_rst) 
         acpt_sts <= 1'b0; 
      else if((~arbtr_sts_en) && rcvd_lst_bit_eof && 
 (~(stf_frm_crc_err_pre || bt_ack_err_pre))) 
         begin 
            if(((code_param ^ rcvd_prio_id) & mask_param) ==  
     11'b00000000000)        
               acpt_sts <= 1'b1; 
            else 
               acpt_sts <= 1'b0; 
        end    
      else acpt_sts <= 1'b0; 
   end 
endmodule
