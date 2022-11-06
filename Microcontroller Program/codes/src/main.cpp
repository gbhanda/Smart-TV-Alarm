#include <Arduino.h>
/**************************************************************************
* Declaration for an SSD1306 display connected to I2C (SDA, SCL pins)     *
* The pins for I2C are defined by the Wire-library.                       *
* On an ESP32 DOIT DEVKIT V1:       D22(SDA), D21(SCL)                    *
*                                   IR_LED - D33                          *
*                                   IR_Recieve                            *
 **************************************************************************/
#include "DisplayTime.h"
#include "Infrared.h"
#include <WiFi.h>
#include <time.h>
#include <TimeAlarms.h>
#include <NTPClient.h>
#include <TimeLib.h>


#define NTP_ADDRESS "pool.ntp.org"
#define NTP_OFFSET -3600*4 // In seconds WAS *5!!!!!!!! (Changed for DST)
#define BITtime         562     //length of the carrier bit in microseconds
#define IRLEDpin        33      //the arduino pin connected to IR LED to ground. HIGH=LED ON

//unsigned long Power_Button = 0b10101000000111000001011111101000; // <--- This is what I directly Decoded, 
                                                                   //but it worked when i flipped the bits
unsigned long The_Power_Button   = 0b01010111111000111110100000010111; //Still Right
unsigned long Home_Button    = 0b01010111111000111100000000111111;
unsigned long Down_Arrow     = 0b01010111111000111100110000110011;
unsigned long Right_Arrow    = 0b01010111111000111011010001001011;
unsigned long OK_Button      = 0b01010111111000110101010010101011;


bool TVon = false;
const char* ssid       = "JOY";
const char* password   = "Maggie123";
//const char* ssid       = "Cui Home";
//const char* password   = "Shuzhen@1";
const char* ntpServer = "pool.ntp.org";
const long  gmtOffset_sec = (-3600 * 4);  //WAS * 5!!!!!!!!!!!!!!!!! (Changed for DST)
const int   daylightOffset_sec = 0;

struct tm timeinfo;
DisplayTime displaytime(true);
Infrared IR(true);

//const int   daylightOffset_sec = 3600;



/*************************************************************************
*                                                                        *
*            This function gets the current time from WiFi               *
*                                                                        *
**************************************************************************/
 void getTime(void){
    //connect to WiFi
  WiFi.begin(ssid, password);
  Serial.printf("Connecting to %s ", ssid);
  while (WiFi.status() != WL_CONNECTED) {
     Alarm.delay(500);
      Serial.print("...");
  }
  Serial.println(" CONNECTED");
  
  //init and get the time
  configTime(gmtOffset_sec, daylightOffset_sec, ntpServer);
  Serial.println("Recieving Local Time");
    
  if(!getLocalTime(&timeinfo)){
    Serial.println("Failed to obtain time");
    setup();
  } else Serial.println("Recieved Local Time");


  Serial.print(&timeinfo, "%H"); 
  Serial.print(F(":")); 
  Serial.print(&timeinfo, "%M"); 
  Serial.print(F(" ("));
  Serial.print(&timeinfo, "%S");
  Serial.println(F(")"));

  //disconnect WiFi as it's no longer needed
  WiFi.disconnect(true);
  WiFi.mode(WIFI_OFF);
  Serial.println("**********DISCONNECTED**********");
  }


void tvOnSeq(){
  IR.TV_On_Sequence();
}
void TV_Off(){
  IR.TV_Off();
}


void AlarmTimeSetup(){
      //connect to WiFi
  WiFi.begin(ssid, password);
  Serial.printf("Connecting to %s ", ssid);
  
  WiFiUDP ntpUDP; 
  NTPClient timeClient(ntpUDP, NTP_ADDRESS, NTP_OFFSET);

  while (WiFi.status() != WL_CONNECTED) { 
      Alarm.delay(500); 
      Serial.print("."); 
    } // Print local IP address and start web server 
    Serial.println(""); 
    Serial.println("WiFi connected."); 
    Serial.println("IP address: "); 
    Serial.println(WiFi.localIP()); 
    timeClient.update(); 
    unsigned long epochTime = timeClient.getEpochTime();
    struct tm *ptm = gmtime ((time_t *)&epochTime);
    
    String newtime = timeClient.getFormattedTime(); 
    int Month = ptm->tm_mon+1;
    int MonthDay = ptm->tm_mday;
    int Year = ptm->tm_year+1900;
    
    Serial.print("the time is : "); 
    Serial.println(newtime); 
    Serial.print("Hour : "); 
    Serial.println((newtime.substring(0,2)).toInt()); 
    Serial.print("Minute : "); 
    Serial.println((newtime.substring(3,5)).toInt()); 
    Serial.print("Seconds : "); 
    Serial.println((newtime.substring(6,8)).toInt()); 

    Serial.print("Month is: ");
    Serial.println(Month);

    Serial.print("Day is: ");
    Serial.println(MonthDay);

    Serial.print("Year is: ");
    Serial.println(Year);
    
    setTime((newtime.substring(0,2)).toInt(),(newtime.substring(3,5)).toInt(),(newtime.substring(6,8)).toInt(),MonthDay,Month,Year); 

  //disconnect WiFi as it's no longer needed
  WiFi.disconnect(true);
  WiFi.mode(WIFI_OFF);
  Serial.println("**********DISCONNECTED**********");
  }
  


  void setup(){
  Serial.begin(9600);

  IR.Setup(IRLEDpin, BITtime);

  displaytime.Setup();
  delay(1000);
  getTime();
  AlarmTimeSetup();


  //   Alarm.alarmRepeat(18,53,0, getTime);            // Refresh Time at 1:00 am every day
  //   Alarm.alarmRepeat(19,56,0, AlarmTimeSetup);     // Refresh Time at 1:00 am every day 
  //Alarm.timerRepeat(3, SerialTest);
  //Alarm.timerRepeat(1, DisplayLocalTime);

  Alarm.alarmRepeat(dowMonday    , 6,45,0, tvOnSeq);
  Alarm.alarmRepeat(dowMonday    , 7,20,0, TV_Off);
  
  Alarm.alarmRepeat(dowTuesday   , 6,45,0, tvOnSeq);
  Alarm.alarmRepeat(dowTuesday   , 7,20,0, TV_Off);
  
  Alarm.alarmRepeat(dowWednesday , 6,45,0,  tvOnSeq);
  Alarm.alarmRepeat(dowWednesday , 7,20,0, TV_Off);
  
  Alarm.alarmRepeat(dowThursday  , 8,30,0,  tvOnSeq);
  Alarm.alarmRepeat(dowThursday  , 9,20,0, TV_Off);
  
  Alarm.alarmRepeat(dowFriday    , 6,45,0,  tvOnSeq);
  Alarm.alarmRepeat(dowFriday    , 7,20,0, TV_Off);


//  Alarm.alarmRepeat(dowSaturday  , 9,15,0,  tvOnSeq);
//  Alarm.alarmRepeat(dowSaturday  , 9,15,0,  tvOnSeq);
//
//  Alarm.alarmRepeat(dowSunday    , 15,20,0,  tvOnSeq);
//  Alarm.alarmRepeat(dowSunday    , 15,20,0,  tvOnSeq);
}

void loop() {
  Alarm.delay(100);
  IR.Write(The_Power_Button);
  displaytime.Write(year(), month(), day(), weekday(), hourFormat12(), minute(), second());
}