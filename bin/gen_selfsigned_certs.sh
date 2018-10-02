#!/usr/bin/env bash
#
# script for generating self-signed certificates for development
#
# (referenced: https://docs.docker.com/engine/security/https/)
#
# last update: 2018.10.02.

EXPIRE_IN=3650	# valid for 10 years

NUM_BITS=2048
C="US"
ST="New York"
L="Brooklyn"
O="Example Company"

# command line arguments
args=( "$@" )
num_args=${#args[@]}

if [ $num_args -gt 0 ]; then
	# hostname
	hostname="${args[0]}"

	echo "Server's hostname: ${hostname}"

	# ip addresses
	ips=("${args[@]:1}")
	ips+=("127.0.0.1")

	echo "Allowed ips: ${ips[@]}"

	for i in "${!ips[@]}"; do
		ips[$i]="IP:${ips[$i]}"
	done
	ip_addrs=$(IFS=, ; echo "${ips[*]}")

	echo "Generating server certificates..."

	# generate server certificates,
	openssl genrsa -aes256 -out ca-key.pem $NUM_BITS && \
	openssl req -new -x509 -days $EXPIRE_IN -key ca-key.pem -sha256 -out ca.pem -subj "/C=$C/ST=$ST/L=$L/O=$O/CN=$hostname" && \
	openssl genrsa -out server-key.pem $NUM_BITS && \
	openssl req -subj "/CN=$hostname" -sha256 -new -key server-key.pem -out server.csr && \
	echo "subjectAltName = DNS:$hostname,$ip_addrs" > extfile.cnf && \
	echo "keyUsage = keyEncipherment, dataEncipherment" >> extfile.cnf && \
	echo "extendedKeyUsage = serverAuth, clientAuth" >> extfile.cnf && \
	openssl x509 -req -days $EXPIRE_IN -sha256 -in server.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out server-cert.pem -extfile extfile.cnf

	echo "Generating client certificates..."

	# and client certificates,
	openssl genrsa -out key.pem $NUM_BITS && \
	openssl req -subj '/CN=client' -new -key key.pem -out client.csr && \
	echo "keyUsage = keyEncipherment, dataEncipherment" > extfile.cnf && \
	echo "extendedKeyUsage = clientAuth" >> extfile.cnf && \
	openssl x509 -req -days $EXPIRE_IN -sha256 -in client.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out cert.pem -extfile extfile.cnf

	echo "Cleaning up..."

	# then clean up files...
	rm client.csr server.csr extfile.cnf && \
	chmod 0600 ca-key.pem key.pem server-key.pem && \
	chmod 0644 ca.pem server-cert.pem cert.pem
else
	# print usage
	echo "Usage:"
	echo " $ $0 HOST_NAME [ALLOWED_IP_ADDR1] [ALLOWED_IP_ADDR2] ..."
	echo
	echo "Example:"
	echo " $ $0 my.hostname.com"
	echo " $ $0 dev.hostname.com 192.168.0.11 192.168.0.12"
fi

