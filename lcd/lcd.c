#include "lcd.h"
#include "hardware/i2c.h"
#include "pico/stdlib.h"
#include <pico/stdio.h>
#include <pico/time.h>
#include <stdint.h>
#include <stdio.h>
#include <sys/types.h>

// LCD controller address
static const u_int8_t addr = 0x27;

#define LCD_COMMAND 0
#define LCD_CHARACTER 1

#define LCD_LINE0_ADDR 0x80
#define LCD_LINE1_ADDR 0xC0
#define LCD_ENABLE_BIT 0x04

// Internal helpers
static void i2c_write_byte(uint8_t val) {
#ifdef i2c_default
  i2c_write_blocking(i2c_default, addr, &val, 1, false);
#endif
}

static void lcd_toggle_enable(uint8_t val) {
  sleep_us(600);
  i2c_write_byte(val | LCD_ENABLE_BIT); // Set E=1
  sleep_us(600);
  i2c_write_byte(val & ~LCD_ENABLE_BIT); // Set E=0
  sleep_us(600);
}

void print_bin(uint8_t byte) {
  for (int i = 7; i >= 0; --i)
    putchar((byte & (1 << i)) ? '1' : '0');
}
static void lcd_send_byte(uint8_t val, uint8_t mode) {

  uint8_t high_nipple = mode | (val & 0xF0) | LCD_BACKLIGHT;
  uint8_t low_nipple = mode | ((val << 4) & 0xF0) | LCD_BACKLIGHT;

  i2c_write_byte(high_nipple);
  lcd_toggle_enable(high_nipple);
  i2c_write_byte(low_nipple);
  lcd_toggle_enable(low_nipple);
}

// Public API
void lcd_init(void) {
  sleep_ms(50); // Wait for LCD to power up
  for (int i = 0; i < 3; ++i) {
    lcd_send_byte(0x03, LCD_COMMAND);
  }
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

void lcd_write_line(int line, int position, const char *str) {
  int addr =
      (line == 0) ? LCD_LINE0_ADDR + position : LCD_LINE1_ADDR + position;
  lcd_send_byte(addr, LCD_COMMAND);
  while (*str) {
    lcd_send_byte(*str++, LCD_CHARACTER);
  }
}
