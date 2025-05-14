#!/bin/bash

# sync files to and from the server
# assumes USER, IP and PORT are exported in the terminal

# ./sync.sh install
# ./sync.sh code
# ./sync.sh logs

LOCAL="/Users/daniel/src/github/danielnbarbosa/nes_agent"
#REMOTE="/home/${USER}/nes_agent"
REMOTE="/workspace/nes_agent"
ENVS="KungFu-Nes DoubleDragon-Nes"



case "$1" in
  install)
    echo "Syncing install script.  Local ---> server."
    rsync -av -e "ssh -p ${PORT}" ${LOCAL}/roms ${USER}@${IP}:${REMOTE}/
    rsync -av -e "ssh -p ${PORT}" ${LOCAL}/scripts/install.sh  ${USER}@${IP}:${REMOTE}/../
    ;;
  
  code)
    echo "Syncing code.  Local ---> server."
    #rsync -av -e "ssh -p $PORT" ${LOCAL}/sample-factory/sample_factory/algo/learning/learner.py  ${USER}@${IP}:${REMOTE}/sample-factory/sample_factory/algo/learning/
    #rsync -av -e "ssh -p $PORT" ${LOCAL}/sample-factory/sample_factory/envs/env_wrappers.py  ${USER}@${IP}:${REMOTE}/sample-factory/sample_factory/envs/
    rsync -av -e "ssh -p $PORT" ${LOCAL}/sample-factory/sample_factory/cfg/cfg.py  ${USER}@${IP}:${REMOTE}/sample-factory//sample_factory/cfg/
    rsync -av -e "ssh -p $PORT" ${LOCAL}/sample-factory/sf_examples/retro  ${USER}@${IP}:${REMOTE}/sample-factory/sf_examples/
    for ENV in $ENVS
    do
      rsync -av -e "ssh -p $PORT" ${LOCAL}/stable-retro/retro/data/stable/$ENV ${USER}@${IP}:${REMOTE}/stable-retro/retro/data/stable/
    done
    rsync -av -e "ssh -p $PORT" ${LOCAL}/scripts  ${USER}@${IP}:${REMOTE}/
    ;;

  logs)
    echo "Syncing training logs and results.   Server ---> local."
    rsync -av -e "ssh -p $PORT" ${USER}@${IP}:${REMOTE}/sample-factory/train_dir ${LOCAL}/sample-factory/
    ;;

  *)
    echo "Invalid selection."
    ;;
esac
