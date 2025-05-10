#!/bin/bash

# sync files to and from the server
# assumes USER and IP are exported in the terminal

# ./sync.sh install
# ./sync.sh code
# ./sync.sh logs

LOCAL="/Users/daniel/src/github/danielnbarbosa/nes_agent"
REMOTE="/home/${USER}/nes_agent"
ENVS="KungFu-Nes DoubleDragon-Nes"


case "$1" in
  install)
    echo "Syncing install script.  Local ---> server."
    rsync -av ${LOCAL}/roms ${USER}@${IP}:${REMOTE}/
    rsync -av ${LOCAL}/scripts/install.sh  ${USER}@${IP}:${REMOTE}/../
    ;;
  
  code)
    echo "Syncing code.  Local ---> server."
    #rsync -av ${LOCAL_SF}/sample_factory/algo/learning/learner.py  ${USER}@${IP}:${REMOTE_SF}/sample_factory/algo/learning/
    #rsync -av ${LOCAL_SF}/sample_factory/envs/env_wrappers.py  ${USER}@${IP}:${REMOTE_SF}/sample_factory/envs/
    #rsync -av ${LOCAL_SF}/sample_factory/cfg/cfg.py  ${USER}@${IP}:${REMOTE_SF}/sample_factory/cfg/
    rsync -av ${LOCAL}/sample-factory/sf_examples/retro  ${USER}@${IP}:${REMOTE}/sample-factory/sf_examples/
    for ENV in $ENVS
    do
      rsync -av ${LOCAL}/stable-retro/retro/data/stable/$ENV ${USER}@${IP}:${REMOTE}/stable-retro/retro/data/stable/
    done
    rsync -av ${LOCAL}/scripts  ${USER}@${IP}:${REMOTE}/
    ;;

  logs)
    echo "Syncing training logs and results.   Server ---> local."
    rsync -av ${USER}@${IP}:${REMOTE}/sample-factory/train_dir ${LOCAL}/sample-factory/
    ;;

  *)
    echo "Invalid selection."
    ;;
esac
