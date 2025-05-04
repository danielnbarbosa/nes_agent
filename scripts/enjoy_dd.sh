#!/bin/bash

# watch agent, optionally save a video

# ./enjoy_dd.sh v28 best 1
# ./enjoy_dd.sh v28 best 1 save


LOCAL_SF="/Users/daniel/src/github/danielnbarbosa/nes_agent/sample-factory"
ENV="DoubleDragon-Nes"

EXPERIMENT_SUFFIX="$1"  #  e.g. "v15_A100"
CHECKPOINT="$2"  # latest or best
STAGE="$3"

case "$4" in
  save)
    cd ../sample-factory && python -m sf_examples.retro.enjoy_retro --algo=APPO --env=${ENV} --experiment="${ENV}_${EXPERIMENT_SUFFIX}" \
           --device=cpu  --load_checkpoint_kind=${CHECKPOINT} --train_dir=${LOCAL_SF}/train_dir --state="1Player.ModeA.Level${STAGE}" --save_video --max_num_episodes=1
    ;;
  norender)
    cd ../sample-factory && python -m sf_examples.retro.enjoy_retro --algo=APPO --env=${ENV} --experiment="${ENV}_${EXPERIMENT_SUFFIX}" \
           --device=cpu  --load_checkpoint_kind=${CHECKPOINT} --train_dir=${LOCAL_SF}/train_dir --state="1Player.ModeA.Level${STAGE}" --no_render
    ;;
  *)
    cd ../sample-factory && python -m sf_examples.retro.enjoy_retro --algo=APPO --env=${ENV} --experiment="${ENV}_${EXPERIMENT_SUFFIX}" \
           --device=cpu  --load_checkpoint_kind=${CHECKPOINT} --train_dir=${LOCAL_SF}/train_dir --state="1Player.ModeA.Level${STAGE}"
    ;;
esac