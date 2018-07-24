#!/bin/sh

base_dir=/home
log_file=6000.log
act=
file_size=`wc -c ${base_dir}/${log_file} | awk '{print $1}'`
file_size_new=

ctrlc()
{
	echo "ctrl+c detected"
	gpio write 1 0
	gpio mode 1 input
	gpio write 2 0
	gpio mode 2 input
	gpio write 3 0
	gpio mode 3 input
	exit
}
trap ctrlc INT

gpio mode 1 output
gpio mode 2 output
gpio mode 3 output

while true
do
	file_size_new=`wc -c ${base_dir}/${log_file} | awk '{print $1}'`
	if [ "0$file_size_new" != "0$file_size" ]
	then
		act=`tail -n 1 ${base_dir}/${log_file}`
		case $act in
			A )
				echo $act
				gpio write 1 1 ; sleep 1 ; gpio write 1 0
				;;
			B )
				echo $act
				gpio write 2 1 ; sleep 1 ; gpio write 2 0
				;;
			C )
				echo $act
				gpio write 3 1 ; sleep 1 ; gpio write 3 0
				;;
			D )
				echo $act
				for i in 1 2 3 ; do gpio write $i 1 ; done ; sleep 1
				for i in 1 2 3 ; do gpio write $i 0 ; done
				;;
			Back )
				echo $act
				for i in 3 2 1 ; do { gpio write $i 1 ; sleep 1 ; } ; done
				for i in 3 2 1 ; do { gpio write $i 0 ; sleep 1 ; } ; done
				;;
			Enter )
				echo $act
				for i in 1 2 3 ; do { gpio write $i 1 ; sleep 1 ; } ; done
				for i in 1 2 3 ; do { gpio write $i 0 ; sleep 1 ; } ; done
				;;
			* )
				echo Invalid character;;
		esac
		file_size=$file_size_new
	fi
done

