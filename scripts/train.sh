#!/bin/bash

# use with tmux to preserve session

# ./train.sh gpu SuperMarioBros-Nes v10 1-1
# ./train.sh cpu SuperMarioBros-Nes v10 1-1
#
# ./train.sh gputest SuperMarioBros-Nes
# ./train.sh cputest SuperMarioBros-Nes


ENV="$2"
VERSION="$3"
STAGE="$4"

case "$1" in
  cpu)
    cd ../sample-factory && python -m sf_examples.retro.train_retro --algo=APPO --env=${ENV} --experiment="${ENV}_${VERSION}" \
        --device=cpu --with_wandb=True --wandb_project="${ENV}" --state="Stage${STAGE}" --mode="train"
    ;;

  cputest)
    cd ../sample-factory && python -m sf_examples.retro.train_retro --algo=APPO --env=${ENV} --experiment="${ENV}_test" \
        --device=cpu --restart_behavior="overwrite" --num_workers=1 --mode="train"
    ;;

  gpu)
    cd ../sample-factory && python -m sf_examples.retro.train_retro --algo=APPO --env=${ENV} --experiment="${ENV}_${VERSION}" \
        --device=gpu --with_wandb=True --wandb_project="${ENV}" --num_workers=192 --state="Stage${STAGE}" --mode="train"
    ;;

  gputest)
    cd ../sample-factory && python -m sf_examples.retro.train_retro --algo=APPO --env=${ENV} --experiment="${ENV}_test" \
        --device=gpu --restart_behavior="overwrite" --num_workers=192 --mode="train"
    ;;

  *)
    echo "Invalid selection."
    ;;
esac