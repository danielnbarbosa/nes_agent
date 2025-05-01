#!/bin/bash

# sync best model from the server and enjoy it

# ./sync_and_enjoy_best.sh $IP v100_A10 1


LOCAL="/Users/daniel/src/github/danielnbarbosa/nes_agent"
REMOTE="/home/ubuntu/nes_agent"
ENV="KungFu-Nes"

IP="$1"
EXPERIMENT_SUFFIX="$2"  #  e.g. "v15_A100"
FLOOR="$3"

echo "Syncing best results.   Server ---> local."
rsync -av ubuntu@${IP}:${REMOTE}/sample-factory/train_dir/${ENV}_${EXPERIMENT_SUFFIX}/checkpoint_p0/best*.pth ${LOCAL}/sample-factory/train_dir/${ENV}_${EXPERIMENT_SUFFIX}/checkpoint_p0/

cd ../sample-factory && python -m sf_examples.retro.enjoy_retro --algo=APPO --env=${ENV} --experiment="${ENV}_${EXPERIMENT_SUFFIX}" \
        --device=cpu  --load_checkpoint_kind=best --train_dir=${LOCAL}/sample-factory/train_dir --state="1Player.Level${FLOOR}.state"