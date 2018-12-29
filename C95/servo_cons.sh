#!/bin/sh

ctrlc()
{
	echo "ctrl+c detected"
	gpio write 1 0
	gpio mode 1 input
	exit
}

trap ctrlc INT

gpio mode 1 pwm ; sleep 0.1
gpio pwm-ms ; sleep 0.1
gpio pwmc 1920 ; sleep 0.1
gpio pwmr 15 ; sleep 0.1
#stop:15
#7-14
#16-23

echo "exit program, press ctrl+c"

gpio pwm 1 14
while true
do
:
done
