#!/bin/bash

# setup remote server

# ssh to server with heartbeat to keep connection alive
# assumes USER, IP and PORT are exported in the terminal

# ./setup.sh


LOCAL="/Users/daniel/src/github/danielnbarbosa/nes_agent"
REMOTE="/workspace/nes_agent"

# establish master for rsyncs to use
ssh -MNf -o ControlMaster=yes -o ControlPath=/tmp/ssh-%r@%h:%p -o StrictHostKeyChecking=no -o ServerAliveInterval=60 -o ServerAliveCountMax=5 -p ${PORT} ${USER}@${IP}

# sync install script
echo "Syncing install script.  Local ---> server."
rsync -av -e "ssh -p ${PORT} -o ControlPath=/tmp/ssh-%r@%h:%p" ${LOCAL}/roms ${USER}@${IP}:${REMOTE}/
rsync -av -e "ssh -p ${PORT} -o ControlPath=/tmp/ssh-%r@%h:%p" ${LOCAL}/scripts/install.sh  ${USER}@${IP}:${REMOTE}/../

# ssh as usual
ssh -o StrictHostKeyChecking=no -o ServerAliveInterval=60 -o ServerAliveCountMax=5 -p ${PORT} ${USER}@${IP}

# optinally close when done
#ssh -O exit -o ControlPath=/tmp/ssh-%r@%h:%p -p ${PORT} ${USER}@${IP}

