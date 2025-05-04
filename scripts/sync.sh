#!/bin/bash

# sync files to and from the server

# ./sync.sh 129.213.19.97 install
# ./sync.sh 129.213.19.97 code
# ./sync.sh 129.213.19.97 logs


LOCAL="/Users/daniel/src/github/danielnbarbosa/nes_agent"
REMOTE="/home/ubuntu/nes_agent"
ENVS="KungFu-Nes DoubleDragon-Nes"

IP="$1"


case "$2" in
  install)
    echo "Syncing install script.  Local ---> server."
    rsync -av ${LOCAL}/roms ubuntu@${IP}:${REMOTE}/
    rsync -av ${LOCAL}/scripts/install.sh  ubuntu@${IP}:${REMOTE}/../
    ;;
  
  code)
    echo "Syncing code.  Local ---> server."
    #rsync -av ${LOCAL_SF}/sample_factory/algo/learning/learner.py  ubuntu@${IP}:${REMOTE_SF}/sample_factory/algo/learning/
    #rsync -av ${LOCAL_SF}/sample_factory/envs/env_wrappers.py  ubuntu@${IP}:${REMOTE_SF}/sample_factory/envs/
    #rsync -av ${LOCAL_SF}/sample_factory/cfg/cfg.py  ubuntu@${IP}:${REMOTE_SF}/sample_factory/cfg/
    rsync -av ${LOCAL}/sample-factory/sf_examples/retro  ubuntu@${IP}:${REMOTE}/sample-factory/sf_examples/
    for ENV in $ENVS
    do
      rsync -av ${LOCAL}/stable-retro/retro/data/stable/$ENV ubuntu@${IP}:${REMOTE}/stable-retro/retro/data/stable/
    done
    rsync -av ${LOCAL}/scripts  ubuntu@${IP}:${REMOTE}/
    ;;

  logs)
    echo "Syncing training logs and results.   Server ---> local."
    rsync -av ubuntu@${IP}:${REMOTE}/sample-factory/train_dir ${LOCAL}/sample-factory/
    ;;

  *)
    echo "Invalid selection."
    ;;
esac
