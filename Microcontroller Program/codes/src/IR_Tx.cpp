/* #include "IR_Tx.h"
#include <arduino.h>
#include <IRsend.h>
#include <IRrecv.h>
#include <IRremoteESP8266.h>
#include <IRutils.h>

#ifndef IR_Rx_H
#include "IR_Rx.h"
IR_Rx Recieve_IR(true);
#endif

uint16_t IR_Data;
uint16_t IR_Data_Length;
uint16_t Freq = 38000;

IRsend irsend(33); //pin 33 is the Tx pin

IR_Tx::IR_Tx(bool _Setup){
    
}

void IR_Tx::send(){

    for (int i = 0; i < 16 ; i++){
        uint16_t *IR_Raw = Recieve_IR.IR_Data[i];
        irsend.sendRaw(IR_Raw, 67, Freq);
        delay(Recieve_IR.IR_Data_Timing[i]);
    }
    


 } */