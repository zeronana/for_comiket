#!/usr/bin/env python3

import time
import wiringpi as GPIO
import socket

spi_ch = 0
spi_speed = 1000000
light_threshold = 600
host = '192.168.1.62'
port = 6002
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)

GPIO.wiringPiSPISetup(spi_ch, spi_speed)

while True:
	buffer = 0x6800 
	buffer = buffer.to_bytes(2, byteorder='big')
	GPIO.wiringPiSPIDataRW(spi_ch, buffer)
	value = (buffer[0] * 256 + buffer[1]) & 0x3ff
	if (value > light_threshold):
		print ('LIGHT_DETECTED:', value)
		sock.sendto(b'LIGHT_DETECTED:' + str(value).encode('utf-8') + b'\n', (host, port))
	else:
		print (value)
		sock.sendto(str(value).encode('utf-8') + b'\n', (host, port))
		time.sleep(0.1)
