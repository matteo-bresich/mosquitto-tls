# mosquitto-tls
This is a collection of scripts and tools that will allow you to run mosquitto mqtt broker with tls connections quickly.

# Requirements
- openssl
- docker
- docker-compose
- bash shell
- mosquitto-clients

# Quick start

## Generate certificates
```
./gencert.sh
```

## Start mosquitto service:
```
cd mosquitto
docker-compose up
```
