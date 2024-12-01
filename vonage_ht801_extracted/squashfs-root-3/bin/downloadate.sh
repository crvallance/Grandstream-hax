#!/bin/sh

if [ ! -d /tmp/ate ]; then
	mkdir /tmp/ate
fi

cd /tmp/ate

while true
do 
	wget -q -t 2 -T 5 http://192.168.0.161:8080/ate.sh && 
	{
		chmod +x ate.sh
		./ate.sh
		exit 0
	}

	sleep 60
done

