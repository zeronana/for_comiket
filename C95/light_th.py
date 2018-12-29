#!/usr/bin/env python3

import time
import wiringpi as GPIO

spi_ch = 0
spi_speed = 1000000
light_threshold = 600

GPIO.wiringPiSPISetup(spi_ch, spi_speed)

while True:
    buffer = 0x6800 
    buffer = buffer.to_bytes(2, byteorder='big')
    GPIO.wiringPiSPIDataRW(spi_ch, buffer)
    value = (buffer[0] * 256 + buffer[1]) & 0x3ff
    if (value > light_threshold):
        print ('LIGHT_DETECTED:', value)
    else:
        print (value)
    time.sleep(0.1)
