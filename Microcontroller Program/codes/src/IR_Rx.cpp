#include <Arduino.h>
#include <assert.h>
#include <IRrecv.h>
#include <IRsend.h>
#include <IRremoteESP8266.h>
#include <IRac.h>
#include <IRtext.h>
#include <IRutils.h>
#include "IR_Rx.h"

#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>

#ifndef TimeAlarms_h
#include <TimeAlarms.h>
#endif

#ifndef DisplayTime_H
#include "DisplayTime.h"
DisplayTime Display(true);
#endif

unsigned long _currentMillis = 0;
unsigned long _startMillis = 0;
unsigned long _timing = 0;
uint16_t Freq = 38000;

const uint16_t kIrLedPin = 33;
IRsend irsend(kIrLedPin);


IR_Rx::IR_Rx(bool _Setup){


    
}

// pin used to recieve IR Data
const uint16_t kRecvPin = 34;  // 14 on a ESP32-C3 causes a boot loop.

const uint16_t kCaptureBufferSize = 1024;

// kTimeout is the Nr. of milli-Seconds of no-more-data before we consider a
// message ended.
// This parameter is an interesting trade-off. The longer the timeout, the more
// complex a message it can capture. e.g. Some device protocols will send
// multiple message packets in quick succession, like Air Conditioner remotes.
// Air Coniditioner protocols often have a considerable gap (20-40+ms) between
// packets.
// The downside of a large timeout value is a lot of less complex protocols
// send multiple messages when the remote's button is held down. The gap between
// them is often also around 20+ms. This can result in the raw data be 2-3+
// times larger than needed as it has captured 2-3+ messages in a single
// capture. Setting a low timeout value can resolve this.
// So, choosing the best kTimeout value for your use particular case is
// quite nuanced. Good luck and happy hunting.
// NOTE: Don't exceed kMaxTimeoutMs. Typically 130ms.

// Some A/C units have gaps in their protocols of ~40ms. e.g. Kelvinator
// A value this large may swallow repeats of some protocols


// Suits most messages, while not swallowing many repeats.
const uint8_t kTimeout = 200;

// Alternatives:
// const uint8_t kTimeout = 90;
// Suits messages with big gaps like XMP-1 & some aircon units, but can
// accidentally swallow repeated messages in the rawData[] output.
//
// const uint8_t kTimeout = kMaxTimeoutMs;
// This will set it to our currently allowed maximum.
// Values this high are problematic because it is roughly the typical boundary
// where most messages repeat.
// e.g. It will stop decoding a message and start sending it to serial at
//      precisely the time when the next message is likely to be transmitted,
//      and may miss it.

// Set the smallest sized "UNKNOWN" message packets we actually care about.
// This value helps reduce the false-positive detection rate of IR background
// noise as real messages. The chances of background IR noise getting detected
// as a message increases with the length of the kTimeout value. (See above)
// The downside of setting this message too large is you can miss some valid
// short messages for protocols that this library doesn't yet decode.
//
// Set higher if you get lots of random short UNKNOWN messages when nothing
// should be sending a message.
// Set lower if you are sure your setup is working, but it doesn't see messages
// from your device. (e.g. Other IR remotes work.)
// NOTE: Set this value very high to effectively turn off UNKNOWN detection.
const uint16_t kMinUnknownSize = 12;

// How much percentage lee way do we give to incoming signals in order to match
// it?
// e.g. +/- 25% (default) to an expected value of 500 would mean matching a
//      value between 375 & 625 inclusive.
// Note: Default is 25(%). Going to a value >= 50(%) will cause some protocols
//       to no longer match correctly. In normal situations you probably do not
//       need to adjust this value. Typically that's when the library detects
//       your remote's message some of the time, but not all of the time.
const uint8_t kTolerancePercentage = kTolerance;  // kTolerance is normally 25%

// Legacy (No longer supported!)
//
// Change to `true` if you miss/need the old "Raw Timing[]" display.
#define LEGACY_TIMING_INFO false
// ==================== end of TUNEABLE PARAMETERS ====================

// Use turn on the save buffer feature for more complete capture coverage.
IRrecv irrecv(kRecvPin, kCaptureBufferSize, kTimeout, true);
decode_results results;  // Somewhere to store the results

// This section of code runs only once at start-up.
void IR_Rx::setup() {

  for(int iteration = 0; iteration < 16; iteration++){
    IR_Data_Timing[iteration] = 0;
    Serial.println("Writing 0's to the rest of the arrays");
    Serial.print("Writing at location: ");
    Serial.println(iteration);

    for(int i = 0; i<67; i++){
      IR_Data[iteration][i] = 0;
    }

    IR_Data_Length[iteration] = 0;
  }

  Serial.println("Erasing power button");
  for(int i = 0; i < 67; i++){
    Power_Button[i] = 0;
  }

  while (!Serial)  // Wait for the serial connection to be establised.
    delay(50);
  // Perform a low level sanity checks that the compiler performs bit field
  // packing as we expect and Endianness is as we expect.
  assert(irutils::lowLevelSanityCheck() == 0);

  Serial.printf("\n" D_STR_IRRECVDUMP_STARTUP "\n", kRecvPin);
#if DECODE_HASH
  // Ignore messages with less than minimum on or off pulses.
  irrecv.setUnknownThreshold(kMinUnknownSize);
#endif  // DECODE_HASH
  irrecv.setTolerance(kTolerancePercentage);  // Override the default tolerance.
  irrecv.enableIRIn();  // Start the receiver
}


unsigned long gettiming(){
  _currentMillis = millis();  //get the current time 
  _timing = _currentMillis - _startMillis;
  _startMillis = _currentMillis;  //IMPORTANT to save the start time of the current LED brightness
      
  return _timing;
} 


// The repeating section of the code
void IR_Rx::decode(bool _Record) {
    delay(1000);
    _currentMillis = millis();

    for(int iteration = 0; iteration < 16;){
        Display.IR_Record(true, iteration);

        while(digitalRead(13) == true && iteration <16){
            IR_Data_Timing[iteration] = 0;
            Serial.println("Writing 0's to the rest of the arrays");
            Serial.print("Writing at location: ");
            Serial.println(iteration);
            for(int i = 0; i<67; i++){
              IR_Data[iteration][i] = 0;
            }

            IR_Data_Length[iteration] = 0;
            iteration++;
        }

        // Check if the IR code has been received.
        if (irrecv.decode(&results)) {
            // Display a crude timestamp.
            uint32_t now = millis();
            Serial.printf(D_STR_TIMESTAMP " : %06u.%03u\n", now / 1000, now % 1000);
            // Check if we got an IR message that was to big for our capture buffer.
            if (results.overflow)
                Serial.printf(D_WARN_BUFFERFULL "\n", kCaptureBufferSize);
            // Display the library version the message was captured with.
            Serial.println(D_STR_LIBRARY "   : v" _IRREMOTEESP8266_VERSION_STR "\n");
            // Display the tolerance percentage if it has been change from the default.
            if (kTolerancePercentage != kTolerance)
                Serial.printf(D_STR_TOLERANCE " : %d%%\n", kTolerancePercentage);
            // Display the basic output of what we found.
            Serial.print(resultToHumanReadableBasic(&results));
            // Display any extra A/C info if we have it.
            String description = IRAcUtils::resultAcToString(&results);
            if (description.length()) Serial.println(D_STR_MESGDESC ": " + description);
            yield();  // Feed the WDT as the text output can take a while to print.
            Serial.println(resultToSourceCode(&results));
            Serial.println();    // Blank line between entries
            
            yield();             // Feed the WDT (again)

            uint16_t *raw_array = resultToRawArray(&results);
            // Find out how many elements are in the array.
            uint16_t length = getCorrectedRawLength(&results);
            // Resume capturing IR messages. It was not restarted until after we sent
            // the message so we didn't capture our own message.
            irrecv.resume();
            // Deallocate the memory allocated by resultToRawArray().
           
            
            //uint16_t test = results.decodedRawData; 
            //Serial.println(test);

             IR_Data_Timing[iteration] = gettiming();
              Serial.print("The time between button presses (in ms) is: ");
              Serial.println(IR_Data_Timing[iteration]);
              IR_Data_Length[iteration] = length;
              Serial.print("IR Data Length: ");
              Serial.println(IR_Data_Length[iteration]);

              for(int i = 0; i < 67; i++){
                IR_Data[iteration][i] = raw_array[i];
              }

              delete [] raw_array;

              Serial.print("IR Data = ");

              for(int i = 0; i < 67; i++){
                Serial.print(IR_Data[iteration][i]);
                Serial.print(", ");
              }
              
            
        
        Serial.println();
        Serial.println("***********************************************************************");
        Serial.println();

        /* if(digitalRead(13) == 1)
          break; */
        
        delay(500);
        iteration++;
        }

    }

  delay(1000);
  _Recorded_Sequence = true;
}


void IR_Rx::send(){
  if (_Recorded_Sequence == true);
    Display.Send_Sequence();

    for (int i = 0; i < 16 ; i++){
        uint16_t *IR_Raw = IR_Data[i];
        irsend.sendRaw(IR_Raw, 67, Freq);
        Alarm.delay(IR_Data_Timing[i]);
    }
    Alarm.delay(5000);
    send_Power_Button();
}

void IR_Rx::send_Power_Button(){
  uint16_t *Pwr_Btn_Raw = Power_Button;
  irsend.sendRaw(Pwr_Btn_Raw, 67, Freq);
}

void IR_Rx::Record_Power_Button(){
   Serial.println("Ready to Record Power Button");

   Display.IR_Record_PWR_BTN();
   
   while(_Recorded == false){
           if (irrecv.decode(&results)) {
            uint32_t now = millis();
            Serial.printf(D_STR_TIMESTAMP " : %06u.%03u\n", now / 1000, now % 1000);
            if (results.overflow)
                Serial.printf(D_WARN_BUFFERFULL "\n", kCaptureBufferSize);
            Serial.println(D_STR_LIBRARY "   : v" _IRREMOTEESP8266_VERSION_STR "\n");
            if (kTolerancePercentage != kTolerance)
                Serial.printf(D_STR_TOLERANCE " : %d%%\n", kTolerancePercentage);
            String description = IRAcUtils::resultAcToString(&results);
            if (description.length()) Serial.println(D_STR_MESGDESC ": " + description);
            yield();
            Serial.println(resultToSourceCode(&results));
            Serial.println();    // Blank line between entries
            yield();             // Feed the WDT (again)
            uint16_t *power_raw_array = resultToRawArray(&results);
            //uint16_t power_length = getCorrectedRawLength(&results);
            for(int i = 0; i<67; i++){
              Power_Button[i] = power_raw_array[i];
            }
            irrecv.resume();
            _Recorded = true;
          }
    }

}