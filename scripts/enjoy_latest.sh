#!/bin/bash

# sync latest model from the server and enjoy it
# assumes USER, IP and PORT are exported in the terminal

# ./enjoy_latest.sh KungFu-Nes v100_A10 1
# ./enjoy_latest.sh KungFu-Nes v100_A10 1 save
# ./enjoy_latest.sh KungFu-Nes v100_A10 1 norender


LOCAL="/Users/daniel/src/github/danielnbarbosa/nes_agent"
#REMOTE="/home/${USER}/nes_agent"
REMOTE="/workspace/nes_agent"

ENV="$1"
VERSION="$2"
STAGE="$3"

echo "Syncing latest results.   Server ---> local."
rsync -av -e "ssh -p ${PORT}" ${USER}@${IP}:${REMOTE}/sample-factory/train_dir/${ENV}_${VERSION}/checkpoint_p0/checkpoint*.pth ${LOCAL}/sample-factory/train_dir/${ENV}_${VERSION}/checkpoint_p0/



case "$4" in
  save)
    cd ../sample-factory && python -m sf_examples.retro.enjoy_retro --algo=APPO --env=${ENV} --experiment="${ENV}_${VERSION}" \
        --device=cpu  --load_checkpoint_kind=latest --train_dir=${LOCAL}/sample-factory/train_dir --state="Stage${STAGE}.state" --save_video --max_num_episodes=1
    ;;
  norender)
    cd ../sample-factory && python -m sf_examples.retro.enjoy_retro --algo=APPO --env=${ENV} --experiment="${ENV}_${VERSION}" \
        --device=cpu  --load_checkpoint_kind=latest --train_dir=${LOCAL}/sample-factory/train_dir --state="Stage${STAGE}.state" --no_render
    ;;
  *)
    cd ../sample-factory && python -m sf_examples.retro.enjoy_retro --algo=APPO --env=${ENV} --experiment="${ENV}_${VERSION}" \
        --device=cpu  --load_checkpoint_kind=latest --train_dir=${LOCAL}/sample-factory/train_dir --state="Stage${STAGE}.state"
    ;;
esac