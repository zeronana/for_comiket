#!/usr/bin/env python3

import time
import wiringpi as GPIO
import socket

host = '192.168.1.62'
port = 6001
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
 
trig = 22
echo = 27
sound_speed = 34000
 
GPIO.wiringPiSetupGpio()
 
GPIO.pinMode(trig, GPIO.OUTPUT)
GPIO.pinMode(echo, GPIO.INPUT)
GPIO.digitalWrite(trig, GPIO.LOW)
time.sleep(1)
 
def measure_distance():
	GPIO.digitalWrite(trig, GPIO.HIGH)
	time.sleep(0.000011) #11usec
	GPIO.digitalWrite(trig, GPIO.LOW)
	while (GPIO.digitalRead(echo) == GPIO.LOW):
		time_start = time.time()
	while ( GPIO.digitalRead( echo ) == 1 ):
		time_end = time.time()
	return ((time_end - time_start) * sound_speed) / 2
 
while True:
	#distance = measure_distance()
	distance = round(measure_distance(), 1)
	#print (round(distance, 1), "cm")
	print (distance, "cm")
	sock.sendto(str(distance).encode('utf-8') + b'cm\n', (host, port))
	time.sleep(0.2)
