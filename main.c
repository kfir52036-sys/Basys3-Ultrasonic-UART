#include "xparameters.h"
#include "xgpio.h"
#include "xuartlite_l.h"

XGpio Ultrasonic_Gpio;

void safe_uart_send(char c) {
    while (XUartLite_ReadReg(XPAR_AXI_UARTLITE_0_BASEADDR, XUL_STATUS_REG_OFFSET) & XUL_SR_TX_FIFO_FULL);
    XUartLite_WriteReg(XPAR_AXI_UARTLITE_0_BASEADDR, XUL_TX_FIFO_OFFSET, c);
}

void uart_print_string(char *str) {
    while (*str) {
        safe_uart_send(*str);
        str++;
    }
}

void uart_print_num(u32 num) {
    char str[10];
    int i = 0;

    if (num == 0) {
        safe_uart_send('0');
    } else {
        while (num > 0) {
            str[i++] = (num % 10) + '0';
            num /= 10;
        }
        for (int j = i - 1; j >= 0; j--) {
            safe_uart_send(str[j]);
        }
    }
}

int main() {
    int status = XGpio_Initialize(&Ultrasonic_Gpio, XPAR_AXI_GPIO_0_DEVICE_ID);
    if (status != XST_SUCCESS) {
        return 1;
    }

    volatile u32 raw_time = 0;
    volatile u32 distance = 0;

    while(1) {
        raw_time = XGpio_DiscreteRead(&Ultrasonic_Gpio, 1);

        distance = raw_time / 58;

        uart_print_string("Distance: ");
        uart_print_num(distance);
        uart_print_string(" cm\r\n");

        for(volatile int i = 0; i < 6000000; i++);
    }

    return 0;
}
