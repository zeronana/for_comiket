#!/bin/sh

ctrlc()
{
	echo "ctrl+c detected"
	gpio write 4 0
	gpio write 5 0
	gpio mode 4 input
	gpio mode 5 input
	exit
}

trap ctrlc INT

gpio mode 4 output
gpio mode 5 output

echo "exit program, press ctrl+c"

while true
do
	gpio write 4 1
	sleep 1
	gpio write 4 0
	sleep 1
	gpio write 5 1
	sleep 1
	gpio write 5 0
done
