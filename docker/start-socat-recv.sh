#!/bin/bash -ex

[[ $UID == 0 ]] || { echo "You must be root to run this."; exit 1; }

# socat -d -d TCP-LISTEN:5182,reuseaddr UDP-SENDTO:localhost:5182

# socat -d -d TCP-LISTEN:5182,fork UDP:localhost:5182
