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
#ifndef _OWI_POLLED_H_
#define _OWI_POLLED_H_

#include "../OWI_common/OWIdefs.h"

/*****************************************************************************
 User defines
*****************************************************************************/

/*! \brief  Use internal pull-up resistor on 1-Wire buses.
 *
 *  If this symbol is defined, the internal pull-up resister on the GPIO pins
 *  of the AVR will be used to generate the necessary pull-up on the bus. If
 *  an external pull-up resistor is used, comment this define.
 */
#define OWI_USE_INTERNAL_PULLUP

// Port configuration registers for 1-Wire buses.
// Make sure that all three registers belong to the same port.
#define OWI_PORT VPORTA.OUT        //!< 1-Wire PORT Data register.
#define OWI_IN VPORTA.IN           //!< 1-Wire Input pin register.
#define OWI_DDR PORTA.DIR          //!< 1-Wire Data direction register.
#define OWI_PINCONF PORTA.PIN1CTRL //!< 1-Wire Pin config register
#define OWI_PIN PIN1_bm            //!< 1-wire Pin
// Comment out if alternate pin location is not used
#define USE_ALTERNATE_PIN

#ifndef F_CPU
#warning "F_CPU not defined"
#define F_CPU 10000000L
#endif

#define BAUD_115200 (uint16_t)((64L * F_CPU) / (16L * 115200L))
#define BAUD_9600 (uint16_t)((64L * F_CPU) / (16L * 9600L))

#endif
