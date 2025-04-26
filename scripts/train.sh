#!/bin/bash

# use with tmux to preserve session

# ./train.sh cpu v100
# ./train.sh cputest
# ./train.sh gputest
# ./train.sh gpu v100


ENV="KungFu-Nes"

EXPERIMENT_SUFFIX="$2"  #  e.g. "v15_A100"

case "$1" in
  cpu)
    cd ../sample-factory && python -m sf_examples.retro.train_retro --algo=APPO --env=${ENV} --experiment="${ENV}_${EXPERIMENT_SUFFIX}" \
        --device=cpu --with_wandb=True --wandb_project="${ENV}"
    ;;

  cputest)
    cd ../sample-factory && python -m sf_examples.retro.train_retro --algo=APPO --env=${ENV} --experiment="${ENV}_test" \
        --device=cpu --restart_behavior="overwrite"
    ;;

  gpu)
    cd ../sample-factory && python -m sf_examples.retro.train_retro --algo=APPO --env=${ENV} --experiment="${ENV}_${EXPERIMENT_SUFFIX}" \
        --device=gpu --with_wandb=True --wandb_project="${ENV}" --num_workers=60
    ;;

  gputest)
    cd ../sample-factory && python -m sf_examples.retro.train_retro --algo=APPO --env=${ENV} --experiment="${ENV}_test" \
        --device=gpu --restart_behavior="overwrite" --num_workers=60
    ;;

  *)
    echo "Invalid selection."
    ;;
esac