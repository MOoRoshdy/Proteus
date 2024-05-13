/* UART object */

#include "uartport.h"

#if defined(BOARD_HAVE_USART1) || defined(GCM_SERCOM0_CORE)

UARTPORT Uart (Serial);

#endif
