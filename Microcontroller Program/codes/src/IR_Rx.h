#ifndef IR_Rx_H
#define IR_Rx_H

#include "Arduino.h"



class IR_Rx  {
    public:
    //constructor (think void setup(); )
    IR_Rx(bool _Setup = false);

    //void Write(struct tm Timeinfo);
    void setup();
    void decode(bool _Record);
    void send();
    void Record_Power_Button();
    void send_Power_Button();
    
    uint16_t IR_Decoded;
    uint16_t IR_Data[16][67]; //67 elements x 16 packets of information
 // uint16_t IR_Data[iteration][raw data array]
    uint16_t IR_Data_Length[16];
    uint32_t IR_Data_Timing[16];
    uint16_t length;
    uint16_t Power_Button[67];

    private:
    bool _Recorded = false;
    bool _Recorded_Sequence = false;
}; 


#endif