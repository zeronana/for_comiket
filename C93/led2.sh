#!/bin/sh

ctrlc()
{
	echo "ctrl+c detected"
	gpio write 1 0
	gpio mode 1 input
	exit
}

trap ctrlc INT

gpio mode 1 output

echo "exit program, press ctrl+c"

while true
do
	gpio write 1 1
	sleep 1
	gpio write 1 0
	sleep 1
done

