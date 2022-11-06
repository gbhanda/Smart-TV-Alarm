#include "Arduino.h"
#include "Infrared.h"
#include "TimeAlarms.h"

//unsigned long Power_Button = 0b10101000000111000001011111101000; // <--- This is what I directly Decoded, but it worked when i flipped the bits
unsigned long Power_Button   = 0b01010111111000111110100000010111; //Still Right
unsigned long Home_Button    = 0b01010111111000111100000000111111;
unsigned long Down_Arrow     = 0b01010111111000111100110000110011;
unsigned long Right_Arrow    = 0b01010111111000111011010001001011;
unsigned long OK_Button      = 0b01010111111000110101010010101011;
unsigned long User_PWR_Button;

/*************************************************************************
*             This section gets the current time information             *
*                      And displays it on the screen                     *
*                                                                        *
**************************************************************************/

Infrared::Infrared(bool doIR){
    NOP();
}

void Infrared::Setup(int _IRLEDpin, int bitTime){
  pinMode(_IRLEDpin, OUTPUT);
  digitalWrite(_IRLEDpin, LOW);    //turn off Infrared LED to start
  _BITtime = bitTime;
}

void Infrared::IRcarrier(unsigned int IRtimemicroseconds){
  for(int i=0; i < (IRtimemicroseconds / 26); i++)
    {
    digitalWrite(IRLEDpin, HIGH);   //turn on theInfrared LED
    //NOTE: digitalWrite takes about 3.5us to execute, so we need to factor that into the timing.
    delayMicroseconds(14);          //delay for 13us (9us + digitalWrite), half the carrier frequnecy
    digitalWrite(IRLEDpin, LOW);    //turn off theInfrared LED
    delayMicroseconds(14);          //delay for 13us (9us + digitalWrite), half the carrier frequnecy
    }
}

void Infrared::IRsendCode(unsigned long code){
  //send the leading pulse
  IRcarrier(9000);            //9ms of carrier
  delayMicroseconds(4500);    //4.5ms of silence
 
  //send the user defined 4 byte/32bit code
  for (int i=0; i<32; i++)             //send all 4 bytes or 32 bits
    {
    IRcarrier(_BITtime);               //turn on the carrier for one bit time
    if (code & 0x80000000)             //get the current bit by masking all but the MSB
    delayMicroseconds(3 * _BITtime);   //a HIGH is 3 bit time periods
    else
    delayMicroseconds(_BITtime);       //a LOW is only 1 bit time period
     code <<= 1;                       //shift to the next bit for this byte
    }
  IRcarrier(_BITtime);                 //send a single STOP bit.
}

void Infrared::TV_On(void){
    IRsendCode(Power_Button);// ON
    Serial.println("TV On");
}

void Infrared::TV_Channel_Select(void){
  IRsendCode(Home_Button);
  Serial.println("Home"); 
  Alarm.delay(1000);

  IRsendCode(Home_Button);
  Serial.println("Home"); 
    Alarm.delay(3000);

  IRsendCode(Right_Arrow);
  Serial.println("Right to go to YT TV"); 
    Alarm.delay(250);

  IRsendCode(OK_Button);// Selects YT TV
  Serial.println("Select YT TV"); 
    Alarm.delay(15000);

  IRsendCode(Right_Arrow);
  Serial.println("Select Live TV"); 
    Alarm.delay(1500);

  IRsendCode(Down_Arrow);
  Serial.println("Scroll at Fox News"); 
    Alarm.delay(1000);

  IRsendCode(Down_Arrow);
  Serial.println("Scroll at ABC"); 
    Alarm.delay(500);

  IRsendCode(OK_Button);
  Serial.println("Select ABC News"); 
}

void Infrared::TV_On_Sequence(void){
    TV_On();
    Alarm.delay(10000);
    TV_Channel_Select();
    }

void Infrared::TV_Off (void){
    IRsendCode(Power_Button);// ON
    Serial.println("TV Off");
}

//void DisplayTime::Write(struct tm Timeinfo)
void Infrared::Write(unsigned long User_Button){
    IRsendCode(User_Button);
}
