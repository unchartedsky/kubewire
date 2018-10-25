#!/bin/bash -ex

# include `persistent-keepalive 25` for NAT
# https://www.wireguard.com/quickstart/#nat-and-firewall-traversal-persistence
# wg set wg0 peer ${PEER_PUBLIC_KEY} allowed-ips 0.0.0.0/0 endpoint localhost:5555 persistent-keepalive 25

# wg set wg0 peer ${PEER_PUBLIC_KEY} allowed-ips 0.0.0.0/0 persistent-keepalive 25

