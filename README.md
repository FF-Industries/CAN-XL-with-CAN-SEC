# CAN - XL with semi implementation of CAN - SEC

Please read about the implementation in the provided document and also refer to Krishnamoorthy_Sreeram_Thesis as this is the main source of the code many parts of the code are simillar to the work done in this thesis. My work is just built upon this base layer as it extends the capabilty of the thesis code to handle CAN-XL frame format and has a semi implementation of CAN-SEC as i was not able to implement other parts of SEC only the encryption part of the data using AES-128 and also creating ICV but was not able to create a decryption part.

![image](https://github.com/user-attachments/assets/bd9d45a5-0971-450f-9564-935296647e80)

The above image shows all the nodes have acknowledgment working when one node sends the data. 


