#!/bin/bash

# ssh to server with heartbeat to keep connection alive
# assumes USER, IP and PORT are exported in the terminal

# ./ssh.sh


ssh -o ServerAliveInterval=60 -o ServerAliveCountMax=5 -p ${PORT} ${USER}@${IP}