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
/**
 * Introduction
 * ============
 *
 * This example shows how to use the tinyAVR 1-, and 0-series, and
 * megaAVR 0-series with the USART in one-wire mode. The code here is made
 * to work with the 1-Wire (R) protocol (also refereed to as Dallas 1-wire
 * or one-wire).
 *
 * To run the example follow the steps outlined in the Running the example
 * section. The example requires that a DS18B20 or the older DS1820 temperature
 * sensor is connected to the one-wire bus.
 *
 * The code is written for the ATtiny817 Xplained Pro board but should run
 * equally well on any tinyAVR 1-, and 0-series, and megaAVR 0-series
 * devices. In most cases all that is needed is changing device header file and
 * checking that the correct pin is used. To do this in Atmel Studio pres
 * "Alt+F7". In the menu that aper select "Device" and then "Change Device", Search
 * for the device, select it and pres "OK".
 *
 * In order to adapt this example for different 1-Wire devices the FindFamily()
 * function needs to match a different family ID than DS1820_FAMILY_ID. And functions
 * appropriate for the specific device needs to be added e.g., functions similar to the
 * DS1820_ReadTemperature() function.
 *
 *
 * One-Wire Theory
 * ---------------
 *
 * For one-wire theory see the documentation mentioned in the related documentation
 * section or the wikipedia article on 1-wire: "https://en.wikipedia.org/wiki/1-Wire".
 *
 *
 * Implementation Specific Information
 * -----------------------------------
 *
 * In this example the USART peripheral takes care of the signal timing. It will
 * be safe to handle interrupts while sending and receiving data on the bus.
 * This implementation uses the USART in polled mode.
 *
 * The USART in the tinyAVR 1- and 0-series, and megaAVR 0-series
 * is capable of internally connecting the receive and transmit line together.
 * In addition it has a mode that lets the pin act in open-drain mode.
 * This enables slave devices to pull the line low even if the master is
 * set to hold the line high.
 *
 *
 * Related Documents
 * -----------------
 *
 * This example is the same as can be found with this application note:
 *
 * - AVR318: Dallas 1-Wire master on tinyAVR and megaAVR devices
 * - http://www.microchip.com/wwwappnotes/appnotes.aspx?appnote=en591191
 *
 * Note that the HW modifications mentioned in this application note
 * are not needed for the tinyAVR 1-series, tinyAVR 0-series and megaAVR
 * 0-series.
 *
 * A discussion on the one-wire mode of the USART found on the tinyAVR 1-, and
 * 0-series, and megaAVR 0-series can be found in the folowing application note:
 *
 * - USART in One-Wire Mode
 *
 *
 * Clock
 * -----
 *
 * The internal 20 MHz oscillator, prescaled down to 10 MHz is the main clock
 * source. The baud rate generator in the USART assumes 10 MHz is used.
 *
 *
 * Interface Setting
 * -----------------
 *
 * The following pins are used:
 *  - PA1
 *
 *
 * Running the Example
 * -------------------
 *
 * 1. Press Download Pack and save the .atzip file
 * 2. Import .atzip file into Atmel Studio 7, File->Import->Atmel Start Project.
 * 3. Connect the data pin on the DS18B20 to PA1 and the power and ground pins
 *    to the power and ground on the board.
 * 4. Connect the USB cable to the board and PC.
 * 5. Define F_CPU by pressing "ALT+F7" select "Toolchain" and then "Symbols".
 *    In the "Defined symbols(-D)" select Add Item and copy/paste or write
 *    "F_CPU=10000000"
 * 6. Compile and run the project in Atmel Studio
 * 7. To test that it works place a break point at "PORTB = ~(temperature >> 1);"
 *    and add a watch on "temperature" (right clik on "temperature" and select
 *    "add watch") or monitor PORTB.
 */
#include "mcc_generated_files/mcc.h"
#include  <util/delay.h>
#include  <string.h>
#include "OWI_polled_uart/OWIPolled.h"
#include "OWI_polled_uart/OWIHighLevelFunctions.h"
#include "OWI_polled_uart/OWIBitFunctions.h"
#include "OWI_common/OWIcrc.h"
#include "DS18B20.h"

// Defines used only in code example.
#define DS18B20_ERROR -1000 // Return code. Outside temperature range.
#define SEARCH_SUCCESSFUL 0x00
#define SEARCH_CRC_ERROR 0x01
#define MAX_DEVICES 8 //!< Max number of devices to search for.

/*! \brief  Data type used to hold information about slave devices.
 *
 *  The OWI_device data type holds information about what bus each device
 *  is connected to, and its 64 bit identifier.
 */
typedef struct {
	unsigned char bus;   //!< A bitmask of the bus the device is connected to.
	unsigned char id[8]; //!< The 64 bit identifier.
} OWI_device;

/*! \brief  Perform a 1-Wire search
 *
 *  This function shows how the OWI_SearchRom function can be used to
 *  discover all slaves on the bus. It will also CRC check the 64 bit
 *  identifiers.
 *
 *  \param  devices Pointer to an array of type OWI_device. The discovered
 *                  devices will be placed from the beginning of this array.
 *
 *  \param  len     The length of the device array. (Max. number of elements).
 *
 *  \param  buses   Bitmask of the buses to perform search on.
 *
 *  \retval SEARCH_SUCCESSFUL   Search completed successfully.
 *  \retval SEARCH_CRC_ERROR    A CRC error occured. Probably because of noise
 *                              during transmission.
 */
unsigned char SearchBuses(OWI_device *devices, unsigned char len)
{
	unsigned char  i, j;
	unsigned char  presence;
	unsigned char *newID;
	unsigned char *currentID;
	unsigned char  currentBus;
	unsigned char  lastDeviation;
	unsigned char  numDevices;

	// Initialize all addresses as zero, on bus 0 (does not exist).
	// Do a search on the bus to discover all addresses.
	for (i = 0; i < len; i++) {
		devices[i].bus = 0x00;
		for (j = 0; j < 8; j++) {
			devices[i].id[j] = 0x00;
		}
	}

	// Find the buses with slave devices.
	presence = OWI_DetectPresence();

	numDevices = 0;
	newID      = devices[0].id;

	// Go through all buses with slave devices.
	for (currentBus = 0x01; currentBus; currentBus <<= 1) {
		lastDeviation = 0;
		currentID     = newID;
		if (currentBus & presence) // Devices available on this bus.
		{
			// Do slave search on each bus, and place identifiers and corresponding
			// bus "addresses" in the array.
			do {
				memcpy(newID, currentID, 8);
				OWI_DetectPresence(currentBus);
				lastDeviation           = OWI_SearchRom(newID, lastDeviation, currentBus);
				currentID               = newID;
				devices[numDevices].bus = currentBus;
				numDevices++;
				newID = devices[numDevices].id;
			} while (lastDeviation != OWI_ROM_SEARCH_FINISHED);
		}
	}

	// Go through all the devices and do CRC check.
	for (i = 0; i < numDevices; i++) {
		// If any id has a crc error, return error.
		if (OWI_CheckRomCRC(devices[i].id) != OWI_CRC_OK) {
			return SEARCH_CRC_ERROR;
		}
	}
	// Else, return Successful.
	return SEARCH_SUCCESSFUL;
}

/*! \brief  Find the first device of a family based on the family id
 *
 *  This function returns a pointer to a device in the device array
 *  that matches the specified family.
 *
 *  \param  familyID    The 8 bit family ID to search for.
 *
 *  \param  devices     An array of devices to search through.
 *
 *  \param  size        The size of the array 'devices'
 *
 *  \return A pointer to a device of the family.
 *  \retval NULL    if no device of the family was found.
 */
OWI_device *FindFamily(unsigned char familyID, OWI_device *devices, unsigned char size)
{
	unsigned char i = 0;

	// Search through the array.
	while (i < size) {
		// Return the pointer if there is a family id match.
		if ((*devices).id[0] == familyID) {
			return devices;
		}
		devices++;
		i++;
	}
	// Else, return NULL.
	return NULL;
}

/*! \brief  Read the temperature from a DS1820 temperature sensor.
 *
 *  This function will start a conversion and read back the temperature
 *  from a DS1820 temperature sensor.
 *
 *  \param  bus A bitmask of the bus where the DS1820 is located.
 *
 *  \param  id  The 64 bit identifier of the DS1820.
 *
 *  \return The 16 bit signed temperature read from the DS1820.
 */
signed int DS18B20_ReadTemperature(unsigned char bus, unsigned char *id)
{
	signed int temperature;

	// Reset, presence.
	if (!OWI_DetectPresence(bus)) {
		return DS18B20_ERROR; // Error
	}
	// Match the id found earlier.
	OWI_MatchRom(id, bus);
	// Send start conversion command.
	OWI_SendByte(DS18B20_START_CONVERSION, bus);
	// Wait until conversion is finished.
	// Bus line is held low until conversion is finished.
	while (!OWI_ReadBit(bus)) {
	}
	// Reset, presence.
	if (!OWI_DetectPresence(bus)) {
		return DS18B20_ERROR; // Error
	}
	// Match id again.
	OWI_MatchRom(id, bus);
	// Send READ SCRATCHPAD command.
	OWI_SendByte(DS18B20_READ_SCRATCHPAD, bus);
	// Read only two first bytes (temperature low, temperature high)
	// and place them in the 16 bit temperature variable.
	temperature = OWI_ReceiveByte(bus);
	temperature |= (OWI_ReceiveByte(bus) << 8);

	return temperature;
}

/*! \brief  Example application for the polled drivers.
 *
 *  Example application for the software only and polled UART driver.
 *  This example application will find all devices (upper bounded by MAX_DEVICES)
 *  on the buses defined by BUSES. It then tries to find a DS18B20
 *  device on a bus, and communicate with it to read temperature
 *  This example is intended to show how the polled 1-Wire(R) driver can be used.
 */
int main(void)
{
	static OWI_device   devices[MAX_DEVICES];
	OWI_device *        ds1820;
	volatile signed int temperature = 0;

	// Initialize PORTB as output. Can be used to display values on
	// the LEDs on a STK500 development board.
	PORTB.DIR = 0xff;

	// Set main clock prescaler to div 2. Clock should be running at 10 MHz
	// provided default fuse settings are used for main clock
	_PROTECTED_WRITE(CLKCTRL_MCLKCTRLB, CLKCTRL_PDIV_2X_gc | CLKCTRL_PEN_bm);

	OWI_Init();

	// Do the bus search until all ids are read without crc error.
	while (SearchBuses(devices, MAX_DEVICES) != SEARCH_SUCCESSFUL) {
	}

	// See if there is a DS1820 on a bus.
	ds1820 = FindFamily(DS18B20_FAMILY_ID, devices, MAX_DEVICES);

	// Do something useful with the slave devices in an eternal loop.
	for (;;) {
		// If there is a DS1820 temperature sensor on a bus, read the
		// temperature.
		// The DS1820 must have Vdd pin connected for this code to work.
		if (ds1820 != NULL) {
			temperature = DS18B20_ReadTemperature((*ds1820).bus, (*ds1820).id);
		}

		// Discard lsb of temperature and output to PORTB.
		//PORTB.OUT = ~(temperature >> 1);
		
		// Discard fractional part of temperature and output to PORTB.
		PORTB.OUT = temperature >> 4;
	}
}
