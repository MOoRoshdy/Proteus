/***********************************************************************************************************************************************************
This application demonstrates the noise countermeasures for ADC applications.
Application is 'Periodic noise generation and noise filtering with sample accumulation, sampling delay, automatic
sampling delay'.

In this application, PWM noise is generated using timer TCA. This PWM signal is added as a noise to the 'signal to be
measured'. A DC signal from potentiometer is used as 'signal to be measured'. This mixed signal ( signal + noise signal)
is given as input signal to ADC. It will be sampled and the ADC result value is sent through USART to the serial
terminal of Data Visualizer and graph of ADC samples is plotted in the Data Visualizer. Different graphs with different
noise filtering configurations such as sample accumulation for 1 or 64 samples, sampling delay, automatic sampling delay
are plotted.

For more details and HW connection please refer Application note: Noise countermeasures for ADC applications.
Refer figure 'Adding noise to the signal circuit' from application note for signal mixing.
*************************************************************************************************************************************************************/

#include "mcc_generated_files/mcc.h"
#include  <util/delay.h>

#define HARMONIC_NOISE                                                                                                 \
	1 /*  1: Generate PWM signal as a periodic noise.                                                                  \
	      0: Do not generate PWM signal.                                                                 */

#define PWM_FRQ                                                                                                        \
	62000 /*  Harmonic noise frequency in Hz.																   */

#define ADC_64X_ACCUMULATOR_ENABLE                                                                                     \
	1 /*  Configuration of consecutive sample accumulation                                                             \
	      1: 64 consecutive sample accumulation                                                                        \
	      0: No multiple sample accumulation (only 1 ADC sample accumulation)                                          \
	      Please note this example shows result graph with ADC sample accumulation of 1 sample or 64 samples only .    \
	      tinyAVR 1-series supports sample accumulation of 1,2,4,8,16,32,64. For sample accumulation other than 1 or   \
	     64, code needs to be changed accordingly (register ADC0.CTRLB and variable result_shift_cnt needs to be                   \
	     changed accordingly) */

#define SAMPLING_DELAY                                                                                                 \
	0 /*  0       : No sampling delay between consecutive samples in one single burst.                                 \
	      1 to 15 : Configures the sampling delay between consecutive samples in one single burst. The                 \
	                delay is expressed as CLK_ADC cycles. 1 being delay of 1 cycle.                      */

#define ENABLE_ASDV                                                                                                    \
	1 /*  1: Enable the automatic sampling delay between consecutive samples in one single burst.                      \
	      0: Do not enable automatic sampling delay variation                                            */

#define ADC_CHANNEL     \
	5 /*   read ADC CHANNEL 5   : pin PA5                                                                 */


void init_adc()
{
   ADC0.CTRLC = ADC_PRESC_DIV4_gc      /* CLK_PER divided by 4 */
	             | ADC_REFSEL_INTREF_gc /* Internal reference */
	             | 0 << ADC_SAMPCAP_bp; /* Sample Capacitance Selection: disabled */

   ADC0.MUXPOS = ADC_MUXPOS_AIN5_gc; /* ADC input pin 5 */

   ADC0.CTRLA = 1 << ADC_ENABLE_bp     /* ADC Enable: enabled */
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

void init_tca()
{
   TCA0.SINGLE.CTRLB = 0 << TCA_SINGLE_ALUPD_bp            /* Auto Lock Update: disabled */
	                    | 1 << TCA_SINGLE_CMP0EN_bp         /* Setting: enabled */
	                    | 0 << TCA_SINGLE_CMP1EN_bp         /* Setting: disabled */
	                    | 0 << TCA_SINGLE_CMP2EN_bp         /* Setting: disabled */
	                    | TCA_SINGLE_WGMODE_SINGLESLOPE_gc; /*  */
	                    
   TCA0.SINGLE.CTRLA = TCA_SINGLE_CLKSEL_DIV1_gc           /* System Clock */
	                    | 1 << TCA_SINGLE_ENABLE_bp;        /* Module Enable: enabled */
}

void USART_0_write(uint8_t dt)
{
   while ((USART0.STATUS & USART_DREIF_bm) == 0);
   USART0.TXDATAL = dt;
}

void sendString(char *s)
{
	while (*s != 0) 
	{
	   USART_0_write(*s);
		s++;
	}
}

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

void PWM_TCA_load_duty_cycle_ch0(uint16_t duty_value)
{
	TCA0.SINGLE.CMP0BUF = duty_value;
}

void PWM_TCA_load_top(uint16_t top_value)
{
	TCA0.SINGLE.PERBUF = top_value;
}


#define MAX_VOL 2.5
#define RES_10BIT 0x3FF

uint16_t adc_result;
uint8_t  result_shift_cnt;

/**********************************************************************************************************************************************************
ADC result has been read and it has been sent through USART.
For Data Streamer protocol, START byte is 0x03 and END byte is 0xFC;
Data streamer protocol has been used to send ADC result to serial terminal so that one 16 bit value will be used to plot
the graph in Data Visualizer. For more details on Data Streamer and Graph, refer section: "Appendix A: Plotting graph in
Data Visualizer" from application note:Noise countermeasures for ADC applications. or
  http://content.alexandria.atmel.com/webhelp/GUID-F897CF19-8EAC-457A-BE11-86BDAC9B59CF-en-US-3/index.html?GUID-A6CB54F0-041D-4B12-A3E1-97602C36ED7B
***********************************************************************************************************************************************************/

void Transmit_Sample()
{
	USART_0_write(0x03);                       /* Data Streamer protocol START */
	USART_0_write((uint8_t)adc_result);        /* ADC sample LSB */
	USART_0_write((uint8_t)(adc_result >> 8)); /* ADC sample MSB */
	USART_0_write(0xFC);                       /* Data Streamer protocol END */
}

int main(void)
{
   // Initialize pins
   PORTA.DIR = 0x00;    // PA5(ADC0ch5)-in   
   PORTB.OUT = 0xFF;
   PORTB.DIR = (1<<2)|(1<<0);  // PB2(USART0TX)-out, PB0(TCA0CH0)-out

   init_adc();
   init_usart();
   init_vref();
   
	/*  Harmonic noise is enabled so generate PWM using TCA at pin PB0*/
#if HARMONIC_NOISE
   init_tca();
	PWM_TCA_load_top((F_CPU / PWM_FRQ) - 1);
	PWM_TCA_load_duty_cycle_ch0(((F_CPU / PWM_FRQ) - 1) / 2); /*  50 % duty cycle */
#endif

	ADC0.CTRLD |= SAMPLING_DELAY;

#if ENABLE_ASDV
	ADC0.CTRLD |= 1 << ADC_ASDV_bp;
#endif

#if ADC_64X_ACCUMULATOR_ENABLE
	ADC0.CTRLB       = ADC_SAMPNUM_ACC64_gc;
	result_shift_cnt = 6;
#else
	ADC0.CTRLB       = ADC_SAMPNUM_ACC1_gc;
	result_shift_cnt = 0;
#endif

	char string[50];
	float avg;

	while (1) {

      adc_result = ADC_0_get_conversion(ADC_CHANNEL);
      adc_result >>= result_shift_cnt;
      
      sendString("Vavg = ");
    	dtostrf((adc_result * MAX_VOL) / RES_10BIT, 1, 4, string);
      sendString(string);
    	sendString(" V\r\n");

		//Transmit_Sample();
	}
}
