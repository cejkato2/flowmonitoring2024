# Lecture: 12.3.2024 Flow Monitoring

## Hands-on 2: Export packets in processable format

1. Plain text - content of PCAP:
- Wireshark -> File -> Export Packet Dissections -> As Plain Text...
- Check size of the file, compare with the original PCAP file

2. JSON (easy way to load the data for processing)
- Wireshark -> File -> Export Packet Dissections -> As JSON...
- Check size of the file, compare with the original PCAP file

3. Prepare Wireshark columns
- Add column `srcport` for `Source port unresolved`
- Add column `dstport` for `Destination port unresolved`
- Edit Source column to show `Src addr (unresolved)` type
- Edit Destination column to show `Dest addr (unresolved)` type

4. CSV (easy to load)
- Wireshark -> File -> Export Packet Dissections -> As CSV...
- Check size of the file, compare with the original PCAP file

Optional for C programmers: export As "C" arrays...
(the whole packets are encoded as static const unsigned char arrays ;-))

