#!/bin/sh

sleep 5

gpio mode 4 output ; gpio mode 5 output
gpio mode 21 output ; gpio mode 22 output

gpio write 4 1 ; gpio write 5 1
gpio write 21 1 ; gpio write 22 1

# Advance
gpio write 5 0 ; gpio write 21 0
sleep 3
gpio write 5 1 ; gpio write 21 1

# Backward
gpio write 4 0 ; gpio write 22 0
sleep 3
gpio write 4 1 ; gpio write 22 1

# Right advance
gpio write 5 0 ; sleep 3 ; gpio write 5 1

# Right backward
gpio write 4 0 ; sleep 3 ; gpio write 4 1

# Left advance
gpio write 21 0 ; sleep 3 ; gpio write 21 1

# Left backward
gpio write 22 0 ; sleep 3 ; gpio write 22 1

# Turn right
gpio write 5 0 ; gpio write 22 0
sleep 6
gpio write 5 1 ; gpio write 22 1

# Turn left
gpio write 4 0 ; gpio write 21 0
sleep 6
gpio write 4 1 ; gpio write 21 1

gpio mode 4 input ; gpio mode 5 input
gpio mode 21 input ; gpio mode 22 input
