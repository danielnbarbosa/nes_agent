#!/bin/bash

# watch agent, optionally save a video

# ./enjoy.sh DoubleDragon-Nes v28 best 1-1-1
# ./enjoy.sh DoubleDragon-Nes v28 best 1-1-1 save
# ./enjoy.sh DoubleDragon-Nes v28 best 1-1-1 norender

LOCAL="/Users/daniel/src/github/danielnbarbosa/nes_agent"

ENV="$1"  # e.g. DoubleDragon-Nes
VERSION="$2"  #  e.g. "v15_A100"
CHECKPOINT="$3"  # latest or best
STAGE="$4"

case "$5" in
  save)
    cd ../sample-factory && python -m sf_examples.retro.enjoy_retro --algo=APPO --env=${ENV} --experiment="${ENV}_${VERSION}" \
           --device=cpu  --load_checkpoint_kind=${CHECKPOINT} --train_dir=${LOCAL}/sample-factory/train_dir --state="Stage${STAGE}" --save_video --max_num_episodes=1
    ;;
  norender)
    cd ../sample-factory && python -m sf_examples.retro.enjoy_retro --algo=APPO --env=${ENV} --experiment="${ENV}_${VERSION}" \
           --device=cpu  --load_checkpoint_kind=${CHECKPOINT} --train_dir=${LOCAL}/sample-factory/train_dir --state="Stage${STAGE}" --no_render
    ;;
  *)
    cd ../sample-factory && python -m sf_examples.retro.enjoy_retro --algo=APPO --env=${ENV} --experiment="${ENV}_${VERSION}" \
           --device=cpu  --load_checkpoint_kind=${CHECKPOINT} --train_dir=${LOCAL}/sample-factory/train_dir --state="Stage${STAGE}"
    ;;
esac