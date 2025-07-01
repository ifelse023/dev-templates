#include "pico/stdlib.h"
#include <stdio.h>

#define PICO_DEFAULT_LED_PIN 15
#define LED_DELAY_MS 1000

void pico_led_init(void) {
  gpio_init(PICO_DEFAULT_LED_PIN);
  gpio_set_dir(PICO_DEFAULT_LED_PIN, GPIO_OUT);
}

void pico_set_led(bool led_on) { gpio_put(PICO_DEFAULT_LED_PIN, led_on); }

int main() {
  stdio_init_all();
  sleep_ms(2000); // Allow USB CDC to initialize

  pico_led_init();

  while (true) {
    pico_set_led(true);
    printf("LED ON\n");
    sleep_ms(LED_DELAY_MS);

    pico_set_led(false);
    printf("LED OFF\n");
    sleep_ms(LED_DELAY_MS);
  }
}
