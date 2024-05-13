/**
  Generated Main Source File

  Company:
    Microchip Technology Inc.

  File Name:
    main.c

  Summary:
    This is the main file generated using PIC10 / PIC12 / PIC16 / PIC18 MCUs

  Description:
    This header file provides implementations for driver APIs for all modules selected in the GUI.
    Generation Information :
        Product Revision  :  PIC10 / PIC12 / PIC16 / PIC18 MCUs - 1.81.7
        Device            :  PIC16F18877
        Driver Version    :  2.00
*/

/*
    (c) 2018 Microchip Technology Inc. and its subsidiaries. 
    
    Subject to your compliance with these terms, you may use Microchip software and any 
    derivatives exclusively with Microchip products. It is your responsibility to comply with third party 
    license terms applicable to your use of third party software (including open source software) that 
    may accompany Microchip software.
    
    THIS SOFTWARE IS SUPPLIED BY MICROCHIP "AS IS". NO WARRANTIES, WHETHER 
    EXPRESS, IMPLIED OR STATUTORY, APPLY TO THIS SOFTWARE, INCLUDING ANY 
    IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY, AND FITNESS 
    FOR A PARTICULAR PURPOSE.
    
    IN NO EVENT WILL MICROCHIP BE LIABLE FOR ANY INDIRECT, SPECIAL, PUNITIVE, 
    INCIDENTAL OR CONSEQUENTIAL LOSS, DAMAGE, COST OR EXPENSE OF ANY KIND 
    WHATSOEVER RELATED TO THE SOFTWARE, HOWEVER CAUSED, EVEN IF MICROCHIP 
    HAS BEEN ADVISED OF THE POSSIBILITY OR THE DAMAGES ARE FORESEEABLE. TO 
    THE FULLEST EXTENT ALLOWED BY LAW, MICROCHIP'S TOTAL LIABILITY ON ALL 
    CLAIMS IN ANY WAY RELATED TO THIS SOFTWARE WILL NOT EXCEED THE AMOUNT 
    OF FEES, IF ANY, THAT YOU HAVE PAID DIRECTLY TO MICROCHIP FOR THIS 
    SOFTWARE.
*/

#include "mcc_generated_files/mcc.h"

// FOSC = 32M, Switch = 500KHz
 
//#define Constant    1638.4
#define Constant    1638400

void calcNCO(uint8_t duty)
{
    uint32_t inc;
    if (duty > 50)
    {
        NCO1CONbits.N1POL = 1;
        CLC1GLS3 = 0x80; 
        inc = Constant / duty;
    } 
    else
    {
        NCO1CONbits.N1POL = 0;
        CLC1GLS3 = 0x40; 
        inc = Constant / (100 - duty);
    }
    
//    inc = duty ? (Constant / duty) : 0x080000;

    //NCO1INCU = (inc >> 16) & 0x0F;
    NCO1INCH = (inc >> 8) & 0xFF;
    NCO1INCL = inc & 0xFF;
}

int getString(char* s)
{
    int cnt = 0;
    char c;
    for(; ; s++, cnt++) {
        c = EUSART_Read();
        if (c < '0' || c > '9') break;
        *s = c;
    };
    *s = 0;
    return cnt;
}

void main(void)
{
    // initialize the device
    SYSTEM_Initialize();

    // default duty
    calcNCO(20);

    //INTERRUPT_GlobalInterruptEnable();
    //INTERRUPT_PeripheralInterruptEnable();
    
    //TMR3_StartTimer();
    NCO1ACCU = 0;
    NCO1ACCH = 0;
    NCO1ACCL = 0;
    
    char sduty[16];
    while (1)
    {
        //__delay_us(25); 
        printf("Enter duty [0..100]: ");
        if (getString(sduty) == 0) continue;
        
        int duty;
        sscanf(sduty, "%d", &duty);
        if (duty > 100) duty = 100; else if (duty < 0) duty = 0;
        calcNCO(duty);
    }
}
/**
 End of File
*/