#!/bin/bash

IP=$(ip route get 1 | awk '{print $NF;exit}')
HOSTNAME=$(hostname)
ORGANIZZATION="myorg"
SUBJECT_CA="/C=SE/ST=Milan/L=Milan/O=$ORGANIZZATION/OU=CA/CN=$HOSTNAME"
SUBJECT_SERVER="/C=SE/ST=Milan/L=Milan/O=$ORGANIZZATION/OU=Server/CN=$HOSTNAME"
SUBJECT_CLIENT="/C=SE/ST=Milan/L=Milan/O=$ORGANIZZATION/OU=Client/CN=$HOSTNAME"

function generate_CA () {
   echo "$SUBJECT_CA"
   openssl req -x509 -nodes -sha256 -newkey rsa:2048 -subj "$SUBJECT_CA"  -days 365 -keyout ca.key -out ca.crt
}

function generate_server () {
   echo "$SUBJECT_SERVER"
   openssl req -nodes -sha256 -new -subj "$SUBJECT_SERVER" -keyout server.key -out server.csr
   openssl x509 -req -sha256 -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt -days 365
}

function generate_client () {
   echo "$SUBJECT_CLIENT"
   openssl req -new -nodes -sha256 -subj "$SUBJECT_CLIENT" -out client.csr -keyout client.key 
   openssl x509 -req -sha256 -in client.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out client.crt -days 365
}

function copy_keys_to_broker () {
   cp ./tmp/ca.crt ./mosquitto/config/certs/
   cp ./tmp/server.crt ./mosquitto/config/certs/
   cp ./tmp/server.key ./mosquitto/config/certs/
}

rm -f ./mosquitto/config/certs/*
rm -f ./tmp/*
mkdir -p ./mosquitto/config/certs/
mkdir -p ./tmp/
pushd ./tmp/
generate_CA
generate_server
generate_client
popd
copy_keys_to_broker

