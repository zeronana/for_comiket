#!/bin/sh

ctrlc()
{
	echo "ctrl+c detected"
	gpio write 1 0
	gpio mode 1 input
	exit
}

trap ctrlc INT

gpio mode 1 pwm
gpio pwm-ms
gpio pwmc 1920
gpio pwmr 200

echo "exit program, press ctrl+c"

while true
do
	for i in `seq 5 1 24`
	do
		gpio pwm 1 $i
		sleep 0.1
	done

	for i in `seq 24 -1 5`
	do
		gpio pwm 1 $i
		sleep 0.1
	done
done
