#!/bin/bash -ex

# Install Wireguard. This has to be done dynamically since the kernel
# module depends on the host kernel version.
apt update -y
# apt upgrade -y
apt install -y linux-headers-$(uname -r)
apt-get install -y wireguard

"$@"
