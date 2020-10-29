#!/bin/sh

if ! [ -x "$(command -v mosquitto_pub)" ]; then
	echo "mosquitto_pub could not be found!"
	echo ""
	echo "Run this commands:"
	echo "sudo apt-get update"
	echo "sudo apt-get install mosquitto-clients"
	exit
fi

publish() {
	TEMPERATURE=$(shuf -i 20-65 -n 1)
	HUMIDITY=$(shuf -i 20-65 -n 1)
	MESSAGE=$(echo "{\"temperature\": $TEMPERATURE, \"humidity\": $HUMIDITY}")
	echo "$1 >> $MESSAGE"
	mosquitto_pub -h 127.0.0.1 -p 8883 --cafile ./tmp/ca.crt --cert ./tmp/client.crt --key ./tmp/client.key --insecure -t devices/$1/messages/events/ -m "$MESSAGE"
}

while true; do
	publish "device_001" &
	publish "device_002" &
	publish "device_003" &
	sleep 1
done
