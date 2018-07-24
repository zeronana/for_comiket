#!/bin/sh

base_dir=/home
log_file=6000.log
act=
file_size=`wc -c ${base_dir}/${log_file} | awk '{print $1}'`
file_size_new=
meas_dist_bin=${base_dir}/kyori2.py
meas_dist_log=${base_dir}/kyori2.log
meas_dist_pid=
brake_limit=16
auto=0
obstacle=0

python3 -u ${meas_dist_bin} > ${meas_dist_log} &
meas_dist_pid=`echo $!`

ctrlc()
{
	echo "ctrl+c detected"
	gpio write 4 0 ; gpio write 5 0
	gpio write 21 0 ; gpio write 22 0
	gpio mode 4 input ; gpio mode 5 input
	gpio mode 21 input ; gpio mode 22 input
	gpio write 1 0
	gpio mode 1 input
	kill ${meas_dist_pid}
	exit
}
trap ctrlc INT

gpio mode 4 output ; gpio mode 5 output
gpio mode 21 output ; gpio mode 22 output
gpio write 4 1 ; gpio write 5 1
gpio write 21 1 ; gpio write 22 1
gpio mode 1 output

while true
do
	file_size_new=`wc -c ${base_dir}/${log_file} | awk '{print $1}'`
	if [ "0$file_size_new" != "0$file_size" ]
	then
		auto=0
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
				meas=`tail -n 3 ${meas_dist_log} | sort -n | awk 'NR==2{print $1}'`
				if [ ${meas%.*} -le ${brake_limit} ]
				then
					gpio write 1 1 ; sleep 1 ; gpio write 1 0
				else
					gpio write 5 0 ; gpio write 22 0
					sleep 1
					gpio write 5 1 ; gpio write 22 1
				fi
				;;
			D )
				echo $act
				# Turn right
				gpio write 5 0 ; gpio write 21 0
				sleep 0.65
				gpio write 5 1 ; gpio write 21 1
				;;
			Back )
				echo $act
				kill ${meas_dist_pid}
				python3 -u ${meas_dist_bin} > ${meas_dist_log} &
				meas_dist_pid=`echo $!`
				;;
			Enter )
				echo $act
				auto=1
				;;
			* )
				echo Invalid character;;
		esac
		file_size=$file_size_new
	else
		if [ "${auto}" = "1" ]
		then
			if [ "${obstacle}" = "0" ]
			then
				# Advance
				meas=`tail -n 3 ${meas_dist_log} | sort -n | awk 'NR==2{print $1}'`
				if [ ${meas%.*} -le ${brake_limit} ]
				then
					gpio write 1 1 ; sleep 1 ; gpio write 1 0
					obstacle=1
				else
					gpio write 5 0 ; gpio write 22 0
					sleep 0.5
					gpio write 5 1 ; gpio write 22 1
					obstacle=0
				fi
			else
				# Turn right
				gpio write 5 0 ; gpio write 21 0
				sleep 1.65
				gpio write 5 1 ; gpio write 21 1
				sleep 1
				meas_r=`tail -n 3 ${meas_dist_log} | sort -n | awk 'NR==2{print $1}'`
				# Turn left
				gpio write 4 0 ; gpio write 22 0
				sleep 3.0
				gpio write 4 1 ; gpio write 22 1
				sleep 1
				meas_l=`tail -n 3 ${meas_dist_log} | sort -n | awk 'NR==2{print $1}'`
				if [ ${meas_r%.*} -gt ${meas_l%.*} ]
				then
 					# Turn right
					gpio write 5 0 ; gpio write 21 0
					sleep 3.06
					gpio write 5 1 ; gpio write 21 1
				fi
				obstacle=0
			fi	
		fi
	fi
done

