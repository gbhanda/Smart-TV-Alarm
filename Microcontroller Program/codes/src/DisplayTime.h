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

    private:
    String DOW = "";
    String MONTH = "";
}; 


#endif