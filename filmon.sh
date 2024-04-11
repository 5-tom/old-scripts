#!/bin/bash

#echo -n "" > /home/tom/mpvtest; mpv --input-ipc-server=/tmp/mpvsocket --idle --no-keepaspect-window --geometry=480x480 --title="stream" >> /home/tom/mpvtest

echo "{ \"command\": [\"loadfile\", \"$(yt-dlp https://www.filmon.com/tv/itv2 --get-url)\"] }" | socat - /tmp/mpvsocket
while true
do
	#core-idle
	#is_paused=$(echo "{ \"command\": [\"get_property\", \"eof-reached\"] }" | socat - /tmp/mpvsocket | jq ".data")
	#if [[ "$is_paused" == true ]]
	grep -q "HTTP error 403 Forbidden" /home/tom/mpvtest
	if [ $? -eq 0 ]
	then
		#sleep 1
		echo "{ \"command\": [\"loadfile\", \"$(yt-dlp https://www.filmon.com/tv/itv2 --get-url)\"] }" | socat - /tmp/mpvsocket
		echo "{ \"command\": [\"set_property\", \"pause\", false] }" | socat - /tmp/mpvsocket
		#sleep 2
		echo -n "" > /home/tom/mpvtest
	fi
	sleep 2
done
