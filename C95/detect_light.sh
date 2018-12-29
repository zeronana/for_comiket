#!/bin/sh
base_dir=/home
meas_dist_log=${base_dir}/kyori2.log

table_dist_th=20
table_angle=
table_angle_cnt=0
table_angle_unit=3

light_log=${base_dir}/light_th.log
light_detected=0

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
gpio pwm 1 15 #stop

echo "exit program, press ctrl+c"

gpio pwm 1 14

while true
do
	if [ "${light_detected}" = "0" ]
	then
		light=`tail -n 1 ${light_log} | grep "LIGHT_DETECTED"`
		if [ "${light}" != "" ]
		then
			gpio pwm 1 15 ; sleep 1
			light_detected=1
		else
			true #gpio pwm 1 14
		fi
	else
		while [ "${table_angle}" = "" ]
		do
			meas=`tail -n 1 ${meas_dist_log}`
			if [ ${meas%.*} -le ${table_dist_th} ]
			then
				table_angle=`expr ${table_angle_unit} \* ${table_angle_cnt}`
			else
				gpio pwm 1 14
				sleep 0.01  # about 3 deg. / 0.01 sec
				gpio pwm 1 15
				sleep 0.01
				table_angle_cnt=`expr ${table_angle_cnt} + 1`
			fi
		done
		echo table_angle=${table_angle} degree
		light_detected=0
		table_angle=
		table_angle_cnt=0
		gpio pwm 1 14
	fi
done
