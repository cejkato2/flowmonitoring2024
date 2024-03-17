# Scapy

Scapy: create, send, sniff, dissect and manipulate network packets.

1. Investigate Scapy

```
# list of "commands" of Scapy
lsc()

# list of "layers" - Protocols
ls()

# show Protocol header (RFC figure)
rfc(IP)
rfc(TCP)
rfc(UDP)

help(IP)
help(TCP)
help(UDP)
```

2. Create my own packet

```
ip = IP(dst="10.0.2.1")
ip.show()
ip.show2()

icmp = ICMP()

pkt = ip / icmp
pkt.show()

# Send our packet:
response = sr1(pkt)
```

3. Read PCAP

```
pcap = rdpcap("../01/traffic.pcap")
pcap
pcap[0]
pcap[0].show()
pcap[TCP][0].show()

help(sniff)
# or
sniff?
```

4. Capture live traffic

```
# Capture 1 packet (get list of packets) with BPF filter "udp port 53" at eth0
pkts = sniff(1, filter="udp port 53", iface="eth0")
pkt = pkts[0]

pkt.show()
pkt.show2()
```

