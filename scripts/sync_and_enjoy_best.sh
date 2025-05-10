#!/bin/bash

# sync best model from the server and enjoy it
# assumes USER and IP are exported in the terminal

# ./sync_and_enjoy_best.sh v100_A10 1


LOCAL="/Users/daniel/src/github/danielnbarbosa/nes_agent"
REMOTE="/home/${USER}/nes_agent"
ENV="DoubleDragon-Nes"

VERSION="$1"  #  e.g. "v15_A100"
STAGE="$2"

echo "Syncing best results.   Server ---> local."
rsync -av ${USER}@${IP}:${REMOTE}/sample-factory/train_dir/${ENV}_${VERSION}/checkpoint_p0/best*.pth ${LOCAL}/sample-factory/train_dir/${ENV}_${VERSION}/checkpoint_p0/

cd ../sample-factory && python -m sf_examples.retro.enjoy_retro --algo=APPO --env=${ENV} --experiment="${ENV}_${VERSION}" \
        --device=cpu  --load_checkpoint_kind=best --train_dir=${LOCAL}/sample-factory/train_dir --state="Stage${STAGE}.state"