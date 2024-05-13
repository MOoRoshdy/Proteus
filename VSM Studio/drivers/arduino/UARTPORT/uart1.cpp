/* UART1 object */

#include "uartport.h"

#if defined(HAVE_HWSERIAL1) || defined(GCM_SERCOM1_CORE)

UARTPORT Uart1 (Serial1);

#endif
