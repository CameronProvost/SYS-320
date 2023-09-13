#!/bin/bash

# Run the "ip addr" command and filter the output to extract the IP address
ip addr | awk '/inet / {split($2, a, "/"); print a[1]}'

