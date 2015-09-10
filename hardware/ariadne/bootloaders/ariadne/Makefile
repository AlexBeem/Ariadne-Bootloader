# Name: Makefile
# Author: Stelios Tsampas, from work by optiboot
# Copyright: optiboot
# License: GPL http://www.gnu.org/licenses/gpl-2.0.html
# Project: ariadne bootloader
# Function: tftp implementation and flasher
# Version: 0.2 tftp flashing functional, serial flashing

# Instructions
#
# To make bootloader .hex file:
# make diecimila
# make lilypad
# make ng
# etc...
#
# To burn bootloader .hex file:
# make diecimila_isp
# make lilypad_isp
# make ng_isp
# etc...


# program name should not be changed...
PROGRAM    = ariadne

# The default behavior is to build using tools that are in the users
# current path variables, but we can also build using an installed
# Arduino user IDE setup, or the Arduino source tree.
# Uncomment this next lines to build within the arduino environment,
# using the arduino-included avrgcc toolset (mac and pc)
# ENV ?= arduino
# ENV ?= arduinodev
# OS ?= macosx
# OS ?= windows

# enter the parameters for the avrdude isp tool
# for now they default to the arduinoISP on linux
ISPTOOL    = avrispmkii
#ISPTOOL   = usbtiny
ISPPORT	   = usb
ISPSPEED   = -b38400

MCU_TARGET = atmega328p
LDSECTIONS = -Wl,--section-start=.text=0x7000 #-Wl,--section-start=.version=0x7ffe

# Build environments
# Start of some ugly makefile-isms to allow optiboot to be built
# in several different environments.  See the README.TXT file for
# details.

# default
fixpath = $(1)

ifeq ($(ENV), arduino)
# For Arduino, we assume that we're connected to the optiboot directory
# included with the arduino distribution, which means that the full set
# of avr-tools are "right up there" in standard places.
# For Arduino 1.5+:
TOOLROOT = ../../../../tools
# For Arduino 1.0.x:
# TOOLROOT = ../../../tools
GCCROOT = $(TOOLROOT)/avr/bin/
AVRDUDE_CONF = -C$(TOOLROOT)/avr/etc/avrdude.conf

ifeq ($(OS), windows)
# On windows, SOME of the tool paths will need to have backslashes instead
# of forward slashes (because they use windows cmd.exe for execution instead
# of a unix/mingw shell?)  We also have to ensure that a consistent shell
# is used even if a unix shell is installed (ie as part of WINAVR)
fixpath = $(subst /,\,$1)
SHELL = cmd.exe
endif

else ifeq ($(ENV), arduinodev)
# Arduino IDE source code environment.  Use the unpacked compilers created
# by the build (you'll need to do "ant build" first.)
ifeq ($(OS), macosx)
TOOLROOT = ../../../../build/macosx/work/Arduino.app/Contents/Resources/Java/hardware/tools
endif
ifeq ($(OS), windows)
TOOLROOT = ../../../../build/windows/work/hardware/tools
endif

GCCROOT = $(TOOLROOT)/avr/bin/
AVRDUDE_CONF = -C$(TOOLROOT)/avr/etc/avrdude.conf

else
GCCROOT =
AVRDUDE_CONF =
endif

# End of build environment code.


# the efuse should really be 0xf8; since, however, only the lower
# three bits of that byte are used on the atmega168, avrdude gets
# confused if you specify 1's for the higher bits, see:
# http://tinker.it/now/2007/02/24/the-tale-of-avrdude-atmega168-and-extended-bits-fuses/
# similarly, the lock bits should be 0xff instead of 0x3f (to
# unlock the bootloader section) and 0xcf instead of 0x2f (to
# lock it), but since the high two bits of the lock byte are
# unused, avrdude would get confused.

ISPFUSES = $(GCCROOT)avrdude $(AVRDUDE_CONF) -c $(ISPTOOL) \
           -p $(MCU_TARGET) -P $(ISPPORT) $(ISPSPEED) \
           -e -u -U lock:w:0x3F:m -U efuse:w:0x$(EFUSE):m \
           -U hfuse:w:0x$(HFUSE):m -U lfuse:w:0x$(LFUSE):m
ISPFLASH = $(GCCROOT)avrdude $(AVRDUDE_CONF) -c $(ISPTOOL) \
           -p $(MCU_TARGET) -P $(ISPPORT) $(ISPSPEED) \
           -U flash:w:$(PROGRAM)_$(TARGET).hex -U lock:w:0x0F:m

STK500   = "C:\Program Files\Atmel\AVR Tools\STK500\Stk500.exe"
STK500-1 = $(STK500) -e -d$(MCU_TARGET) -pf -vf -if$(PROGRAM)_$(TARGET).hex \
	   -lFF -LFF -f$(HFUSE)$(LFUSE) -EF8 -ms -q -cUSB -I200kHz -s -wt
STK500-2 = $(STK500) -d$(MCU_TARGET) -ms -q -lCF -LCF -cUSB -I200kHz -s -wt

OBJ      = main.o spi.o w5100.o tftp.o validate.o debug.o watchdog.o serial.o util.o announce.o optiboot.o stk500boot.o
OPTIMIZE = -Os -fno-inline-small-functions -fno-split-wide-types -mno-interrupts -mrelax
OPTIMIZE += -funsigned-char -funsigned-bitfields -fpack-struct -fshort-enums -fno-jump-tables -std=gnu99 #-save-temps

DEFS     =
LIBS     =

CC       = $(GCCROOT)avr-gcc

# Override is only needed by avr-lib build system.

override CFLAGS  = -g -Wall -Wextra -Wstrict-prototypes $(OPTIMIZE) -mmcu=$(MCU_TARGET) -DF_CPU=$(AVR_FREQ) $(DEFS)
override LDFLAGS = $(LDSECTIONS) -Wl,--relax -Wl,--gc-sections

OBJCOPY = $(GCCROOT)avr-objcopy
OBJDUMP = $(call fixpath,$(GCCROOT)avr-objdump)

SIZE    = $(GCCROOT)avr-size


atmega328_16mhz_blink_shield: EXT_OBJ = optiboot.o
atmega328_16mhz_blink_shield: TARGET = atmega328_16mhz_blink_shield
atmega328_16mhz_blink_shield: MCU_TARGET = atmega328p
atmega328_16mhz_blink_shield: CFLAGS += '-DBAUD_RATE=115200'
atmega328_16mhz_blink_shield: AVR_FREQ = 16000000L
atmega328_16mhz_blink_shield: LDSECTIONS = -Wl,--section-start=.text=0x7000 #-Wl,--section-start=.version=0x7ffe
atmega328_16mhz_blink_shield: $(PROGRAM)_atmega328_16mhz_blink_shield.hex
atmega328_16mhz_blink_shield: $(PROGRAM)_atmega328_16mhz_blink_shield.lst
atmega328_16mhz_blink_shield_isp: atmega328_16mhz_blink_shield
atmega328_16mhz_blink_shield_isp: TARGET = atmega328_16mhz_blink_shield
atmega328_16mhz_blink_shield_isp: MCU_TARGET = atmega328p
# Low power xtal (16MHz) 16KCK/14CK+65ms
atmega328_16mhz_blink_shield_isp: LFUSE = FF
# 4096 byte boot, SPIEN
atmega328_16mhz_blink_shield_isp: HFUSE = D8
# 2.7V brownout
atmega328_16mhz_blink_shield_isp: EFUSE = 05
atmega328_16mhz_blink_shield_isp: isp

atmega328_16mhz_noblink_shield: EXT_OBJ = optiboot.o
atmega328_16mhz_noblink_shield: TARGET = atmega328_16mhz_noblink_shield
atmega328_16mhz_noblink_shield: MCU_TARGET = atmega328p
atmega328_16mhz_noblink_shield: CFLAGS += '-DBAUD_RATE=115200' '-DDISABLE_BLINK'
atmega328_16mhz_noblink_shield: AVR_FREQ = 16000000L
atmega328_16mhz_noblink_shield: LDSECTIONS = -Wl,--section-start=.text=0x7000 #-Wl,--section-start=.version=0x7ffe
atmega328_16mhz_noblink_shield: $(PROGRAM)_atmega328_16mhz_noblink_shield.hex
atmega328_16mhz_noblink_shield: $(PROGRAM)_atmega328_16mhz_noblink_shield.lst
atmega328_16mhz_noblink_shield_isp: atmega328_16mhz_noblink_shield
atmega328_16mhz_noblink_shield_isp: TARGET = atmega328_16mhz_noblink_shield
atmega328_16mhz_noblink_shield_isp: MCU_TARGET = atmega328p
# Low power xtal (16MHz) 16KCK/14CK+65ms
atmega328_16mhz_noblink_shield_isp: LFUSE = FF
# 4096 byte boot, SPIEN
atmega328_16mhz_noblink_shield_isp: HFUSE = D8
# 2.7V brownout
atmega328_16mhz_noblink_shield_isp: EFUSE = 05
atmega328_16mhz_noblink_shield_isp: isp

atmega328_16mhz_blink_notshield: EXT_OBJ = optiboot.o
atmega328_16mhz_blink_notshield: TARGET = atmega328_16mhz_blink_notshield
atmega328_16mhz_blink_notshield: MCU_TARGET = atmega328p
atmega328_16mhz_blink_notshield: CFLAGS += '-DBAUD_RATE=115200' '-DNOT_SHIELD'
atmega328_16mhz_blink_notshield: AVR_FREQ = 16000000L
atmega328_16mhz_blink_notshield: LDSECTIONS = -Wl,--section-start=.text=0x7000 #-Wl,--section-start=.version=0x7ffe
atmega328_16mhz_blink_notshield: $(PROGRAM)_atmega328_16mhz_blink_notshield.hex
atmega328_16mhz_blink_notshield: $(PROGRAM)_atmega328_16mhz_blink_notshield.lst
atmega328_16mhz_blink_notshield_isp: atmega328_16mhz_blink_notshield
atmega328_16mhz_blink_notshield_isp: TARGET = atmega328_16mhz_blink_notshield
atmega328_16mhz_blink_notshield_isp: MCU_TARGET = atmega328p
# Low power xtal (16MHz) 16KCK/14CK+65ms
atmega328_16mhz_blink_notshield_isp: LFUSE = FF
# 4096 byte boot, SPIEN
atmega328_16mhz_blink_notshield_isp: HFUSE = D8
# 2.7V brownout
atmega328_16mhz_blink_notshield_isp: EFUSE = 05
atmega328_16mhz_blink_notshield_isp: isp

atmega328_16mhz_noblink_notshield: EXT_OBJ = optiboot.o
atmega328_16mhz_noblink_notshield: TARGET = atmega328_16mhz_noblink_notshield
atmega328_16mhz_noblink_notshield: MCU_TARGET = atmega328p
atmega328_16mhz_noblink_notshield: CFLAGS += '-DBAUD_RATE=115200' '-DDISABLE_BLINK' '-DNOT_SHIELD'
atmega328_16mhz_noblink_notshield: AVR_FREQ = 16000000L
atmega328_16mhz_noblink_notshield: LDSECTIONS = -Wl,--section-start=.text=0x7000 #-Wl,--section-start=.version=0x7ffe
atmega328_16mhz_noblink_notshield: $(PROGRAM)_atmega328_16mhz_noblink_notshield.hex
atmega328_16mhz_noblink_notshield: $(PROGRAM)_atmega328_16mhz_noblink_notshield.lst
atmega328_16mhz_noblink_notshield_isp: atmega328_16mhz_noblink_notshield
atmega328_16mhz_noblink_notshield_isp: TARGET = atmega328_16mhz_noblink_notshield
atmega328_16mhz_noblink_notshield_isp: MCU_TARGET = atmega328p
# Low power xtal (16MHz) 16KCK/14CK+65ms
atmega328_16mhz_noblink_notshield_isp: LFUSE = FF
# 4096 byte boot, SPIEN
atmega328_16mhz_noblink_notshield_isp: HFUSE = D8
# 2.7V brownout
atmega328_16mhz_noblink_notshield_isp: EFUSE = 05
atmega328_16mhz_noblink_notshield_isp: isp


atmega328_8mhz_blink_shield: EXT_OBJ = optiboot.o
atmega328_8mhz_blink_shield: TARGET = atmega328_8mhz_blink_shield
atmega328_8mhz_blink_shield: MCU_TARGET = atmega328p
atmega328_8mhz_blink_shield: CFLAGS += '-DBAUD_RATE=57600'
atmega328_8mhz_blink_shield: AVR_FREQ = 8000000L
atmega328_8mhz_blink_shield: LDSECTIONS = -Wl,--section-start=.text=0x7000 #-Wl,--section-start=.version=0x7ffe
atmega328_8mhz_blink_shield: $(PROGRAM)_atmega328_8mhz_blink_shield.hex
atmega328_8mhz_blink_shield: $(PROGRAM)_atmega328_8mhz_blink_shield.lst
atmega328_8mhz_blink_shield_isp: atmega328_8mhz_blink_shield
atmega328_8mhz_blink_shield_isp: TARGET = atmega328_8mhz_blink_shield
atmega328_8mhz_blink_shield_isp: MCU_TARGET = atmega328p
# Internal Oscillator (8MHz)
atmega328_8mhz_blink_shield_isp: LFUSE = E2
# 4096 byte boot, SPIEN
atmega328_8mhz_blink_shield_isp: HFUSE = D8
# 2.7V brownout
atmega328_8mhz_blink_shield_isp: EFUSE = 05
atmega328_8mhz_blink_shield_isp: isp

atmega328_8mhz_noblink_shield: EXT_OBJ = optiboot.o
atmega328_8mhz_noblink_shield: TARGET = atmega328_8mhz_noblink_shield
atmega328_8mhz_noblink_shield: MCU_TARGET = atmega328p
atmega328_8mhz_noblink_shield: CFLAGS += '-DBAUD_RATE=57600' '-DDISABLE_BLINK'
atmega328_8mhz_noblink_shield: AVR_FREQ = 8000000L
atmega328_8mhz_noblink_shield: LDSECTIONS = -Wl,--section-start=.text=0x7000 #-Wl,--section-start=.version=0x7ffe
atmega328_8mhz_noblink_shield: $(PROGRAM)_atmega328_8mhz_noblink_shield.hex
atmega328_8mhz_noblink_shield: $(PROGRAM)_atmega328_8mhz_noblink_shield.lst
atmega328_8mhz_noblink_shield_isp: atmega328_8mhz_noblink_shield
atmega328_8mhz_noblink_shield_isp: TARGET = atmega328_8mhz_noblink_shield
atmega328_8mhz_noblink_shield_isp: MCU_TARGET = atmega328p
# Internal Oscillator (8MHz)
atmega328_8mhz_noblink_shield_isp: LFUSE = E2
# 4096 byte boot, SPIEN
atmega328_8mhz_noblink_shield_isp: HFUSE = D8
# 2.7V brownout
atmega328_8mhz_noblink_shield_isp: EFUSE = 05
atmega328_8mhz_noblink_shield_isp: isp

atmega328_8mhz_blink_notshield: EXT_OBJ = optiboot.o
atmega328_8mhz_blink_notshield: TARGET = atmega328_8mhz_blink_notshield
atmega328_8mhz_blink_notshield: MCU_TARGET = atmega328p
atmega328_8mhz_blink_notshield: CFLAGS += '-DBAUD_RATE=57600' '-DNOT_SHIELD'
atmega328_8mhz_blink_notshield: AVR_FREQ = 8000000L
atmega328_8mhz_blink_notshield: LDSECTIONS = -Wl,--section-start=.text=0x7000 #-Wl,--section-start=.version=0x7ffe
atmega328_8mhz_blink_notshield: $(PROGRAM)_atmega328_8mhz_blink_notshield.hex
atmega328_8mhz_blink_notshield: $(PROGRAM)_atmega328_8mhz_blink_notshield.lst
atmega328_8mhz_blink_notshield_isp: atmega328_8mhz_blink_notshield
atmega328_8mhz_blink_notshield_isp: TARGET = atmega328_8mhz_blink_notshield
atmega328_8mhz_blink_notshield_isp: MCU_TARGET = atmega328p
# Internal Oscillator (8MHz)
atmega328_8mhz_blink_notshield_isp: LFUSE = E2
# 4096 byte boot, SPIEN
atmega328_8mhz_blink_notshield_isp: HFUSE = D8
# 2.7V brownout
atmega328_8mhz_blink_notshield_isp: EFUSE = 05
atmega328_8mhz_blink_notshield_isp: isp

atmega328_8mhz_noblink_notshield: EXT_OBJ = optiboot.o
atmega328_8mhz_noblink_notshield: TARGET = atmega328_8mhz_noblink_notshield
atmega328_8mhz_noblink_notshield: MCU_TARGET = atmega328p
atmega328_8mhz_noblink_notshield: CFLAGS += '-DBAUD_RATE=57600' '-DDISABLE_BLINK' '-DNOT_SHIELD'
atmega328_8mhz_noblink_notshield: AVR_FREQ = 8000000L
atmega328_8mhz_noblink_notshield: LDSECTIONS = -Wl,--section-start=.text=0x7000 #-Wl,--section-start=.version=0x7ffe
atmega328_8mhz_noblink_notshield: $(PROGRAM)_atmega328_8mhz_noblink_notshield.hex
atmega328_8mhz_noblink_notshield: $(PROGRAM)_atmega328_8mhz_noblink_notshield.lst
atmega328_8mhz_noblink_notshield_isp: atmega328_8mhz_noblink_notshield
atmega328_8mhz_noblink_notshield_isp: TARGET = atmega328_8mhz_noblink_notshield
atmega328_8mhz_noblink_notshield_isp: MCU_TARGET = atmega328p
# Internal Oscillator (8MHz)
atmega328_8mhz_noblink_notshield_isp: LFUSE = E2
# 4096 byte boot, SPIEN
atmega328_8mhz_noblink_notshield_isp: HFUSE = D8
# 2.7V brownout
atmega328_8mhz_noblink_notshield_isp: EFUSE = 05
atmega328_8mhz_noblink_notshield_isp: isp

atmega328_debug_16mhz_blink_shield: TARGET = atmega328_debug_16mhz_blink_shield
atmega328_debug_16mhz_blink_shield: MCU_TARGET = atmega328p
atmega328_debug_16mhz_blink_shield: CFLAGS += '-DDEBUG_MAIN=1' '-DDEBUG_NET=1' '-DDEBUG_TFTP=1' '-DBAUD_RATE=115200'
atmega328_debug_16mhz_blink_shield: AVR_FREQ = 16000000L
atmega328_debug_16mhz_blink_shield: LDSECTIONS = -Wl,--section-start=.text=0x7000 #-Wl,--section-start=.version=0x7ffe
atmega328_debug_16mhz_blink_shield: $(PROGRAM)_atmega328_debug_16mhz_blink_shield.hex
atmega328_debug_16mhz_blink_shield: $(PROGRAM)_atmega328_debug_16mhz_blink_shield.lst
atmega328_debug_16mhz_blink_shield_isp: atmega328_debug_16mhz_blink_shield
atmega328_debug_16mhz_blink_shield_isp: TARGET = atmega328_debug_16mhz_blink_shield
atmega328_debug_16mhz_blink_shield_isp: MCU_TARGET = atmega328p
# Low power xtal (16MHz) 16KCK/14CK+65ms
atmega328_debug_16mhz_blink_shield_isp: LFUSE = FF
# 4096 byte boot, SPIEN
atmega328_debug_16mhz_blink_shield_isp: HFUSE = D0
# 2.7V brownout
atmega328_debug_16mhz_blink_shield_isp: EFUSE = 05
atmega328_debug_16mhz_blink_shield_isp: isp


# Arduino Ethernet
atmega328_16mhz_blink_arduinoethernet: TARGET = atmega328_16mhz_blink_arduinoethernet
atmega328_16mhz_blink_arduinoethernet: MCU_TARGET = atmega328p
atmega328_16mhz_blink_arduinoethernet: CFLAGS += '-DARDUINO_ETHERNET' '-DBAUD_RATE=115200'
atmega328_16mhz_blink_arduinoethernet: AVR_FREQ = 16000000L
atmega328_16mhz_blink_arduinoethernet: LDSECTIONS = -Wl,--section-start=.text=0x7000 #-Wl,--section-start=.version=0x7ffe
atmega328_16mhz_blink_arduinoethernet: $(PROGRAM)_atmega328_16mhz_blink_arduinoethernet.hex
atmega328_16mhz_blink_arduinoethernet: $(PROGRAM)_atmega328_16mhz_blink_arduinoethernet.lst
atmega328_16mhz_blink_arduinoethernet_isp: atmega328_16mhz_blink_arduinoethernet
atmega328_16mhz_blink_arduinoethernet_isp: TARGET = atmega328_16mhz_blink_arduinoethernet
atmega328_16mhz_blink_arduinoethernet_isp: MCU_TARGET = atmega328p
# Low power xtal (16MHz) 16KCK/14CK+65ms
atmega328_16mhz_blink_arduinoethernet_isp: LFUSE = FF
# 4096 byte boot, SPIEN
atmega328_16mhz_blink_arduinoethernet_isp: HFUSE = D8
# 2.7V brownout
atmega328_16mhz_blink_arduinoethernet_isp: EFUSE = 05
atmega328_16mhz_blink_arduinoethernet_isp: isp

atmega328_16mhz_noblink_arduinoethernet: TARGET = atmega328_16mhz_noblink_arduinoethernet
atmega328_16mhz_noblink_arduinoethernet: MCU_TARGET = atmega328p
atmega328_16mhz_noblink_arduinoethernet: CFLAGS += '-DARDUINO_ETHERNET' '-DBAUD_RATE=115200' '-DDISABLE_BLINK'
atmega328_16mhz_noblink_arduinoethernet: AVR_FREQ = 16000000L
atmega328_16mhz_noblink_arduinoethernet: LDSECTIONS = -Wl,--section-start=.text=0x7000 #-Wl,--section-start=.version=0x7ffe
atmega328_16mhz_noblink_arduinoethernet: $(PROGRAM)_atmega328_16mhz_noblink_arduinoethernet.hex
atmega328_16mhz_noblink_arduinoethernet: $(PROGRAM)_atmega328_16mhz_noblink_arduinoethernet.lst
atmega328_16mhz_noblink_arduinoethernet_isp: atmega328_16mhz_noblink_arduinoethernet
atmega328_16mhz_noblink_arduinoethernet_isp: TARGET = atmega328_16mhz_noblink_arduinoethernet
atmega328_16mhz_noblink_arduinoethernet_isp: MCU_TARGET = atmega328p
# Low power xtal (16MHz) 16KCK/14CK+65ms
atmega328_16mhz_noblink_arduinoethernet_isp: LFUSE = FF
# 4096 byte boot, SPIEN
atmega328_16mhz_noblink_arduinoethernet_isp: HFUSE = D8
# 2.7V brownout
atmega328_16mhz_noblink_arduinoethernet_isp: EFUSE = 05
atmega328_16mhz_noblink_arduinoethernet_isp: isp


# avr-developers or standard variant
atmega1284p_16mhz_blink_shield_avrdevelopersstandard: TARGET = atmega1284p_16mhz_blink_shield_avrdevelopersstandard
atmega1284p_16mhz_blink_shield_avrdevelopersstandard: MCU_TARGET = atmega1284p
atmega1284p_16mhz_blink_shield_avrdevelopersstandard: CFLAGS += '-DBAUD_RATE=115200'
atmega1284p_16mhz_blink_shield_avrdevelopersstandard: AVR_FREQ = 16000000L
atmega1284p_16mhz_blink_shield_avrdevelopersstandard: LDSECTIONS = -Wl,--section-start=.text=0x1f000,--section-start=.version=0x1fffe
atmega1284p_16mhz_blink_shield_avrdevelopersstandard: $(PROGRAM)_atmega1284p_16mhz_blink_shield_avrdevelopersstandard.hex
atmega1284p_16mhz_blink_shield_avrdevelopersstandard: $(PROGRAM)_atmega1284p_16mhz_blink_shield_avrdevelopersstandard.lst
atmega1284p_16mhz_blink_shield_avrdevelopersstandard_isp: atmega1284p_16mhz_blink_shield_avrdevelopersstandard
atmega1284p_16mhz_blink_shield_avrdevelopersstandard_isp: TARGET = atmega1284p_16mhz_blink_shield_avrdevelopersstandard
atmega1284p_16mhz_blink_shield_avrdevelopersstandard_isp: MCU_TARGET = atmega1284p
# Full Swing Oscillator (16MHz) 16K CK + 65ms
atmega1284p_16mhz_blink_shield_avrdevelopersstandard_isp: LFUSE = F7
# 4096 byte boot
atmega1284p_16mhz_blink_shield_avrdevelopersstandard_isp: HFUSE = DA
# 2.7V brownout
atmega1284p_16mhz_blink_shield_avrdevelopersstandard_isp: EFUSE = FD
atmega1284p_16mhz_blink_shield_avrdevelopersstandard_isp: isp

atmega1284p_16mhz_noblink_shield_avrdevelopersstandard: TARGET = atmega1284p_16mhz_noblink_shield_avrdevelopersstandard
atmega1284p_16mhz_noblink_shield_avrdevelopersstandard: MCU_TARGET = atmega1284p
atmega1284p_16mhz_noblink_shield_avrdevelopersstandard: CFLAGS += '-DBAUD_RATE=115200' '-DDISABLE_BLINK'
atmega1284p_16mhz_noblink_shield_avrdevelopersstandard: AVR_FREQ = 16000000L
atmega1284p_16mhz_noblink_shield_avrdevelopersstandard: LDSECTIONS = -Wl,--section-start=.text=0x1f000,--section-start=.version=0x1fffe
atmega1284p_16mhz_noblink_shield_avrdevelopersstandard: $(PROGRAM)_atmega1284p_16mhz_noblink_shield_avrdevelopersstandard.hex
atmega1284p_16mhz_noblink_shield_avrdevelopersstandard: $(PROGRAM)_atmega1284p_16mhz_noblink_shield_avrdevelopersstandard.lst
atmega1284p_16mhz_noblink_shield_avrdevelopersstandard_isp: atmega1284p_16mhz_noblink_shield_avrdevelopersstandard
atmega1284p_16mhz_noblink_shield_avrdevelopersstandard_isp: TARGET = atmega1284p_16mhz_noblink_shield_avrdevelopersstandard
atmega1284p_16mhz_noblink_shield_avrdevelopersstandard_isp: MCU_TARGET = atmega1284p
# Full Swing Oscillator (16MHz) 16K CK + 65ms
atmega1284p_16mhz_noblink_shield_avrdevelopersstandard_isp: LFUSE = F7
# 4096 byte boot
atmega1284p_16mhz_noblink_shield_avrdevelopersstandard_isp: HFUSE = DA
# 2.7V brownout
atmega1284p_16mhz_noblink_shield_avrdevelopersstandard_isp: EFUSE = FD
atmega1284p_16mhz_noblink_shield_avrdevelopersstandard_isp: isp

atmega1284p_16mhz_blink_notshield_avrdevelopersstandard: TARGET = atmega1284p_16mhz_blink_notshield_avrdevelopersstandard
atmega1284p_16mhz_blink_notshield_avrdevelopersstandard: MCU_TARGET = atmega1284p
atmega1284p_16mhz_blink_notshield_avrdevelopersstandard: CFLAGS += '-DBAUD_RATE=115200' '-DNOT_SHIELD'
atmega1284p_16mhz_blink_notshield_avrdevelopersstandard: AVR_FREQ = 16000000L
atmega1284p_16mhz_blink_notshield_avrdevelopersstandard: LDSECTIONS = -Wl,--section-start=.text=0x1f000,--section-start=.version=0x1fffe
atmega1284p_16mhz_blink_notshield_avrdevelopersstandard: $(PROGRAM)_atmega1284p_16mhz_blink_notshield_avrdevelopersstandard.hex
atmega1284p_16mhz_blink_notshield_avrdevelopersstandard: $(PROGRAM)_atmega1284p_16mhz_blink_notshield_avrdevelopersstandard.lst
atmega1284p_16mhz_blink_notshield_avrdevelopersstandard_isp: atmega1284p_16mhz_blink_notshield_avrdevelopersstandard
atmega1284p_16mhz_blink_notshield_avrdevelopersstandard_isp: TARGET = atmega1284p_16mhz_blink_notshield_avrdevelopersstandard
atmega1284p_16mhz_blink_notshield_avrdevelopersstandard_isp: MCU_TARGET = atmega1284p
# Full Swing Oscillator (16MHz) 16K CK + 65ms
atmega1284p_16mhz_blink_notshield_avrdevelopersstandard_isp: LFUSE = F7
# 4096 byte boot
atmega1284p_16mhz_blink_notshield_avrdevelopersstandard_isp: HFUSE = DA
# 2.7V brownout
atmega1284p_16mhz_blink_notshield_avrdevelopersstandard_isp: EFUSE = FD
atmega1284p_16mhz_blink_notshield_avrdevelopersstandard_isp: isp

atmega1284p_16mhz_noblink_notshield_avrdevelopersstandard: TARGET = atmega1284p_16mhz_noblink_notshield_avrdevelopersstandard
atmega1284p_16mhz_noblink_notshield_avrdevelopersstandard: MCU_TARGET = atmega1284p
atmega1284p_16mhz_noblink_notshield_avrdevelopersstandard: CFLAGS += '-DBAUD_RATE=115200' '-DDISABLE_BLINK' '-DNOT_SHIELD'
atmega1284p_16mhz_noblink_notshield_avrdevelopersstandard: AVR_FREQ = 16000000L
atmega1284p_16mhz_noblink_notshield_avrdevelopersstandard: LDSECTIONS = -Wl,--section-start=.text=0x1f000,--section-start=.version=0x1fffe
atmega1284p_16mhz_noblink_notshield_avrdevelopersstandard: $(PROGRAM)_atmega1284p_16mhz_noblink_notshield_avrdevelopersstandard.hex
atmega1284p_16mhz_noblink_notshield_avrdevelopersstandard: $(PROGRAM)_atmega1284p_16mhz_noblink_notshield_avrdevelopersstandard.lst
atmega1284p_16mhz_noblink_notshield_avrdevelopersstandard_isp: atmega1284p_16mhz_noblink_notshield_avrdevelopersstandard
atmega1284p_16mhz_noblink_notshield_avrdevelopersstandard_isp: TARGET = atmega1284p_16mhz_noblink_notshield_avrdevelopersstandard
atmega1284p_16mhz_noblink_notshield_avrdevelopersstandard_isp: MCU_TARGET = atmega1284p
# Full Swing Oscillator (16MHz) 16K CK + 65ms
atmega1284p_16mhz_noblink_notshield_avrdevelopersstandard_isp: LFUSE = F7
# 4096 byte boot
atmega1284p_16mhz_noblink_notshield_avrdevelopersstandard_isp: HFUSE = DA
# 2.7V brownout
atmega1284p_16mhz_noblink_notshield_avrdevelopersstandard_isp: EFUSE = FD
atmega1284p_16mhz_noblink_notshield_avrdevelopersstandard_isp: isp

atmega1284p_8mhz_blink_shield_avrdevelopersstandard: TARGET = atmega1284p_8mhz_blink_shield_avrdevelopersstandard
atmega1284p_8mhz_blink_shield_avrdevelopersstandard: MCU_TARGET = atmega1284p
atmega1284p_8mhz_blink_shield_avrdevelopersstandard: CFLAGS += '-DBAUD_RATE=115200'
atmega1284p_8mhz_blink_shield_avrdevelopersstandard: AVR_FREQ = 8000000L
atmega1284p_8mhz_blink_shield_avrdevelopersstandard: LDSECTIONS = -Wl,--section-start=.text=0x1f000,--section-start=.version=0x1fffe
atmega1284p_8mhz_blink_shield_avrdevelopersstandard: $(PROGRAM)_atmega1284p_8mhz_blink_shield_avrdevelopersstandard.hex
atmega1284p_8mhz_blink_shield_avrdevelopersstandard: $(PROGRAM)_atmega1284p_8mhz_blink_shield_avrdevelopersstandard.lst
atmega1284p_8mhz_blink_shield_avrdevelopersstandard_isp: atmega1284p_8mhz_blink_shield_avrdevelopersstandard
atmega1284p_8mhz_blink_shield_avrdevelopersstandard_isp: TARGET = atmega1284p_8mhz_blink_shield_avrdevelopersstandard
atmega1284p_8mhz_blink_shield_avrdevelopersstandard_isp: MCU_TARGET = atmega1284p
# Internal Oscillator (8MHz)
atmega1284p_8mhz_blink_shield_avrdevelopersstandard_isp: LFUSE = E2
# 4096 byte boot
atmega1284p_8mhz_blink_shield_avrdevelopersstandard_isp: HFUSE = DA
# 2.7V brownout
atmega1284p_8mhz_blink_shield_avrdevelopersstandard_isp: EFUSE = FD
atmega1284p_8mhz_blink_shield_avrdevelopersstandard_isp: isp

atmega1284p_8mhz_noblink_shield_avrdevelopersstandard: TARGET = atmega1284p_8mhz_noblink_shield_avrdevelopersstandard
atmega1284p_8mhz_noblink_shield_avrdevelopersstandard: MCU_TARGET = atmega1284p
atmega1284p_8mhz_noblink_shield_avrdevelopersstandard: CFLAGS += '-DBAUD_RATE=115200' '-DDISABLE_BLINK'
atmega1284p_8mhz_noblink_shield_avrdevelopersstandard: AVR_FREQ = 8000000L
atmega1284p_8mhz_noblink_shield_avrdevelopersstandard: LDSECTIONS = -Wl,--section-start=.text=0x1f000,--section-start=.version=0x1fffe
atmega1284p_8mhz_noblink_shield_avrdevelopersstandard: $(PROGRAM)_atmega1284p_8mhz_noblink_shield_avrdevelopersstandard.hex
atmega1284p_8mhz_noblink_shield_avrdevelopersstandard: $(PROGRAM)_atmega1284p_8mhz_noblink_shield_avrdevelopersstandard.lst
atmega1284p_8mhz_noblink_shield_avrdevelopersstandard_isp: atmega1284p_8mhz_noblink_shield_avrdevelopersstandard
atmega1284p_8mhz_noblink_shield_avrdevelopersstandard_isp: TARGET = atmega1284p_8mhz_noblink_shield_avrdevelopersstandard
atmega1284p_8mhz_noblink_shield_avrdevelopersstandard_isp: MCU_TARGET = atmega1284p
# Internal Oscillator (8MHz)
atmega1284p_8mhz_noblink_shield_avrdevelopersstandard_isp: LFUSE = E2
# 4096 byte boot
atmega1284p_8mhz_noblink_shield_avrdevelopersstandard_isp: HFUSE = DA
# 2.7V brownout
atmega1284p_8mhz_noblink_shield_avrdevelopersstandard_isp: EFUSE = FD
atmega1284p_8mhz_noblink_shield_avrdevelopersstandard_isp: isp

atmega1284p_8mhz_blink_notshield_avrdevelopersstandard: TARGET = atmega1284p_8mhz_blink_notshield_avrdevelopersstandard
atmega1284p_8mhz_blink_notshield_avrdevelopersstandard: MCU_TARGET = atmega1284p
atmega1284p_8mhz_blink_notshield_avrdevelopersstandard: CFLAGS += '-DBAUD_RATE=115200' '-DNOT_SHIELD'
atmega1284p_8mhz_blink_notshield_avrdevelopersstandard: AVR_FREQ = 8000000L
atmega1284p_8mhz_blink_notshield_avrdevelopersstandard: LDSECTIONS = -Wl,--section-start=.text=0x1f000,--section-start=.version=0x1fffe
atmega1284p_8mhz_blink_notshield_avrdevelopersstandard: $(PROGRAM)_atmega1284p_8mhz_blink_notshield_avrdevelopersstandard.hex
atmega1284p_8mhz_blink_notshield_avrdevelopersstandard: $(PROGRAM)_atmega1284p_8mhz_blink_notshield_avrdevelopersstandard.lst
atmega1284p_8mhz_blink_notshield_avrdevelopersstandard_isp: atmega1284p_8mhz_blink_notshield_avrdevelopersstandard
atmega1284p_8mhz_blink_notshield_avrdevelopersstandard_isp: TARGET = atmega1284p_8mhz_blink_notshield_avrdevelopersstandard
atmega1284p_8mhz_blink_notshield_avrdevelopersstandard_isp: MCU_TARGET = atmega1284p
# Internal Oscillator (8MHz)
atmega1284p_8mhz_blink_notshield_avrdevelopersstandard_isp: LFUSE = E2
# 4096 byte boot
atmega1284p_8mhz_blink_notshield_avrdevelopersstandard_isp: HFUSE = DA
# 2.7V brownout
atmega1284p_8mhz_blink_notshield_avrdevelopersstandard_isp: EFUSE = FD
atmega1284p_8mhz_blink_notshield_avrdevelopersstandard_isp: isp

atmega1284p_8mhz_noblink_notshield_avrdevelopersstandard: TARGET = atmega1284p_8mhz_noblink_notshield_avrdevelopersstandard
atmega1284p_8mhz_noblink_notshield_avrdevelopersstandard: MCU_TARGET = atmega1284p
atmega1284p_8mhz_noblink_notshield_avrdevelopersstandard: CFLAGS += '-DBAUD_RATE=115200' '-DDISABLE_BLINK' '-DNOT_SHIELD'
atmega1284p_8mhz_noblink_notshield_avrdevelopersstandard: AVR_FREQ = 8000000L
atmega1284p_8mhz_noblink_notshield_avrdevelopersstandard: LDSECTIONS = -Wl,--section-start=.text=0x1f000,--section-start=.version=0x1fffe
atmega1284p_8mhz_noblink_notshield_avrdevelopersstandard: $(PROGRAM)_atmega1284p_8mhz_noblink_notshield_avrdevelopersstandard.hex
atmega1284p_8mhz_noblink_notshield_avrdevelopersstandard: $(PROGRAM)_atmega1284p_8mhz_noblink_notshield_avrdevelopersstandard.lst
atmega1284p_8mhz_noblink_notshield_avrdevelopersstandard_isp: atmega1284p_8mhz_noblink_notshield_avrdevelopersstandard
atmega1284p_8mhz_noblink_notshield_avrdevelopersstandard_isp: TARGET = atmega1284p_8mhz_noblink_notshield_avrdevelopersstandard
atmega1284p_8mhz_noblink_notshield_avrdevelopersstandard_isp: MCU_TARGET = atmega1284p
# Internal Oscillator (8MHz)
atmega1284p_8mhz_noblink_notshield_avrdevelopersstandard_isp: LFUSE = E2
# 4096 byte boot
atmega1284p_8mhz_noblink_notshield_avrdevelopersstandard_isp: HFUSE = DA
# 2.7V brownout
atmega1284p_8mhz_noblink_notshield_avrdevelopersstandard_isp: EFUSE = FD
atmega1284p_8mhz_noblink_notshield_avrdevelopersstandard_isp: isp

atmega1284p_debug_16mhz_blink_shield_avrdevelopersstandard: TARGET = atmega1284p_debug_16mhz_blink_shield_avrdevelopersstandard
atmega1284p_debug_16mhz_blink_shield_avrdevelopersstandard: MCU_TARGET = atmega1284p
atmega1284p_debug_16mhz_blink_shield_avrdevelopersstandard: CFLAGS += '-DDEBUG_MAIN=1' '-DDEBUG_NET=1' '-DDEBUG_TFTP=1' '-DBAUD_RATE=115200'
atmega1284p_debug_16mhz_blink_shield_avrdevelopersstandard: AVR_FREQ = 16000000L
atmega1284p_debug_16mhz_blink_shield_avrdevelopersstandard: LDSECTIONS = -Wl,--section-start=.text=0x1e000,--section-start=.version=0x1fffe
atmega1284p_debug_16mhz_blink_shield_avrdevelopersstandard: $(PROGRAM)_atmega1284p_debug_16mhz_blink_shield_avrdevelopersstandard.hex
atmega1284p_debug_16mhz_blink_shield_avrdevelopersstandard: $(PROGRAM)_atmega1284p_debug_16mhz_blink_shield_avrdevelopersstandard.lst
atmega1284p_debug_16mhz_blink_shield_avrdevelopersstandard_isp: atmega1284p_debug_16mhz_blink_shield_avrdevelopersstandard
atmega1284p_debug_16mhz_blink_shield_avrdevelopersstandard_isp: TARGET = atmega1284p_debug_16mhz_blink_shield_avrdevelopersstandard
atmega1284p_debug_16mhz_blink_shield_avrdevelopersstandard_isp: MCU_TARGET = atmega1284p
# Full Swing Oscillator (16MHz) 16K CK + 65ms
atmega1284p_debug_16mhz_blink_shield_avrdevelopersstandard_isp: LFUSE = F7
# 8192 byte boot
atmega1284p_debug_16mhz_blink_shield_avrdevelopersstandard_isp: HFUSE = D0
# 2.7V brownout
atmega1284p_debug_16mhz_blink_shield_avrdevelopersstandard_isp: EFUSE = FD
atmega1284p_debug_16mhz_blink_shield_avrdevelopersstandard_isp: isp


# bobuino or sleepingbeauty variant
atmega1284p_16mhz_blink_shield_bobuinosleepingbeauty: TARGET = atmega1284p_16mhz_blink_shield_bobuinosleepingbeauty
atmega1284p_16mhz_blink_shield_bobuinosleepingbeauty: MCU_TARGET = atmega1284p
atmega1284p_16mhz_blink_shield_bobuinosleepingbeauty: CFLAGS += '-DBAUD_RATE=115200' '-DATMEGA1284P_PINOUT_BOBUINO_SLEEPINGBEAUTY'
atmega1284p_16mhz_blink_shield_bobuinosleepingbeauty: AVR_FREQ = 16000000L
atmega1284p_16mhz_blink_shield_bobuinosleepingbeauty: LDSECTIONS = -Wl,--section-start=.text=0x1f000,--section-start=.version=0x1fffe
atmega1284p_16mhz_blink_shield_bobuinosleepingbeauty: $(PROGRAM)_atmega1284p_16mhz_blink_shield_bobuinosleepingbeauty.hex
atmega1284p_16mhz_blink_shield_bobuinosleepingbeauty: $(PROGRAM)_atmega1284p_16mhz_blink_shield_bobuinosleepingbeauty.lst
atmega1284p_16mhz_blink_shield_bobuinosleepingbeauty_isp: atmega1284p_16mhz_blink_shield_bobuinosleepingbeauty
atmega1284p_16mhz_blink_shield_bobuinosleepingbeauty_isp: TARGET = atmega1284p_16mhz_blink_shield_bobuinosleepingbeauty
atmega1284p_16mhz_blink_shield_bobuinosleepingbeauty_isp: MCU_TARGET = atmega1284p
# Full Swing Oscillator (16MHz) 16K CK + 65ms
atmega1284p_16mhz_blink_shield_bobuinosleepingbeauty_isp: LFUSE = F7
# 4096 byte boot
atmega1284p_16mhz_blink_shield_bobuinosleepingbeauty_isp: HFUSE = DA
# 2.7V brownout
atmega1284p_16mhz_blink_shield_bobuinosleepingbeauty_isp: EFUSE = FD
atmega1284p_16mhz_blink_shield_bobuinosleepingbeauty_isp: isp

atmega1284p_16mhz_noblink_shield_bobuinosleepingbeauty: TARGET = atmega1284p_16mhz_noblink_shield_bobuinosleepingbeauty
atmega1284p_16mhz_noblink_shield_bobuinosleepingbeauty: MCU_TARGET = atmega1284p
atmega1284p_16mhz_noblink_shield_bobuinosleepingbeauty: CFLAGS += '-DBAUD_RATE=115200' '-DDISABLE_BLINK' '-DATMEGA1284P_PINOUT_BOBUINO_SLEEPINGBEAUTY'
atmega1284p_16mhz_noblink_shield_bobuinosleepingbeauty: AVR_FREQ = 16000000L
atmega1284p_16mhz_noblink_shield_bobuinosleepingbeauty: LDSECTIONS = -Wl,--section-start=.text=0x1f000,--section-start=.version=0x1fffe
atmega1284p_16mhz_noblink_shield_bobuinosleepingbeauty: $(PROGRAM)_atmega1284p_16mhz_noblink_shield_bobuinosleepingbeauty.hex
atmega1284p_16mhz_noblink_shield_bobuinosleepingbeauty: $(PROGRAM)_atmega1284p_16mhz_noblink_shield_bobuinosleepingbeauty.lst
atmega1284p_16mhz_noblink_shield_bobuinosleepingbeauty_isp: atmega1284p_16mhz_noblink_shield_bobuinosleepingbeauty
atmega1284p_16mhz_noblink_shield_bobuinosleepingbeauty_isp: TARGET = atmega1284p_16mhz_noblink_shield_bobuinosleepingbeauty
atmega1284p_16mhz_noblink_shield_bobuinosleepingbeauty_isp: MCU_TARGET = atmega1284p
# Full Swing Oscillator (16MHz) 16K CK + 65ms
atmega1284p_16mhz_noblink_shield_bobuinosleepingbeauty_isp: LFUSE = F7
# 4096 byte boot
atmega1284p_16mhz_noblink_shield_bobuinosleepingbeauty_isp: HFUSE = DA
# 2.7V brownout
atmega1284p_16mhz_noblink_shield_bobuinosleepingbeauty_isp: EFUSE = FD
atmega1284p_16mhz_noblink_shield_bobuinosleepingbeauty_isp: isp

atmega1284p_16mhz_blink_notshield_bobuinosleepingbeauty: TARGET = atmega1284p_16mhz_blink_notshield_bobuinosleepingbeauty
atmega1284p_16mhz_blink_notshield_bobuinosleepingbeauty: MCU_TARGET = atmega1284p
atmega1284p_16mhz_blink_notshield_bobuinosleepingbeauty: CFLAGS += '-DBAUD_RATE=115200' '-DNOT_SHIELD' '-DATMEGA1284P_PINOUT_BOBUINO_SLEEPINGBEAUTY'
atmega1284p_16mhz_blink_notshield_bobuinosleepingbeauty: AVR_FREQ = 16000000L
atmega1284p_16mhz_blink_notshield_bobuinosleepingbeauty: LDSECTIONS = -Wl,--section-start=.text=0x1f000,--section-start=.version=0x1fffe
atmega1284p_16mhz_blink_notshield_bobuinosleepingbeauty: $(PROGRAM)_atmega1284p_16mhz_blink_notshield_bobuinosleepingbeauty.hex
atmega1284p_16mhz_blink_notshield_bobuinosleepingbeauty: $(PROGRAM)_atmega1284p_16mhz_blink_notshield_bobuinosleepingbeauty.lst
atmega1284p_16mhz_blink_notshield_bobuinosleepingbeauty_isp: atmega1284p_16mhz_blink_notshield_bobuinosleepingbeauty
atmega1284p_16mhz_blink_notshield_bobuinosleepingbeauty_isp: TARGET = atmega1284p_16mhz_blink_notshield_bobuinosleepingbeauty
atmega1284p_16mhz_blink_notshield_bobuinosleepingbeauty_isp: MCU_TARGET = atmega1284p
# Full Swing Oscillator (16MHz) 16K CK + 65ms
atmega1284p_16mhz_blink_notshield_bobuinosleepingbeauty_isp: LFUSE = F7
# 4096 byte boot
atmega1284p_16mhz_blink_notshield_bobuinosleepingbeauty_isp: HFUSE = DA
# 2.7V brownout
atmega1284p_16mhz_blink_notshield_bobuinosleepingbeauty_isp: EFUSE = FD
atmega1284p_16mhz_blink_notshield_bobuinosleepingbeauty_isp: isp

atmega1284p_16mhz_noblink_notshield_bobuinosleepingbeauty: TARGET = atmega1284p_16mhz_noblink_notshield_bobuinosleepingbeauty
atmega1284p_16mhz_noblink_notshield_bobuinosleepingbeauty: MCU_TARGET = atmega1284p
atmega1284p_16mhz_noblink_notshield_bobuinosleepingbeauty: CFLAGS += '-DBAUD_RATE=115200' '-DDISABLE_BLINK' '-DNOT_SHIELD' '-DATMEGA1284P_PINOUT_BOBUINO_SLEEPINGBEAUTY'
atmega1284p_16mhz_noblink_notshield_bobuinosleepingbeauty: AVR_FREQ = 16000000L
atmega1284p_16mhz_noblink_notshield_bobuinosleepingbeauty: LDSECTIONS = -Wl,--section-start=.text=0x1f000,--section-start=.version=0x1fffe
atmega1284p_16mhz_noblink_notshield_bobuinosleepingbeauty: $(PROGRAM)_atmega1284p_16mhz_noblink_notshield_bobuinosleepingbeauty.hex
atmega1284p_16mhz_noblink_notshield_bobuinosleepingbeauty: $(PROGRAM)_atmega1284p_16mhz_noblink_notshield_bobuinosleepingbeauty.lst
atmega1284p_16mhz_noblink_notshield_bobuinosleepingbeauty_isp: atmega1284p_16mhz_noblink_notshield_bobuinosleepingbeauty
atmega1284p_16mhz_noblink_notshield_bobuinosleepingbeauty_isp: TARGET = atmega1284p_16mhz_noblink_notshield_bobuinosleepingbeauty
atmega1284p_16mhz_noblink_notshield_bobuinosleepingbeauty_isp: MCU_TARGET = atmega1284p
# Full Swing Oscillator (16MHz) 16K CK + 65ms
atmega1284p_16mhz_noblink_notshield_bobuinosleepingbeauty_isp: LFUSE = F7
# 4096 byte boot
atmega1284p_16mhz_noblink_notshield_bobuinosleepingbeauty_isp: HFUSE = DA
# 2.7V brownout
atmega1284p_16mhz_noblink_notshield_bobuinosleepingbeauty_isp: EFUSE = FD
atmega1284p_16mhz_noblink_notshield_bobuinosleepingbeauty_isp: isp

atmega1284p_8mhz_blink_shield_bobuinosleepingbeauty: TARGET = atmega1284p_8mhz_blink_shield_bobuinosleepingbeauty
atmega1284p_8mhz_blink_shield_bobuinosleepingbeauty: MCU_TARGET = atmega1284p
atmega1284p_8mhz_blink_shield_bobuinosleepingbeauty: CFLAGS += '-DBAUD_RATE=115200' '-DATMEGA1284P_PINOUT_BOBUINO_SLEEPINGBEAUTY'
atmega1284p_8mhz_blink_shield_bobuinosleepingbeauty: AVR_FREQ = 8000000L
atmega1284p_8mhz_blink_shield_bobuinosleepingbeauty: LDSECTIONS = -Wl,--section-start=.text=0x1f000,--section-start=.version=0x1fffe
atmega1284p_8mhz_blink_shield_bobuinosleepingbeauty: $(PROGRAM)_atmega1284p_8mhz_blink_shield_bobuinosleepingbeauty.hex
atmega1284p_8mhz_blink_shield_bobuinosleepingbeauty: $(PROGRAM)_atmega1284p_8mhz_blink_shield_bobuinosleepingbeauty.lst
atmega1284p_8mhz_blink_shield_bobuinosleepingbeauty_isp: atmega1284p_8mhz_blink_shield_bobuinosleepingbeauty
atmega1284p_8mhz_blink_shield_bobuinosleepingbeauty_isp: TARGET = atmega1284p_8mhz_blink_shield_bobuinosleepingbeauty
atmega1284p_8mhz_blink_shield_bobuinosleepingbeauty_isp: MCU_TARGET = atmega1284p
# Internal Oscillator (8MHz)
atmega1284p_8mhz_blink_shield_bobuinosleepingbeauty_isp: LFUSE = E2
# 4096 byte boot
atmega1284p_8mhz_blink_shield_bobuinosleepingbeauty_isp: HFUSE = DA
# 2.7V brownout
atmega1284p_8mhz_blink_shield_bobuinosleepingbeauty_isp: EFUSE = FD
atmega1284p_8mhz_blink_shield_bobuinosleepingbeauty_isp: isp

atmega1284p_8mhz_noblink_shield_bobuinosleepingbeauty: TARGET = atmega1284p_8mhz_noblink_shield_bobuinosleepingbeauty
atmega1284p_8mhz_noblink_shield_bobuinosleepingbeauty: MCU_TARGET = atmega1284p
atmega1284p_8mhz_noblink_shield_bobuinosleepingbeauty: CFLAGS += '-DBAUD_RATE=115200' '-DDISABLE_BLINK' '-DATMEGA1284P_PINOUT_BOBUINO_SLEEPINGBEAUTY'
atmega1284p_8mhz_noblink_shield_bobuinosleepingbeauty: AVR_FREQ = 8000000L
atmega1284p_8mhz_noblink_shield_bobuinosleepingbeauty: LDSECTIONS = -Wl,--section-start=.text=0x1f000,--section-start=.version=0x1fffe
atmega1284p_8mhz_noblink_shield_bobuinosleepingbeauty: $(PROGRAM)_atmega1284p_8mhz_noblink_shield_bobuinosleepingbeauty.hex
atmega1284p_8mhz_noblink_shield_bobuinosleepingbeauty: $(PROGRAM)_atmega1284p_8mhz_noblink_shield_bobuinosleepingbeauty.lst
atmega1284p_8mhz_noblink_shield_bobuinosleepingbeauty_isp: atmega1284p_8mhz_noblink_shield_bobuinosleepingbeauty
atmega1284p_8mhz_noblink_shield_bobuinosleepingbeauty_isp: TARGET = atmega1284p_8mhz_noblink_shield_bobuinosleepingbeauty
atmega1284p_8mhz_noblink_shield_bobuinosleepingbeauty_isp: MCU_TARGET = atmega1284p
# Internal Oscillator (8MHz)
atmega1284p_8mhz_noblink_shield_bobuinosleepingbeauty_isp: LFUSE = E2
# 4096 byte boot
atmega1284p_8mhz_noblink_shield_bobuinosleepingbeauty_isp: HFUSE = DA
# 2.7V brownout
atmega1284p_8mhz_noblink_shield_bobuinosleepingbeauty_isp: EFUSE = FD
atmega1284p_8mhz_noblink_shield_bobuinosleepingbeauty_isp: isp

atmega1284p_8mhz_blink_notshield_bobuinosleepingbeauty: TARGET = atmega1284p_8mhz_blink_notshield_bobuinosleepingbeauty
atmega1284p_8mhz_blink_notshield_bobuinosleepingbeauty: MCU_TARGET = atmega1284p
atmega1284p_8mhz_blink_notshield_bobuinosleepingbeauty: CFLAGS += '-DBAUD_RATE=115200' '-DNOT_SHIELD' '-DATMEGA1284P_PINOUT_BOBUINO_SLEEPINGBEAUTY'
atmega1284p_8mhz_blink_notshield_bobuinosleepingbeauty: AVR_FREQ = 8000000L
atmega1284p_8mhz_blink_notshield_bobuinosleepingbeauty: LDSECTIONS = -Wl,--section-start=.text=0x1f000,--section-start=.version=0x1fffe
atmega1284p_8mhz_blink_notshield_bobuinosleepingbeauty: $(PROGRAM)_atmega1284p_8mhz_blink_notshield_bobuinosleepingbeauty.hex
atmega1284p_8mhz_blink_notshield_bobuinosleepingbeauty: $(PROGRAM)_atmega1284p_8mhz_blink_notshield_bobuinosleepingbeauty.lst
atmega1284p_8mhz_blink_notshield_bobuinosleepingbeauty_isp: atmega1284p_8mhz_blink_notshield_bobuinosleepingbeauty
atmega1284p_8mhz_blink_notshield_bobuinosleepingbeauty_isp: TARGET = atmega1284p_8mhz_blink_notshield_bobuinosleepingbeauty
atmega1284p_8mhz_blink_notshield_bobuinosleepingbeauty_isp: MCU_TARGET = atmega1284p
# Internal Oscillator (8MHz)
atmega1284p_8mhz_blink_notshield_bobuinosleepingbeauty_isp: LFUSE = E2
# 4096 byte boot
atmega1284p_8mhz_blink_notshield_bobuinosleepingbeauty_isp: HFUSE = DA
# 2.7V brownout
atmega1284p_8mhz_blink_notshield_bobuinosleepingbeauty_isp: EFUSE = FD
atmega1284p_8mhz_blink_notshield_bobuinosleepingbeauty_isp: isp

atmega1284p_8mhz_noblink_notshield_bobuinosleepingbeauty: TARGET = atmega1284p_8mhz_noblink_notshield_bobuinosleepingbeauty
atmega1284p_8mhz_noblink_notshield_bobuinosleepingbeauty: MCU_TARGET = atmega1284p
atmega1284p_8mhz_noblink_notshield_bobuinosleepingbeauty: CFLAGS += '-DBAUD_RATE=115200' '-DDISABLE_BLINK' '-DNOT_SHIELD' '-DATMEGA1284P_PINOUT_BOBUINO_SLEEPINGBEAUTY'
atmega1284p_8mhz_noblink_notshield_bobuinosleepingbeauty: AVR_FREQ = 8000000L
atmega1284p_8mhz_noblink_notshield_bobuinosleepingbeauty: LDSECTIONS = -Wl,--section-start=.text=0x1f000,--section-start=.version=0x1fffe
atmega1284p_8mhz_noblink_notshield_bobuinosleepingbeauty: $(PROGRAM)_atmega1284p_8mhz_noblink_notshield_bobuinosleepingbeauty.hex
atmega1284p_8mhz_noblink_notshield_bobuinosleepingbeauty: $(PROGRAM)_atmega1284p_8mhz_noblink_notshield_bobuinosleepingbeauty.lst
atmega1284p_8mhz_noblink_notshield_bobuinosleepingbeauty_isp: atmega1284p_8mhz_noblink_notshield_bobuinosleepingbeauty
atmega1284p_8mhz_noblink_notshield_bobuinosleepingbeauty_isp: TARGET = atmega1284p_8mhz_noblink_notshield_bobuinosleepingbeauty
atmega1284p_8mhz_noblink_notshield_bobuinosleepingbeauty_isp: MCU_TARGET = atmega1284p
# Internal Oscillator (8MHz)
atmega1284p_8mhz_noblink_notshield_bobuinosleepingbeauty_isp: LFUSE = E2
# 4096 byte boot
atmega1284p_8mhz_noblink_notshield_bobuinosleepingbeauty_isp: HFUSE = DA
# 2.7V brownout
atmega1284p_8mhz_noblink_notshield_bobuinosleepingbeauty_isp: EFUSE = FD
atmega1284p_8mhz_noblink_notshield_bobuinosleepingbeauty_isp: isp


atmega2560_16mhz_blink_shield: TARGET = atmega2560_16mhz_blink_shield
atmega2560_16mhz_blink_shield: MCU_TARGET = atmega2560
atmega2560_16mhz_blink_shield: CFLAGS += '-DBAUD_RATE=115200'
atmega2560_16mhz_blink_shield: AVR_FREQ = 16000000L
atmega2560_16mhz_blink_shield: LDSECTIONS = -Wl,--section-start=.text=0x3f000,--section-start=.version=0x3fffe
atmega2560_16mhz_blink_shield: $(PROGRAM)_atmega2560_16mhz_blink_shield.hex
atmega2560_16mhz_blink_shield: $(PROGRAM)_atmega2560_16mhz_blink_shield.lst
atmega2560_16mhz_blink_shield_isp: atmega2560_16mhz_blink_shield
atmega2560_16mhz_blink_shield_isp: TARGET = atmega2560_16mhz_blink_shield
atmega2560_16mhz_blink_shield_isp: MCU_TARGET = atmega2560
# Low power xtal (16MHz) 16KCK/14CK+65ms
atmega2560_16mhz_blink_shield_isp: LFUSE = FF
# 4096 byte boot
atmega2560_16mhz_blink_shield_isp: HFUSE = DA
# 2.7V brownout
atmega2560_16mhz_blink_shield_isp: EFUSE = FD
atmega2560_16mhz_blink_shield_isp: isp

atmega2560_16mhz_noblink_shield: TARGET = atmega2560_16mhz_noblink_shield
atmega2560_16mhz_noblink_shield: MCU_TARGET = atmega2560
atmega2560_16mhz_noblink_shield: CFLAGS += '-DBAUD_RATE=115200' '-DDISABLE_BLINK'
atmega2560_16mhz_noblink_shield: AVR_FREQ = 16000000L
atmega2560_16mhz_noblink_shield: LDSECTIONS = -Wl,--section-start=.text=0x3f000,--section-start=.version=0x3fffe
atmega2560_16mhz_noblink_shield: $(PROGRAM)_atmega2560_16mhz_noblink_shield.hex
atmega2560_16mhz_noblink_shield: $(PROGRAM)_atmega2560_16mhz_noblink_shield.lst
atmega2560_16mhz_noblink_shield_isp: atmega2560_16mhz_noblink_shield
atmega2560_16mhz_noblink_shield_isp: TARGET = atmega2560_16mhz_noblink_shield
atmega2560_16mhz_noblink_shield_isp: MCU_TARGET = atmega2560
# Low power xtal (16MHz) 16KCK/14CK+65ms
atmega2560_16mhz_noblink_shield_isp: LFUSE = FF
# 4096 byte boot
atmega2560_16mhz_noblink_shield_isp: HFUSE = DA
# 2.7V brownout
atmega2560_16mhz_noblink_shield_isp: EFUSE = FD
atmega2560_16mhz_noblink_shield_isp: isp

atmega2560_16mhz_blink_notshield: TARGET = atmega2560_16mhz_blink_notshield
atmega2560_16mhz_blink_notshield: MCU_TARGET = atmega2560
atmega2560_16mhz_blink_notshield: CFLAGS += '-DBAUD_RATE=115200' '-DNOT_SHIELD'
atmega2560_16mhz_blink_notshield: AVR_FREQ = 16000000L
atmega2560_16mhz_blink_notshield: LDSECTIONS = -Wl,--section-start=.text=0x3f000,--section-start=.version=0x3fffe
atmega2560_16mhz_blink_notshield: $(PROGRAM)_atmega2560_16mhz_blink_notshield.hex
atmega2560_16mhz_blink_notshield: $(PROGRAM)_atmega2560_16mhz_blink_notshield.lst
atmega2560_16mhz_blink_notshield_isp: atmega2560_16mhz_blink_notshield
atmega2560_16mhz_blink_notshield_isp: TARGET = atmega2560_16mhz_blink_notshield
atmega2560_16mhz_blink_notshield_isp: MCU_TARGET = atmega2560
# Low power xtal (16MHz) 16KCK/14CK+65ms
atmega2560_16mhz_blink_notshield_isp: LFUSE = FF
# 4096 byte boot
atmega2560_16mhz_blink_notshield_isp: HFUSE = DA
# 2.7V brownout
atmega2560_16mhz_blink_notshield_isp: EFUSE = FD
atmega2560_16mhz_blink_notshield_isp: isp

atmega2560_16mhz_noblink_notshield: TARGET = atmega2560_16mhz_noblink_notshield
atmega2560_16mhz_noblink_notshield: MCU_TARGET = atmega2560
atmega2560_16mhz_noblink_notshield: CFLAGS += '-DBAUD_RATE=115200' '-DDISABLE_BLINK' '-DNOT_SHIELD'
atmega2560_16mhz_noblink_notshield: AVR_FREQ = 16000000L
atmega2560_16mhz_noblink_notshield: LDSECTIONS = -Wl,--section-start=.text=0x3f000,--section-start=.version=0x3fffe
atmega2560_16mhz_noblink_notshield: $(PROGRAM)_atmega2560_16mhz_noblink_notshield.hex
atmega2560_16mhz_noblink_notshield: $(PROGRAM)_atmega2560_16mhz_noblink_notshield.lst
atmega2560_16mhz_noblink_notshield_isp: atmega2560_16mhz_noblink_notshield
atmega2560_16mhz_noblink_notshield_isp: TARGET = atmega2560_16mhz_noblink_notshield
atmega2560_16mhz_noblink_notshield_isp: MCU_TARGET = atmega2560
# Low power xtal (16MHz) 16KCK/14CK+65ms
atmega2560_16mhz_noblink_notshield_isp: LFUSE = FF
# 4096 byte boot
atmega2560_16mhz_noblink_notshield_isp: HFUSE = DA
# 2.7V brownout
atmega2560_16mhz_noblink_notshield_isp: EFUSE = FD
atmega2560_16mhz_noblink_notshield_isp: isp

atmega2560_debug_16mhz_blink_shield: TARGET = atmega2560_debug_16mhz_blink_shield
atmega2560_debug_16mhz_blink_shield: MCU_TARGET = atmega2560
atmega2560_debug_16mhz_blink_shield: CFLAGS += '-DDEBUG_MAIN=1' '-DDEBUG_NET=1' '-DDEBUG_TFTP=1' '-DDEBUG_VALD=1' '-DBAUD_RATE=115200'
atmega2560_debug_16mhz_blink_shield: AVR_FREQ = 16000000L
atmega2560_debug_16mhz_blink_shield: LDSECTIONS = -Wl,--section-start=.text=0x3e000,--section-start=.version=0x3fffe
atmega2560_debug_16mhz_blink_shield: $(PROGRAM)_atmega2560_debug_16mhz_blink_shield.hex
atmega2560_debug_16mhz_blink_shield: $(PROGRAM)_atmega2560_debug_16mhz_blink_shield.lst
atmega2560_debug_16mhz_blink_shield_isp: atmega2560_debug_16mhz_blink_shield
atmega2560_debug_16mhz_blink_shield_isp: TARGET = atmega2560_debug_16mhz_blink_shield
atmega2560_debug_16mhz_blink_shield_isp: MCU_TARGET = atmega2560
# Low power xtal (16MHz) 16KCK/14CK+65ms
atmega2560_debug_16mhz_blink_shield_isp: LFUSE = FF
# 8192 byte boot
atmega2560_debug_16mhz_blink_shield_isp: HFUSE = D0
# 2.7V brownout
atmega2560_debug_16mhz_blink_shield_isp: EFUSE = FD
atmega2560_debug_16mhz_blink_shield_isp: isp


# Generic build instructions
isp: $(TARGET)
	$(ISPFUSES)
	$(ISPFLASH)

isp-stk500: $(PROGRAM)_$(TARGET).hex
	$(STK500-1)
	$(STK500-2)

%.elf: $(OBJ)
	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^ $(LIBS)
	$(SIZE) $@

clean:
	rm -rf *.o *.i *.s *.elf *.lst *.map *.sym *.lss *.eep *.srec *.bin *.hex *~

%.lst: %.elf
	$(OBJDUMP) -h -S $< > $@

%.hex: %.elf
	$(OBJCOPY) -j .text -j .data -j .version --set-section-flags .version=alloc,load -O ihex $< $@

%.srec: %.elf
	$(OBJCOPY) -j .text -j .data -j .version --set-section-flags .version=alloc,load -O srec $< $@

%.bin: %.elf
	$(OBJCOPY) -j .text -j .data -j .version --set-section-flags .version=alloc,load -O binary $< $@
