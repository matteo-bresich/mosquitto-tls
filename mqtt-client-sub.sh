#!/bin/sh

if ! [ -x "$(command -v mosquitto_sub)" ]; then
	echo "mosquitto_sub could not be found!"
	echo ""
	echo "Run this commands:"
	echo "sudo apt-get update"
	echo "sudo apt-get install mosquitto-clients"
	exit
fi

subscribe() {
	mosquitto_sub -h 127.0.0.1 -p 8883 --cafile ./tmp/ca.crt --cert ./tmp/client.crt --key ./tmp/client.key --insecure -t devices/$1/messages/events
}

subscribe "device_001" 
