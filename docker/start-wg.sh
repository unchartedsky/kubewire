#!/bin/bash -ex

[[ $UID == 0 ]] || { echo "You must be root to run this."; exit 1; }

# Handle shutdown behavior
finish () {
    echo "$(date): Shutting down Wireguard"
    wg-quick down $interface
    exit 0
}

trap finish SIGTERM SIGINT SIGQUIT

echo "Enabling IPv4 Forwarding"
sysctl -w net.ipv4.conf.all.forwarding=1 || echo "Failed to enable IPv4 Forwarding"

echo "Generating server keys"
if [[ "${WG_PRIVATE_KEY}" != "" ]]; then
	echo -n "${WG_PRIVATE_KEY}" | tee /tmp/wg_private_key
fi

if [[ ! -f /tmp/wg_private_key ]]; then
	wg genkey | tee /tmp/wg_private_key 
fi

if [[ "${WG_PUBLIC_KEY}" != "" ]]; then
	echo -n "${WG_PUBLIC_KEY}" | tee /tmp/wg_public_key
else
	cat /tmp/wg_private_key | wg pubkey | tee /tmp/wg_public_key
fi

echo "Configuring wireguard"
# [#] ip link add wg0 type wireguard
# [#] wg setconf wg0 /dev/fd/63
# [#] ip address add 192.168.2.1 dev wg0
# [#] ip link set mtu 1420 dev wg0
# [#] ip link set wg0 up
# [#] ip route add 192.168.2.2/32 dev wg0
# [#] iptables -A FORWARD -i wg0 -j ACCEPT; iptables -A FORWARD -o wg0 -j ACCEPT; iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

ip link add dev wg0 type wireguard
wg set wg0 private-key /tmp/wg_private_key
wg set wg0 listen-port 5182 # FIXME move configuration to ConfigMap
ip address add "${WG_ADDRESS}" dev wg0 # FIXME move routes to ConfigMap

echo "Activating wireguard network interface"
ip link set up dev wg0

# iptables rules to forward all of the incoming traffic from the private network to the outside world
#echo "Routing all incoming traffic to the outside world"
#iptables -A FORWARD -i wg0 -j ACCEPT
#iptables -A FORWARD -i wg0 -o eth0 -m state --state RELATED,ESTABLISHED -j ACCEPT
#iptables -A FORWARD -i eth0 -o wg0 -m state --state RELATED,ESTABLISHED -j ACCEPT
#iptables -t nat -A POSTROUTING -s 10.0.0.0/16 -o eth0 -j MASQUERADE
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

# keep running
echo "Running"
while true; do wg show wg0; sleep 15; done # FIXME maybe replace with supervisord?
# while true; do echo "running"; sleep 15; done
