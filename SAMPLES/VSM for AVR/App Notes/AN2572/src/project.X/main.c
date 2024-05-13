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
#include  <util/delay.h>

#define RES_10BIT 0x3FF
#define RES_12BIT 0xFFF

#define MAX_VOL 2.5

#define ADC_CHANNEL 5

uint16_t adc_result;
float vol_over, vol_single;

uint16_t ADC_0_get_conversion(int channel)
{
   // Start conversion
   ADC0.MUXPOS  = channel;
	ADC0.COMMAND = ADC_STCONV_bm;
	while ((ADC0.INTFLAGS & ADC_RESRDY_bm) == 0);
	uint16_t res = ADC0.RES;
	ADC0.INTFLAGS |= ADC_RESRDY_bm;
	return res;
}

/*********************************process_single_sampled()*******************************************
ADC sample accumulator has been configured to 1.
ADC result of only one sample is read.
****************************************************************************************************/

void process_single_sampled()
{
	ADC0.CTRLB = ADC_SAMPNUM_ACC1_gc;

	adc_result = ADC_0_get_conversion(ADC_CHANNEL); // read channel 5
	vol_single = (adc_result * MAX_VOL) / RES_10BIT;
}
/***************************************process_oversampled()********************************************
          For 12 bit ADc result: Read 16 samples and then right shift by 2

         To increase the resolution, for each additional bit of ADC resolution, n, the signal must be
         oversampled four times( 4^n). To achieve 12 bit ADC, need 2 bits additional resolution.
         Hence signal has to be sampled 4^2( 4 to the power 2 ),
         i.e. 16 times more samples. So Sample Accumulator is configured to 16 samples.

         The scale factor, sf, given by sf = 2^n, is the factor, which is
         the sum of 4^n samples should be divided by, to scale the result properly.
         n is the desired number of extra bits.
         In this example 2 extra bits are chosen. Hence the value
         is 4, i.e. 2^2. Divide result by 4 or right shift by 2.
***********************************************************************************************************/
void process_oversampled()
{
	ADC0.CTRLB = ADC_SAMPNUM_ACC16_gc; // Sample Accumulator 16 samples

	adc_result = ADC_0_get_conversion(ADC_CHANNEL); // read channel 5
	adc_result = adc_result >> 2;                   // right shift by 2
	vol_over   = (adc_result * MAX_VOL) / RES_12BIT;
}

/***********************************send_USART(char *d)****************************************
send character through USART until null char.
***********************************************************************************************/
void send_USART(char *s)
{
	while (*s != 0) 
	{
      while ((USART0.STATUS & USART_DREIF_bm) == 0);
      USART0.TXDATAL = *s;
		s++;
	}
}

/************************************send_data(float number)*********************************************
Convert float number (ADC result) to string and send to send_USART()
**********************************************************************************************************/
void send_data(float number)
{
	char string[50];

	dtostrf(number, 1, 4, string);
	send_USART(string);
}

/********************************************MAIN******************************************************************
Initializes drivers ADC, VREF, USART.
Single sampled and Oversampled ADC result is read and measured voltage is
sent through USART to the serial terminal of PC.
*********************************************************************************************************************/

void init_adc()
{
   ADC0.CTRLC = ADC_PRESC_DIV4_gc      /* CLK_PER divided by 4 */
	             | ADC_REFSEL_INTREF_gc /* Internal reference */
	             | 0 << ADC_SAMPCAP_bp; /* Sample Capacitance Selection: disabled */

   ADC0.CTRLA = 1 << ADC_ENABLE_bp     /* ADC Enable: enabled */
	             | 0 << ADC_FREERUN_bp  /* ADC Freerun mode: disabled */
	             | ADC_RESSEL_10BIT_gc  /* 10-bit mode */
	             | 0 << ADC_RUNSTBY_bp; /* Run standby mode: disabled */
}

#define USART0_BAUD_RATE(BAUD_RATE) ((float)(3333333 * 64 / (16 * (float)BAUD_RATE)) + 0.5)

void init_usart()
{
   USART0.BAUD = (uint16_t)USART0_BAUD_RATE(9600); /* set baud rate register */
   USART0.CTRLB = 0 << USART_MPCM_bp       /* Multi-processor Communication Mode: disabled */
	               | 0 << USART_ODME_bp     /* Open Drain Mode Enable: disabled */
	               | 0 << USART_RXEN_bp     /* Receiver Enable: disabled */
	               | USART_RXMODE_NORMAL_gc /* Normal mode */
	               | 0 << USART_SFDEN_bp    /* Start Frame Detection Enable: disabled */
	               | 1 << USART_TXEN_bp;    /* Transmitter Enable: enabled */
}

void init_vref()
{
   VREF_CTRLA = VREF_ADC0REFSEL_2V5_gc     /* Voltage reference at 2.5V */
	             | VREF_DAC0REFSEL_0V55_gc; /* Voltage reference at 0.55V */

	VREF_CTRLB = 1 << VREF_ADC0REFEN_bp    /* ADC0 reference enable: enabled */
	             | 0 << VREF_DAC0REFEN_bp; /* DAC0/AC0 reference enable: disabled */
}

int main(void)
{
   // Initialize pins
   PORTA.DIR = 0x00;    // PA5(ADC0ch5)-in   
   PORTB.OUT = 0xFF;
   PORTB.DIR = (1<<2);  // PB2(USART0TX)-out, PB3(USART0RX)-in
   
	// Initializes MCU, drivers and middleware
	init_vref();
	init_adc();
	init_usart();
	
	while (1) {

		process_oversampled();
		process_single_sampled();

		send_USART("Single Sampled: ");
		send_data(vol_single);
		send_USART("V\r\n");
		send_USART("Over Sampled: ");
		send_data(vol_over);
		send_USART("V\r\n\r\n");

		_delay_ms(1000);
	}
}