#!/usr/bin/env python3

import time
import wiringpi as GPIO
 
trig = 23
echo = 24
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
	distance = measure_distance()
	print (round(distance, 1), "cm")
	time.sleep(0.1)
