# Lecture: 12.3.2024 Flow Monitoring

## Hands-on 3: Compute my own IP Flows

Uses CSV file from the previous hands-on work.

1. Executable python script, we will need `csv` module:

```
#!/usr/bin/python3

import csv
```

2. Load (and print) parsed content:

```
with open("export.csv", "r") as f:
    csv_reader = csv.reader(f)
    for row in csv_reader:
        print(row)
```

3. Take IP addresses, protocol, and ports (and print them)

Hints: beware of counting columns from zero --- indexes of an array

4. Aggregate using dictionary

E.g., `flowpackets = {}`

- Count number of packets

```
if flowkey not in flowpackets:
    flowpackets[flowkey] = 1
else:
    flowpackets[flowkey] += 1
```

Optionally, try to sum packet lengths for each flow.

Hints: you can use string concatenation like this:

```
srcip = ...
dstip = ...
proto = ...
srcport = ...
dstport = ...
flowkey = f"{srcip},{dstip},{proto},{srcport},{dstport}"
```

---

# Solution of h-o 3:

```
#!/usr/bin/python3

import csv

flows_pkts = dict()
flows_bytes = dict()
header = True

with open("export.csv", "r") as f:
    csv_reader = csv.reader(f)

    for row in csv_reader:
        if header:
            header = False
            continue

        srcip = row[2]
        dstip = row[3]
        proto = row[4]
        length = row[5]
        srcport = row[6]
        dstport = row[7]

        flowkey = f"{srcip},{dstip},{proto},{srcport},{dstport}"
        # print(flowkey)
        if flowkey not in flows_pkts:
            flows_pkts[flowkey] = 1
            flows_bytes[flowkey] = int(length)
        else:
            flows_pkts[flowkey] += 1
            flows_bytes[flowkey] += int(length)

for key in flows_pkts:
    print(key, flows_pkts[key], flows_bytes[key])
```

