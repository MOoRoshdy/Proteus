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
#include "OWIcrc.h"
#include "OWIdefs.h"

/*! \brief  Compute the CRC8 value of a data set.
 *
 *  This function will compute the CRC8 or DOW-CRC of inData using seed
 *  as inital value for the CRC.
 *
 *  \param  inData  One byte of data to compute CRC from.
 *
 *  \param  seed    The starting value of the CRC.
 *
 *  \return The CRC8 of inData with seed as initial value.
 *
 *  \note   Setting seed to 0 computes the crc8 of the inData.
 *
 *  \note   Constantly passing the return value of this function
 *          As the seed argument computes the CRC8 value of a
 *          longer string of data.
 */
unsigned char OWI_ComputeCRC8(unsigned char inData, unsigned char seed)
{
	unsigned char bitsLeft;
	unsigned char temp;

	for (bitsLeft = 8; bitsLeft > 0; bitsLeft--) {
		temp = ((seed ^ inData) & 0x01);
		if (temp == 0) {
			seed >>= 1;
		} else {
			seed ^= 0x18;
			seed >>= 1;
			seed |= 0x80;
		}
		inData >>= 1;
	}
	return seed;
}

/*! \brief  Compute the CRC16 value of a data set.
 *
 *  This function will compute the CRC16 of inData using seed
 *  as inital value for the CRC.
 *
 *  \param  inData  One byte of data to compute CRC from.
 *
 *  \param  seed    The starting value of the CRC.
 *
 *  \return The CRC16 of inData with seed as initial value.
 *
 *  \note   Setting seed to 0 computes the crc16 of the inData.
 *
 *  \note   Constantly passing the return value of this function
 *          As the seed argument computes the CRC16 value of a
 *          longer string of data.
 */
unsigned int OWI_ComputeCRC16(unsigned char inData, unsigned int seed)
{
	unsigned char bitsLeft;
	unsigned char temp;

	for (bitsLeft = 8; bitsLeft > 0; bitsLeft--) {
		temp = ((seed ^ inData) & 0x01);
		if (temp == 0) {
			seed >>= 1;
		} else {
			seed ^= 0x4002;
			seed >>= 1;
			seed |= 0x8000;
		}
		inData >>= 1;
	}
	return seed;
}

/*! \brief  Calculate and check the CRC of a 64 bit ROM identifier.
 *
 *  This function computes the CRC8 value of the first 56 bits of a
 *  64 bit identifier. It then checks the calculated value against the
 *  CRC value stored in ROM.
 *
 *  \param  romvalue    A pointer to an array holding a 64 bit identifier.
 *
 *  \retval OWI_CRC_OK      The CRC's matched.
 *  \retval OWI_CRC_ERROR   There was a discrepancy between the calculated and the stored CRC.
 */
unsigned char OWI_CheckRomCRC(unsigned char *romValue)
{
	unsigned char i;
	unsigned char crc8 = 0;

	for (i = 0; i < 7; i++) {
		crc8 = OWI_ComputeCRC8(*romValue, crc8);
		romValue++;
	}
	if (crc8 == (*romValue)) {
		return OWI_CRC_OK;
	}
	return OWI_CRC_ERROR;
}

