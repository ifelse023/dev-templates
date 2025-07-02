#include "hardware/i2c.h"
#include "lcd.h"
#include "pico/binary_info.h"
#include "pico/stdlib.h"

int main() {
  stdio_init_all();
#if !defined(i2c_default) || !defined(PICO_DEFAULT_I2C_SDA_PIN) ||             \
    !defined(PICO_DEFAULT_I2C_SCL_PIN)
#else
  i2c_init(i2c_default, 100 * 1000);
  gpio_set_function(PICO_DEFAULT_I2C_SDA_PIN, GPIO_FUNC_I2C);
  gpio_set_function(PICO_DEFAULT_I2C_SCL_PIN, GPIO_FUNC_I2C);
  gpio_pull_up(PICO_DEFAULT_I2C_SDA_PIN);
  gpio_pull_up(PICO_DEFAULT_I2C_SCL_PIN);
  // Make the I2C pins available to picotool
  bi_decl(bi_2pins_with_func(PICO_DEFAULT_I2C_SDA_PIN, PICO_DEFAULT_I2C_SCL_PIN,
                             GPIO_FUNC_I2C));

  lcd_init();

  for (;;) {
    for (size_t i = 0; i < 10; ++i) {
      lcd_set_cursor(0, 0);
      lcd_string("Hello");
      lcd_set_cursor(1, 0);
      lcd_string("World!");
      sleep_ms(5000);
      lcd_clear();
    }
  }

#endif
}
