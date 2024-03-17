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

