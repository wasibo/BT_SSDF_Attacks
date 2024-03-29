#!/bin/bash
echo "Start monitoring script"
sleep 5

total_loop=300;
step=0;
time_window=$4;
# the total monitoring time is total_loop * time_window
while(($step<$total_loop));
	do
		# get the pid
		mount -o remount rw /
		pid=$(ps aux | grep es_sensor | grep -v sudo | grep -v grep | awk '{print $2}');
		while [[ $pid == "" ]];
			do 
				# try to get the pid again
				sleep 10
				service electrosense-sensor-mqtt stop
                echo "Restarting (couldn't find process ID) with behavior $1 with a bandwidth of $3 for $4 seconds."
                sleep 5
				cd /usr/share/electrosense/
                es_sensor -d 0 -q 0.167 -c 0 -r 0 -y sequential -s 2400000 -a 5 -b 10 -m 0 -k 3600 -t 0 -f 8 -n collector.electrosense.org:5001#certs/CA-Cert.pem#certs/Sensor-SSL-Cert.pem#certs/Sensor-SSL-SK.pem -o 128 -w hanning -v $1 -j $3 24000000 1766000000 200000000 500000000 >/dev/null 2>&1 &
				sleep 10 
				pid=$(ps aux | grep es_sensor | grep -v sudo | grep -v grep | awk '{print $2}');
			done
		echo "Start to monitor system calls for $1 with a bandwidth of $3 for $4 seconds. Current iteration: $step, pid is $pid"
		current=`date "+%Y-%m-%d_%H-%M-%S"`;
		path="$1_${step}_${current}";
		# start perf and save results, without nanosleep
		timeout -s 1 ${time_window} perf trace -o /data/$2/raw/${path}.txt -e !nanosleep -T -p ${pid};
		echo "Finished monitoring, start preprocessing"
		python $HOME/sensor-robin/attacks/preprocessing.py /data/$2/raw/${path}.txt /data/$2/raw/${path}.csv
		echo "Step ${step} finished for $1";
		((step=$step+1));
	done;
echo "Get system calls for $1 with ${total_loop} iteration(s) finished";
