#!/bin/bash

# ssh to server with heartbeat to keep connection alive

# ./ssh.sh 104.171.202.217


IP="$1"

ssh -o ServerAliveInterval=60 -o ServerAliveCountMax=5 ubuntu@${IP}