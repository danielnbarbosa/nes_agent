#!/bin/bash

# parse the connect string from vast.ai

CONNECT_STRING="$1"

PORT=$(echo $CONNECT_STRING | awk '{print $3}')
USER=$(echo $CONNECT_STRING | awk '{print $4}' | awk -F'@' '{print $1}')
IP=$(echo $CONNECT_STRING | awk '{print $4}' | awk -F'@' '{print $2}')

echo "export PORT=$PORT"
echo "export USER=$USER"
echo "export IP=$IP"