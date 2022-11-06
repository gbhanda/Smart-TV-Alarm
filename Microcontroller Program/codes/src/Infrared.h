#ifndef Infrared_H
#define Infrared_H

#include "Arduino.h"

#define BITtime         562     //length of the carrier bit in microseconds
#define IRLEDpin        33      //the arduino pin connected to IR LED to ground. HIGH=LED ON

class Infrared  {
    public:
    //constructor (think void setup(); )
    Infrared(bool doIR);
    void Setup(int _IRLEDpin, int bitTime); //expects (IR LED Pin number, Time for a single bit(in uS) )
    void IRcarrier(unsigned int IRtimemicroseconds);
    void IRsendCode(unsigned long code);
    void TV_On(void);
    void TV_Channel_Select(void);
    void TV_On_Sequence(void);
    void TV_Off (void);


    //void Write(struct tm Timeinfo);
    void Write(unsigned long User_Button);

    private:
    int _BITtime;

}; 


#endif