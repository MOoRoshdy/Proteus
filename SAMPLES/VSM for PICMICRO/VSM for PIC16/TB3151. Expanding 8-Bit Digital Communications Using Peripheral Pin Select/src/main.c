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

#define PIN_B1          0x09
#define PIN_C7          0x17
#define SIG_UART_TX     0x10

void switchToTerminal(int term_idx)
{
    // Wait for completion
    while(!EUSART_is_tx_done());
    
    switch (term_idx)
    {
    case 0:
        LATCbits.LATC0 = 1;             // Ensure output lines idle high
        SP1BRGH = 0x01;
        SP1BRGL = 0xA0;                 // 19.2K @ 32MHz
        RXPPS = PIN_B1;                 // PIC RX ON RB1
        RB1PPS = 0;
        RC0PPS = SIG_UART_TX;           // PIC TX ON RC0
        RC6PPS = 0;
        break;
    case 1:
        LATCbits.LATC6 = 1;             // Ensure output lines idle high
        SP1BRGH = 0x00;
        SP1BRGL = 0x8A;                 // 57.6K @ 32MHz
        RXPPS = PIN_C7;                 // PIC RX ON RC7
        RC7PPS = 0;
        RC6PPS = SIG_UART_TX;           // PIC TX ON RC6
        RC0PPS = 0;
    }
}

void main(void)
{
    // initialize the device
    SYSTEM_Initialize();

    // When using interrupts, you need to set the Global and Peripheral Interrupt Enable bits
    // Use the following macros to:

    // Enable the Global Interrupts
    //INTERRUPT_GlobalInterruptEnable();

    // Enable the Peripheral Interrupts
    //INTERRUPT_PeripheralInterruptEnable();

    // Disable the Global Interrupts
    //INTERRUPT_GlobalInterruptDisable();

    // Disable the Peripheral Interrupts
    //INTERRUPT_PeripheralInterruptDisable();

    int terminal_idx = 0;
    while (1)
    {
        switchToTerminal(terminal_idx);
        printf("Terminal %d\r\n", terminal_idx);
        
        // Switch to the next terminal
        terminal_idx ^= 1;
        
        // Some delay after whole loop
        if (!terminal_idx)
        {
            for(long int i = 1000; i; i--);
        }
    }
}
/**
 End of File
*/