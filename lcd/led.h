#ifndef LED_H
#define LED_H

#include <stdbool.h>

int led_on(void);
int led_off(void);

int pico_led_init(void);

#endif // LED_H
