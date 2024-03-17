# Walk through - hands-on tasks, flow monitoring infrastructure

## Installation of the flow exporter

- Download rpms.tar.gz and extract the files
- Install deb packages from local directory:

`sudo apt update`
`sudo apt -y install ./*.deb`

## Test ipfixprobe

1. Look at help

- `ipfixprobe -h`
- `ipfixprobe -h input`
- `ipfixprobe -h output`

2. Read PCAP

- We have a PCAP file from previous lecture (traffic.pcap)
- `ipfixprobe -i "pcap;f=$HOME/Downloads/traffic.pcap" -o text`

Can you compare the results with the handson from the previous lecture?

3. Monitor own network interface

- `ipfixprobe -i "raw;i=eth0" -o text`

## IPFIX output

1. Run in one terminal (netcat listening on 4739/TCP, hexdump prints binary data in readable format):

`nc -lp 4739 | hexdump`

2. Run wireshark lo

3. Start ipfixprobe in the second terminal:

- `ipfixprobe -i "pcap;f=traffic.pcap" -o 'ipfix'`

(or the same with explicit IPFIX collector target)

- `ipfixprobe -i "pcap;f=traffic.pcap" -o 'ipfix;h=127.0.0.1;p=4739'`

4. Check IPFIX format in wireshark

## JSON output - printing

1. Download IPFIXcol2 collector configuration: file `ipfixcol2jsonprint.xml`

2. Run in the first terminal:

`ipfixcol2 -c ./ipfixcol2jsonprint.xml`

3. Run in the second terminal:

`sudo ipfixprobe -i "raw;i=eth0" -o "ipfix;h=127.0.0.1;p=4739"`

or alternatively using libpcap:

`sudo ipfixprobe -i "pcap;i=eth0" -o "ipfix;h=127.0.0.1;p=4739"`

Do not forget `sudo` - we access to hardware so we need privilege.

Generator for IPFIXcol2 configuration: https://cesnet.github.io/ipfixcol2/

## Store and query flow data

1. Download IPFIXcol2 collector configuration: file `ipfixcol2fds.xml`

2. Run in the first terminal:

```
mkdir /tmp/flows
ipfixcol2 -c ipfixcol2fds.xml
```

3. Run in the second terminal:

```
sudo ipfixprobe -i "raw;i=eth0" -o "ipfix;h=127.0.0.1;p=4739"
```

4. And watch the content of `/tmp/flows/...`, wait for data

5. Try to get stored data (with in your dates)

To query the collected data example:

`fdsdump -r '/tmp/flows/2024/03/15/flows.*.fds' -o table -A srcip,srcport,dstip,dstport,proto -c 10`

Example with filter:

`fdsdump -r '/tmp/flows/2024/03/15/flows.*.fds' -o table -A srcip,srcport,dstip,dstport,proto -F 'src ip 10.0.2.15' -c 10`

Example with aggregation:

`fdsdump -r '/tmp/flows/2024/03/15/flows.*.fds' -A 'srcip,dstip' -S 'bytes,packets,flows' -O 'bytes/desc,packets/desc' -o table -c 10`

`fdsdump -r 'flows.fds' -A 'srcip' -S 'bytes,packets,flows' -O 'bytes/desc,packets/desc' -o table -c 10`

And example with JSON format output:

`fdsdump -r '/tmp/flows/2024/03/15/flows.*.fds' -A 'srcip,dstip' -S 'bytes,packets,flows' -o json`

## Systemd start

Flow exporter & flow collector are usually started on boot.  We can do it with prepared systemd service.

1. for ipfixprobe

Copy /etc/ipfixprobe/link0.conf.example to /etc/ipfixprobe/link0.conf and update the line with:
`INPUT[0]="pcap;ifc=eno2"` (uncomment, change eno2 to eth0, or any NIC You need)

Hint: `sudo cp /etc/ipfixprobe/link0.conf{.example,}`

Now with the config, we can start flow exporter as a system service (it will start at boot, it will be restarted automatically)

Enable service with the new link0.conf using this command:

`systemctl enable --now ipfixprobe@link0.service`

2. for IPFIXcol2

- Use your configuration ipfixcol2fds.xml and copy it to /etc/ipfixcol2/startup.xml
- Enable service using: `systemctl enable --now ipfixcol2.service`

