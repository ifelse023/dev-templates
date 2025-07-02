
#pragma once

#include <stdint.h>

// commands
typedef enum {
  LCD_CMD_CLEARDISPLAY = 0x01,
  LCD_CMD_RETURNHOME = 0x02,
  LCD_CMD_ENTRYMODESET = 0x04,
  LCD_CMD_DISPLAYCTRL = 0x08,
  LCD_CMD_CURSORSHIFT = 0x10,
  LCD_CMD_FUNCTIONSET = 0x20,
  LCD_CMD_SETCGRAMADDR = 0x40,
  LCD_CMD_SETDDRAMADDR = 0x80
} lcd_command_t;

// Flags for LCD commands
#define LCD_ENTRYLEFT 0x02
#define LCD_ENTRYSHIFTINCREMENT 0x01

// flags for display and cursor control
#define LCD_DISPLAYON 0x04
#define LCD_CURSORON 0x02
#define LCD_BLINKON 0x01

// flags for display and cursor shift
#define LCD_DISPLAYMOVE 0x08
#define LCD_MOVERIGHT 0x04

// flags for function set
#define LCD_8BITMODE 0x10
#define LCD_2LINE 0x08
#define LCD_5x10DOTS 0x04

#define LCD_BACKLIGHT 0x08

void lcd_init(void);
void lcd_clear(void);
void lcd_set_cursor(int line, int position);
void lcd_string(const char *s);
void lcd_char(char val);
