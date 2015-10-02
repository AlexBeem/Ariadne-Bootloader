@echo off
@echo making Ariadne bootloader files...
make OS=windows ENV=arduino atmega328_16mhz_blink_shield > makelog.txt
make OS=windows ENV=arduino atmega328_16mhz_noblink_shield >> makelog.txt
make OS=windows ENV=arduino atmega328_16mhz_blink_notshield >> makelog.txt
make OS=windows ENV=arduino atmega328_16mhz_noblink_notshield >> makelog.txt
make OS=windows ENV=arduino atmega328_8mhz_blink_shield >> makelog.txt
make OS=windows ENV=arduino atmega328_8mhz_noblink_shield >> makelog.txt
make OS=windows ENV=arduino atmega328_8mhz_blink_notshield >> makelog.txt
make OS=windows ENV=arduino atmega328_8mhz_noblink_notshield >> makelog.txt
make OS=windows ENV=arduino atmega328_debug_16mhz_blink_shield >> makelog.txt
make OS=windows ENV=arduino atmega328_16mhz_blink_arduinoethernet >> makelog.txt
make OS=windows ENV=arduino atmega328_16mhz_noblink_arduinoethernet >> makelog.txt
make OS=windows ENV=arduino atmega1284p_16mhz_blink_shield_avrdevelopersstandard >> makelog.txt
make OS=windows ENV=arduino atmega1284p_16mhz_noblink_shield_avrdevelopersstandard >> makelog.txt
make OS=windows ENV=arduino atmega1284p_16mhz_blink_notshield_avrdevelopersstandard >> makelog.txt
make OS=windows ENV=arduino atmega1284p_16mhz_noblink_notshield_avrdevelopersstandard >> makelog.txt
make OS=windows ENV=arduino atmega1284p_8mhz_blink_shield_avrdevelopersstandard >> makelog.txt
make OS=windows ENV=arduino atmega1284p_8mhz_noblink_shield_avrdevelopersstandard >> makelog.txt
make OS=windows ENV=arduino atmega1284p_8mhz_blink_notshield_avrdevelopersstandard >> makelog.txt
make OS=windows ENV=arduino atmega1284p_8mhz_noblink_notshield_avrdevelopersstandard >> makelog.txt
make OS=windows ENV=arduino atmega1284p_debug_16mhz_blink_shield_avrdevelopersstandard >> makelog.txt
make OS=windows ENV=arduino atmega1284p_16mhz_blink_shield_bobuinosleepingbeauty >> makelog.txt
make OS=windows ENV=arduino atmega1284p_16mhz_noblink_shield_bobuinosleepingbeauty >> makelog.txt
make OS=windows ENV=arduino atmega1284p_16mhz_blink_notshield_bobuinosleepingbeauty >> makelog.txt
make OS=windows ENV=arduino atmega1284p_16mhz_noblink_notshield_bobuinosleepingbeauty >> makelog.txt
make OS=windows ENV=arduino atmega1284p_8mhz_blink_shield_bobuinosleepingbeauty >> makelog.txt
make OS=windows ENV=arduino atmega1284p_8mhz_noblink_shield_bobuinosleepingbeauty >> makelog.txt
make OS=windows ENV=arduino atmega1284p_8mhz_blink_notshield_bobuinosleepingbeauty >> makelog.txt
make OS=windows ENV=arduino atmega1284p_8mhz_noblink_notshield_bobuinosleepingbeauty >> makelog.txt
make OS=windows ENV=arduino atmega2560_16mhz_blink_shield >> makelog.txt
make OS=windows ENV=arduino atmega2560_16mhz_noblink_shield >> makelog.txt
make OS=windows ENV=arduino atmega2560_16mhz_blink_notshield >> makelog.txt
make OS=windows ENV=arduino atmega2560_16mhz_noblink_notshield >> makelog.txt
make OS=windows ENV=arduino atmega2560_debug_16mhz_blink_shield >> makelog.txt
@pause
