#!/bin/bash

# watch agent, optionally save a video

# ./enjoy.sh DoubleDragon-Nes v28 1-1-1
# ./enjoy.sh DoubleDragon-Nes v28 1-1-1 save
# ./enjoy.sh DoubleDragon-Nes v28 1-1-1 norender
# ./enjoy.sh DoubleDragon-Nes v28 1-1-1 eval
# ./enjoy.sh DoubleDragon-Nes v28 1-1-1 log

LOCAL="/Users/daniel/src/github/danielnbarbosa/nes_agent"
CHECKPOINT="latest"  # latest or best

ENV="$1"  # e.g. DoubleDragon-Nes
VERSION="$2"  #  e.g. "v15_A100"
STAGE="$3"

case "$4" in
  save)
    cd ../sample-factory && python -m sf_examples.retro.enjoy_retro --algo=APPO --env=${ENV} --experiment="${ENV}_${VERSION}" \
           --device=cpu  --load_checkpoint_kind=${CHECKPOINT} --train_dir=${LOCAL}/sample-factory/train_dir --state="Stage${STAGE}" --save_video --max_num_episodes=1
    ;;
  norender)
    cd ../sample-factory && python -m sf_examples.retro.enjoy_retro --algo=APPO --env=${ENV} --experiment="${ENV}_${VERSION}" \
           --device=cpu  --load_checkpoint_kind=${CHECKPOINT} --train_dir=${LOCAL}/sample-factory/train_dir --state="Stage${STAGE}" --no_render
    ;;
  eval)
    cd ../sample-factory && python -m sf_examples.retro.enjoy_retro --algo=APPO --env=${ENV} --experiment="${ENV}_${VERSION}" \
           --device=cpu  --load_checkpoint_kind=${CHECKPOINT} --train_dir=${LOCAL}/sample-factory/train_dir --state="Stage${STAGE}" --no_render --mode="eval"
    ;;
  log)
    cd ../sample-factory && python -m sf_examples.retro.enjoy_retro --algo=APPO --env=${ENV} --experiment="${ENV}_${VERSION}" \
           --device=cpu  --load_checkpoint_kind=${CHECKPOINT} --train_dir=${LOCAL}/sample-factory/train_dir --state="Stage${STAGE}" --mode="log"
    ;;
  *)
    cd ../sample-factory && python -m sf_examples.retro.enjoy_retro --algo=APPO --env=${ENV} --experiment="${ENV}_${VERSION}" \
           --device=cpu  --load_checkpoint_kind=${CHECKPOINT} --train_dir=${LOCAL}/sample-factory/train_dir --state="Stage${STAGE}"
    ;;
esac