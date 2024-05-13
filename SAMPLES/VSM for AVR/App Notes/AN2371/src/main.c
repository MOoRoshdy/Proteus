/*
 * Machester encoder using USART SPI mode and CCL on ATtiny807
 *
 */
#include <atmel_start.h>
#if __GNUC__
#include <util/delay.h>
#else
#define CCL_LUT0CTRLB CCL_LUTCTRL0B
#define CCL_LUT0CTRLA CCL_LUTCTRL0A
#endif

/*Select manchester mode*/
#define MANCHESTER_G_E_THOMAS
#ifndef MANCHESTER_G_E_THOMAS
#define MANCHESTER_IEEE
#endif

/*Manchester data baud rate*/
#define USART_BAUD 1000UL

/*Define test data*/
#define DATA_SIZE 3
uint8_t tx_buf[DATA_SIZE];
uint8_t data_cnt = 0;

void usart_spi_init(void);
void ccl_init(void);

int main(void)
{
	uint8_t i;

	/* Initializes MCU, drivers and middleware */
	atmel_start_init();
#if __GNUC__
	_delay_ms(1000);
#else
	__delay_cycles(1000000);
#endif
	usart_spi_init();
	ccl_init();

	for (i = 0; i < DATA_SIZE; i++) {
		/*Prepare tx data*/
		tx_buf[i] = i;
#ifdef MANCHESTER_IEEE
		tx_buf[i] ^= 0xff;
#endif
	}

	asm("sei");
	while (1) {
	}
}

/**
 * Initialize USART SPI mode
 **/
void usart_spi_init(void)
{
	/*Master SPI mode 0*/
	USART0_CTRLC = USART_CMODE1_bm | USART_CMODE0_bm | USART_UCPHA_bm;
	USART0_BAUD  = (F_CPU / (USART_BAUD * 2)) << 6;
	/*Enable TX*/
	USART0_CTRLA = USART_DREIE_bm;
	USART0_CTRLB = USART_TXEN_bm;
}

/**
 * Initialize CCl
 **/
void ccl_init(void)
{
	/*USART TXD and XCK as LUT inputs*/
	CCL_LUT0CTRLB = (0x0A << 4) | 0x0A;
	/*XNOR truth table*/
	CCL_TRUTH0    = 0x99; // 0b10011001
	CCL_LUT0CTRLA = CCL_FILTSEL1_bm | CCL_OUTEN_bm | CCL_ENABLE_bm;
	CCL_CTRLA     = CCL_ENABLE_bm;
}

ISR(USART0_DRE_vect)
{
	if (data_cnt < DATA_SIZE) {
		USART0_TXDATAL = tx_buf[data_cnt];
		data_cnt++;
	} else {
		/*Disable the DRE interrupt*/
		USART0_CTRLA = 0;
		data_cnt     = 0;
	}
}
