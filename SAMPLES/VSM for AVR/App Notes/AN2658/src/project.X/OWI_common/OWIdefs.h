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
#ifndef _OWI_DEFS_H_
#define _OWI_DEFS_H_

/****************************************************************************
 ROM commands
****************************************************************************/
#define OWI_ROM_READ 0x33   //!< READ ROM command code.
#define OWI_ROM_SKIP 0xcc   //!< SKIP ROM command code.
#define OWI_ROM_MATCH 0x55  //!< MATCH ROM command code.
#define OWI_ROM_SEARCH 0xf0 //!< SEARCH ROM command code.

/****************************************************************************
 Return codes
****************************************************************************/
#define OWI_ROM_SEARCH_FINISHED 0x00 //!< Search finished return code.
#define OWI_ROM_SEARCH_FAILED 0xff   //!< Search failed return code.

/****************************************************************************
 UART patterns
****************************************************************************/
#define OWI_UART_WRITE1 0xff   //!< UART Write 1 bit pattern.
#define OWI_UART_WRITE0 0x00   //!< UART Write 0 bit pattern.
#define OWI_UART_READ_BIT 0xff //!< UART Read bit pattern.
#define OWI_UART_RESET 0xf0    //!< UART Reset bit pattern.

#endif
