
#include "lcd.h"
#include "hardware/i2c.h"
#include "pico/stdlib.h"
#include <pico/time.h>

// LCD controller address
static const int addr = 0x27;

// Mode flags for lcd_send_byte
#define LCD_COMMAND 0
#define LCD_CHARACTER 1

// Internal helpers
static void i2c_write_byte(uint8_t val) {
#ifdef i2c_default
  i2c_write_blocking(i2c_default, addr, &val, 1, false);
#endif
}

static void lcd_toggle_enable(uint8_t val) {
  sleep_us(600);
  i2c_write_byte(val | 0x04); // LCD_ENABLE_BIT
  sleep_us(600);
  i2c_write_byte(val & ~0x04);
  sleep_us(600);
}

static void lcd_send_byte(uint8_t val, int mode) {
  uint8_t high = mode | (val & 0xF0) | LCD_BACKLIGHT;
  uint8_t low = mode | ((val << 4) & 0xF0) | LCD_BACKLIGHT;

  i2c_write_byte(high);
  lcd_toggle_enable(high);
  i2c_write_byte(low);
  lcd_toggle_enable(low);
}

// Public API
void lcd_init(void) {
  sleep_ms(50); // Wait for LCD to power up
  for (int i = 0; i < 3; ++i)
    lcd_send_byte(0x03, LCD_COMMAND);
  lcd_send_byte(0x02, LCD_COMMAND); // 4-bit mode

  lcd_send_byte(LCD_CMD_FUNCTIONSET | LCD_2LINE, LCD_COMMAND);
  lcd_send_byte(LCD_CMD_DISPLAYCTRL | LCD_DISPLAYON, LCD_COMMAND);
  lcd_send_byte(LCD_CMD_ENTRYMODESET | LCD_ENTRYLEFT, LCD_COMMAND);
  lcd_clear();
}

void lcd_clear(void) {
  lcd_send_byte(LCD_CMD_CLEARDISPLAY, LCD_COMMAND);
  sleep_ms(2); // allow time to process
}

void lcd_set_cursor(int line, int position) {
  int addr = (line == 0) ? 0x80 + position : 0xC0 + position;
  lcd_send_byte(addr, LCD_COMMAND);
}

void lcd_char(char val) { lcd_send_byte(val, LCD_CHARACTER); }

void lcd_string(const char *s) {
  while (*s) {
    lcd_char(*s++);
  }
}
