#include "Arduino.h"
#include "DisplayTime.h"
#include "time.h"
#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#include <string>

#define OLED_RESET      4       // Reset pin # (or -1 if sharing Arduino reset pin)
#define SCREEN_WIDTH    128     // OLED display width, in pixels
#define SCREEN_HEIGHT   32      // OLED display height, in pixels
#define SCREEN_ADDRESS  0x3C    //< See datasheet for Address; 0x3D for 128x64, 0x3C for 128x32
Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);

/*************************************************************************
*             This section gets the current time information             *
*                      And displays it on the screen                     *
*                                                                        *
**************************************************************************/
DisplayTime::DisplayTime(bool displayMSG){

}

void DisplayTime::Setup(){
    //Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);
    if(!display.begin(SSD1306_SWITCHCAPVCC, SCREEN_ADDRESS)) {
    Serial.println(F("SSD1306 allocation failed"));
    for(;;); // Don't proceed, loop forever
    }
}

//void DisplayTime::Write(struct tm Timeinfo)
void DisplayTime::Write(int _Year, int _Month, int _Day, int _DayofWeek, int _Hour, int _Min, int _Sec)
{




  switch (_DayofWeek)
  {
    case 1:
        DOW = "Sunday";
        break;
    case 2:
        DOW = "Monday";
        break;
    case 3:
        DOW = "Tuesday";
        break;
    case 4:
        DOW = "Wednesday";
        break;
    case 5:
        DOW = "Thursday";
        break;
    case 6:
        DOW = "Friday";
        break;
    case 7:
        DOW = "Saturday";
        break;
    default:
        DOW = "ERROR";
        break;
  }

  switch (_Month)
  {
    case 1:
        MONTH = "January";
        break;
    case 2:
        MONTH = "February";
        break; 
    case 3:
        MONTH = "March";
        break;
    case 4:
        MONTH = "April";
        break;
    case 5:
        MONTH = "May";
        break;
    case 6:
        MONTH = "June";
        break;
    case 7:
        MONTH = "July";
        break;
    case 8:
        MONTH = "August";
        break;
    case 9:
        MONTH = "September";
        break;
    case 10:
        MONTH = "October";
        break;
    case 11:
        MONTH = "November";
        break;
    case 12:
        MONTH = "December";
        break;
    default:
        MONTH = "ERROR";
        break;
  }

  Serial.println("Updating Display");

  display.clearDisplay();
  display.setTextSize(1);             // Normal 1:1 pixel scale
  display.setTextColor(SSD1306_WHITE);        // Draw white text
  display.setCursor(0,0);             // Start at top-left corner
  display.println(F("TV ALARM CLOCK"));

  display.setTextSize(2);             // Draw 2X-scale text
  display.print(_Hour); 
  display.print(F(":")); 
  display.print(_Min); 
  display.print(F(" ("));
  display.print(_Sec);
  display.println(F(")"));

  display.setTextSize(1); 
  display.print(DOW);
  display.print(" ");
  display.print(MONTH);
  display.print(" ");
  display.print(_Day);
  
  display.display();
}

void DisplayTime::IR_Record_PWR_BTN(){
    display.clearDisplay();
    display.setTextColor(SSD1306_WHITE);        // Draw white text
    display.setCursor(0,0);             // Start at top-left corner
    display.setTextSize(2); 
    display.println(F("Press Power Button"));
    display.display();
}



void DisplayTime::IR_Record(bool _IR_Record, int _numberRecorded){
    display.clearDisplay();
    display.setTextSize(1);             // Normal 1:1 pixel scale
    display.setTextColor(SSD1306_WHITE);        // Draw white text
    display.setCursor(0,0);             // Start at top-left corner
    display.println(F("Recording IR Data"));
    display.setTextSize(2); 
    display.print(_numberRecorded);
    display.println(F("/16"));
    display.setTextSize(1);
    display.print("Press Done button when finished");
    display.display();
}

void DisplayTime::Send_Sequence(){
    display.clearDisplay();
    display.setTextSize(2);             // Normal 1:1 pixel scale
    display.setTextColor(SSD1306_WHITE);        // Draw white text
    display.setCursor(0,0);             // Start at top-left corner
    display.println(F("Sending IR"));
    display.println(F("Sequence"));
    display.display();
}

void DisplayTime::Wifi_Connecting(){
    display.clearDisplay();
    display.setTextSize(2);             // Normal 1:1 pixel scale
    display.setTextColor(SSD1306_WHITE);        // Draw white text
    display.setCursor(0,0);             // Start at top-left corner
    display.println(F("Connecting"));
    display.println(F("To WiFi"));
    display.display();
}