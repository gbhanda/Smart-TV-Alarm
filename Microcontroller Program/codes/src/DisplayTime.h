#ifndef DisplayTime_H
#define DisplayTime_H

#include "Arduino.h"



class DisplayTime  {
    public:
    //constructor (think void setup(); )
    DisplayTime(bool displayMSG);

    //void Write(struct tm Timeinfo);
    void Write(int _Year, int _Month, int _Day, int _DayofWeek, int _Hour, int _Min, int _Sec);
    void Setup();
    void IR_Record(bool _IR_Record = false, int _numberRecorded = 0);
    void IR_Record_PWR_BTN();
    void Send_Sequence();
    void Wifi_Connecting();

    private:
    String DOW = "";
    String MONTH = "";
}; 


#endif