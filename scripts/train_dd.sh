#!/bin/bash

# use with tmux to preserve session

# ./train_dd.sh cpu v100 4
# ./train_dd.sh cputest
# ./train_dd.sh gputest
# ./train_dd.sh gpu v100 4


ENV="DoubleDragon-Nes"

EXPERIMENT_SUFFIX="$2"  #  e.g. "v15_A100"
STAGE="$3"

case "$1" in
  cpu)
    cd ../sample-factory && python -m sf_examples.retro.train_retro --algo=APPO --env=${ENV} --experiment="${ENV}_${EXPERIMENT_SUFFIX}" \
        --device=cpu --with_wandb=True --wandb_project="${ENV}" --state="1Player.ModeA.Level${STAGE}"
    ;;

  cputest)
    cd ../sample-factory && python -m sf_examples.retro.train_retro --algo=APPO --env=${ENV} --experiment="${ENV}_test" \
        --device=cpu --restart_behavior="overwrite"
    ;;

  gpu)
    cd ../sample-factory && python -m sf_examples.retro.train_retro --algo=APPO --env=${ENV} --experiment="${ENV}_${EXPERIMENT_SUFFIX}" \
        --device=gpu --with_wandb=True --wandb_project="${ENV}" --num_workers=60 --state="1Player.ModeA.Level${STAGE}"
    ;;

  gputest)
    cd ../sample-factory && python -m sf_examples.retro.train_retro --algo=APPO --env=${ENV} --experiment="${ENV}_test" \
        --device=gpu --restart_behavior="overwrite" --num_workers=60
    ;;

  *)
    echo "Invalid selection."
    ;;
esac