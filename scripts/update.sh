#!/bin/bash

# push latest code changes to server

# assumes USER, IP and PORT are exported in the terminal

# ./update.sh


LOCAL="/Users/daniel/src/github/danielnbarbosa/nes_agent"
REMOTE="/workspace/nes_agent"
ENVS="KungFu-Nes DoubleDragon-Nes"


echo "Syncing code.  Local ---> server."
#rsync -av -e "ssh -p $PORT" ${LOCAL}/sample-factory/sample_factory/algo/learning/learner.py  ${USER}@${IP}:${REMOTE}/sample-factory/sample_factory/algo/learning/
#rsync -av -e "ssh -p $PORT" ${LOCAL}/sample-factory/sample_factory/envs/env_wrappers.py  ${USER}@${IP}:${REMOTE}/sample-factory/sample_factory/envs/
#rsync -av -e "ssh -p $PORT" ${LOCAL}/sample-factory/sample_factory/cfg/cfg.py  ${USER}@${IP}:${REMOTE}/sample-factory//sample_factory/cfg/
rsync -av -e "ssh -p $PORT -o ControlPath=/tmp/ssh-%r@%h:%p" ${LOCAL}/sample-factory/sf_examples/retro  ${USER}@${IP}:${REMOTE}/sample-factory/sf_examples/
for ENV in $ENVS
do
    rsync -av -e "ssh -p $PORT -o ControlPath=/tmp/ssh-%r@%h:%p" ${LOCAL}/stable-retro/retro/data/stable/$ENV ${USER}@${IP}:${REMOTE}/stable-retro/retro/data/stable/
done
rsync -av -e "ssh -p $PORT -o ControlPath=/tmp/ssh-%r@%h:%p" ${LOCAL}/scripts  ${USER}@${IP}:${REMOTE}/

