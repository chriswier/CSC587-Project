# CSC587-Project

This is a simple Dockerfile / container to utilize the DoHlyzer program from https://github.com/ahlashkari/DoHlyzer. This builds a Python 3.7 with all requirements.

How to use:
1. Have Docker installed and running, with your user authorized to build containers.
2. Build the container -- run ./build.sh
3. Run the container -- run ./run.sh

Notable paths:

/code/DoHlyzer -- source code for DoHlyzer

/code/test -- test CSV files generated from DoHlyzer and a labeler for DoH traffic


Notable binaries:

/usr/local/bin/dohlyzer (run in /code/DoHlyzer)

TODO:
1. Make a Python test script that initiates a tcpdump, then randomly does DNS lookups via DoH/non-DoH and pulls down random webpages. This would generate a small PCAP file randomly for lab use data mining that could then be given to dohylzer to analyze.
2. Write directions for using DoHlyzer.

Example DoHlzyer usage:

dohlyzer -f capture.pcap -c capture-stats.csv

Label the csv file:

cd /code/test/ && python3 add-labels.py
