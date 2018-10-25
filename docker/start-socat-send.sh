#!/bin/bash -ex

[[ $UID == 0 ]] || { echo "You must be root to run this."; exit 1; }

# socat -d -d UDP-LISTEN:5555,reuseaddr "TCP-SENDTO:${PEER_ENDPOINT}:${PEER_PORT}"

