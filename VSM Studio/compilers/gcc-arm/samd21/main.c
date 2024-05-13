#include <samd21.h>

// Config Source code for XC32 compiler.
// USER_WORD_0
#pragma config NVMCTRL_BOOTPROT = 7
#pragma config NVMCTRL_EEPROM_SIZE = 0
#pragma config BOD33USERLEVEL = 0x0 // Enter Hexadecimal value
#pragma config BOD33_EN = DISABLED
#pragma config BOD33_ACTION = NONE
#pragma config WDT_ENABLE = DISABLED
#pragma config WDT_ALWAYSON = DISABLED
#pragma config WDT_PER = CYC8
#pragma config WDT_WINDOW_0 = CLEAR

// USER_WORD_1
#pragma config WDT_WINDOW_1 = 0x0 // Enter Hexadecimal value
#pragma config WDT_EWOFFSET = CYC8
#pragma config WDT_WEN = DISABLED
#pragma config BOD33_HYST = DISABLED
#pragma config NVMCTRL_REGION_LOCKS = 0xFFFF // Enter Hexadecimal value

int main(void)
{
	for(;;);
}
