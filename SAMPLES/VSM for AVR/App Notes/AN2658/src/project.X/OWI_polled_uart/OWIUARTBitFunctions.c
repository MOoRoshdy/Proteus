/**
 * Copyright (c) 2018 Microchip Technology Inc. and its subsidiaries.
 *
 * \asf_license_start
 *
 * \page License
 *
 * Subject to your compliance with these terms, you may use Microchip
 * software and any derivatives exclusively with  Microchip products.
 * It is your responsibility to comply with  third party license terms
 * applicable to your use of third party software (including open
 * source software) that may accompany Microchip software.
 *
 * THIS SOFTWARE IS SUPPLIED BY MICROCHIP "AS IS".NO WARRANTIES, WHETHER
 * EXPRESS, IMPLIED OR STATUTORY, APPLY TO THIS SOFTWARE, INCLUDING ANY
 * IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY, AND FITNESS
 * FOR A PARTICULAR PURPOSE.
 *
 * IN NO EVENT WILL MICROCHIP BE LIABLE FOR ANY INDIRECT, SPECIAL,
 * PUNITIVE, INCIDENTAL OR CONSEQUENTIAL LOSS, DAMAGE, COST OR EXPENSE OF
 * ANY KIND WHATSOEVER RELATED TO THE SOFTWARE, HOWEVER CAUSED, EVEN IF
 * MICROCHIP HAS BEEN ADVISED OF THE POSSIBILITY OR THE DAMAGES ARE
 * FORESEEABLE.TO THE FULLEST EXTENT ALLOWED BY LAW, MICROCHIP'S TOTAL
 * LIABILITY ON ALL CLAIMS IN ANY WAY RELATED TO THIS SOFTWARE WILL NOT
 * EXCEED THE AMOUNT OF FEES, IF ANY, THAT YOU HAVE PAID DIRECTLY TO
 * MICROCHIP FOR THIS SOFTWARE.
 *
 * \asf_license_stop
 */
/*
 * Support and FAQ: visit <a href="http://www.microchip.com/support/hottopics.aspx"></a>
 */
#include "OWIPolled.h"
#include <avr/io.h>

#include "OWIBitFunctions.h"

uint16_t baud_115200;
uint16_t baud_9600;

/*! \brief Initialization of the one wire bus. (Polled UART driver)
 *
 *  This function initializes the 1-Wire bus by configuring the UART,
 *  and the pin.
 */
void OWI_Init()
{
	OWI_PINCONF = PORT_PULLUPEN_bm;
	// Set TX pin as output
	OWI_DDR |= OWI_PIN;
	// Set TX pin high
	OWI_PORT |= OWI_PIN;
#ifdef USE_ALTERNATE_PIN
	// Use alternate pin for UART
	PORTMUX.CTRLB |= PORTMUX_USART0_ALTERNATE_gc;
#endif
	// Enable loop back mode
	USART0.CTRLA = USART_LBME_bm;

	// Enable Open drain mode so line can be pulled low by slave. Enable TX and RX
	USART0.CTRLB = USART_ODME_bm | USART_RXEN_bm | USART_TXEN_bm;

	// Set 8-bit UART and 1 stop bit
	USART0.CTRLC = USART_CHSIZE_8BIT_gc | USART_SBMODE_1BIT_gc;

	// Calculate baud register value for 9600 baud
	// Baud rate compensated with factory stored frequency error
	// Synchronous communication without Auto-baud (Sync Field)
	// 20MHz Clock, and 3V. For different voltage and clock this should be changed
	int8_t  sigrow_value = SIGROW.OSC20ERR3V; // read signed error
	int32_t baud         = BAUD_9600;         // ideal baud rate
	baud *= (1024 + sigrow_value);            // sum resolution + error
	baud /= 1024;                             // divide by resolution
	baud_9600 = (int16_t)baud;

	// Set baud rate to 115200
	// Baud rate compensated with factory stored frequency error
	// Synchronous communication without Auto-baud (Sync Field)
	// 20MHz Clock, and 3V. For different voltage and clock this should be changed
	baud = BAUD_115200;            // ideal baud rate
	baud *= (1024 + sigrow_value); // sum resolution + error
	baud /= 1024;                  // divide by resolution
	baud_115200 = (int16_t)baud;
	USART0.BAUD = baud_115200; // set adjusted baud rate
}

/*! \brief  Write and read one bit to/from the 1-Wire bus. (Polled UART driver)
 *
 *  Writes one bit to the bus and returns the value read from the bus.
 *
 *  \param  outValue    The value to transmit on the bus.
 *
 *  \return The value received by the UART from the bus.
 */
unsigned char OWI_TouchBit(unsigned char outValue)
{
	// Place the output value in the UART transmit buffer, and wait
	// until it is received by the UART receiver.
	USART0.TXDATAL = outValue;
	while (!(USART0.STATUS & USART_RXCIF_bm)) {
	}
	// Set the UART Baud Rate back to 115200kbps when finished.
	USART0.BAUD = baud_115200;

	return USART0.RXDATAL;
}

/*! \brief Write a '1' bit to the bus. (Polled UART DRIVER)
 *
 *  Generates the waveform for transmission of a '1' bit on the 1-Wire
 *  bus.
 */
void OWI_WriteBit1()
{
	OWI_TouchBit(OWI_UART_WRITE1);
}

/*! \brief  Write a '0' to the bus. (Polled UART DRIVER)
 *
 *  Generates the waveform for transmission of a '0' bit on the 1-Wire(R)
 *  bus.
 */
void OWI_WriteBit0()
{
	OWI_TouchBit(OWI_UART_WRITE0);
}

/*! \brief  Read a bit from the bus. (Polled UART DRIVER)
 *
 *  Generates the waveform for reception of a bit on the 1-Wire(R) bus(es).
 *
 *  \return The value read from the bus (0 or 1).
 */
unsigned char OWI_ReadBit()
{
	// Return 1 if the value received matches the value sent.
	// Return 0 else. (A slave held the bus low).
	return (OWI_TouchBit(OWI_UART_READ_BIT) == OWI_UART_READ_BIT);
}

/*! \brief  Send a Reset signal and listen for Presence signal. (Polled
 *  UART DRIVER)
 *
 *  Generates the waveform for transmission of a Reset pulse on the
 *  1-Wire(R) bus and listens for presence signals.
 *
 *  \return non zero value when a presence signal was detected.
 */
unsigned char OWI_DetectPresence()
{
	// Reset UART receiver to clear RXC register.
	USART0.CTRLB &= ~(USART_RXEN_bm);
	USART0.CTRLB |= (USART_RXEN_bm);

	// Set UART Baud Rate to 9600 for Reset/Presence signaling.
	USART0.BAUD = baud_9600;

	// Return 0 if the value received matches the value sent.
	// return 1 else. (Presence detected)
	return (OWI_TouchBit(OWI_UART_RESET) != OWI_UART_RESET);
}
