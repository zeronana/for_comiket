#!/bin/sh

ctrlc()
{
	echo "ctrl+c detected"
	echo "in" > /sys/class/gpio/gpio18/direction
	echo "18" > /sys/class/gpio/unexport
	exit
}

trap ctrlc INT

echo "18" > /sys/class/gpio/export
echo "out" > /sys/class/gpio/gpio18/direction

echo "exit program, press ctrl+c"

while true
do
	echo "1" > /sys/class/gpio/gpio18/value
	sleep 1
	echo "0" > /sys/class/gpio/gpio18/value
	sleep 1
done
