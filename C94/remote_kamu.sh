#!/bin/sh

base_dir=/home
log_file=6000.log
act=
file_size=`wc -c ${base_dir}/${log_file} | awk '{print $1}'`
file_size_new=

ctrlc()
{
	echo "ctrl+c detected"
	gpio write 4 0 ; gpio write 5 0
	gpio write 21 0 ; gpio write 22 0
	gpio mode 4 input ; gpio mode 5 input
	gpio mode 21 input ; gpio mode 22 input
	exit
}
trap ctrlc INT

gpio mode 4 output ; gpio mode 5 output
gpio mode 21 output ; gpio mode 22 output
gpio write 4 1 ; gpio write 5 1
gpio write 21 1 ; gpio write 22 1

while true
do
	file_size_new=`wc -c ${base_dir}/${log_file} | awk '{print $1}'`
	if [ "0$file_size_new" != "0$file_size" ]
	then
		act=`tail -n 1 ${base_dir}/${log_file}`
		case $act in
			A )
				echo $act
				# Turn left
				gpio write 4 0 ; gpio write 22 0
				sleep 0.5
				gpio write 4 1 ; gpio write 22 1
				;;
			B )
				echo $act
				# Backward
				gpio write 4 0 ; gpio write 21 0
				sleep 1
				gpio write 4 1 ; gpio write 21 1
				;;
			C )
				echo $act
				# Advance
				gpio write 5 0 ; gpio write 22 0
				sleep 1
				gpio write 5 1 ; gpio write 22 1
				;;
			D )
				echo $act
				# Turn right
				gpio write 5 0 ; gpio write 21 0
				sleep 0.5
				gpio write 5 1 ; gpio write 21 1
				;;
			Back )
				echo $act
				;;
			Enter )
				echo $act
				;;
			* )
				echo Invalid character;;
		esac
		file_size=$file_size_new
	fi
done

