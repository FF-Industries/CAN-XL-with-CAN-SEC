# CANXL-SEC

Please read about the implementation in the provided document and also refer to Krishnamoorthy_Sreeram_Thesis as this is the main source of the code many parts of the code are simillar to the work done in this thesis. My work is just built upon this base layer as it extends the capabilty of the thesis code to handle CAN-XL frame format and has a semi implementation of CAN-SEC as i was not able to implement other parts of SEC only the encryption part of the data using AES-128 and also creating ICV but was not able to create a decryption part.

![image](https://github.com/user-attachments/assets/bd9d45a5-0971-450f-9564-935296647e80)

The above image shows all the nodes have acknowledgment working when one node sends the data. 

![image](https://github.com/user-attachments/assets/0780417a-c204-4903-82a3-d007d25fed6f)

The above image shows the final data output that the CPU must get but in my case due to timing issues i could not make the data_out_2 send any data and this is the third node but in case of Krishnamoorthy_Sreeram_Thesis everything works correctly.

I am using vivado tool to run the simulations and the important input signal is osc_clk and data_in and output to verify is data_out and also can_bus_out.

Results from Krishnamoorthy_Sreeram_Thesis







