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
#stop:15
#7-14
#16-23

echo "exit program, press ctrl+c"

while true
do
	for i in `seq 15 -1 10`
	do
		gpio pwm 1 $i
		sleep 1
	done
	for i in `seq 10 1 15`
	do
		gpio pwm 1 $i
		sleep 1
	done
	for i in `seq 15 1 20`
	do
		gpio pwm 1 $i
		sleep 1
	done

	for i in `seq 20 -1 15`
	do
		gpio pwm 1 $i
		sleep 1
	done
done
