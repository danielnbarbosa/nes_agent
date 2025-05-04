#!/bin/bash

# use with tmux to preserve session

# ./train.sh cpu DoubleDragon-Nes v100 1-1-1
# ./train.sh cputest DoubleDragon-Nes
# ./train.sh gputest DoubleDragon-Nes
# ./train.sh gpu DoubleDragon-Nes v100 1-1-1



ENV="$2"  # e.g. DoubleDragon-Nes
VERSION="$3"  #  e.g. v15_A100
STAGE="$4"  # e.g. 1-1-1

case "$1" in
  cpu)
    cd ../sample-factory && python -m sf_examples.retro.train_retro --algo=APPO --env=${ENV} --experiment="${ENV}_${VERSION}" \
        --device=cpu --with_wandb=True --wandb_project="${ENV}" --state="Stage${STAGE}"
    ;;

  cputest)
    cd ../sample-factory && python -m sf_examples.retro.train_retro --algo=APPO --env=${ENV} --experiment="${ENV}_test" \
        --device=cpu --restart_behavior="overwrite"
    ;;

  gpu)
    cd ../sample-factory && python -m sf_examples.retro.train_retro --algo=APPO --env=${ENV} --experiment="${ENV}_${VERSION}" \
        --device=gpu --with_wandb=True --wandb_project="${ENV}" --num_workers=60 --state="Stage${STAGE}"
    ;;

  gputest)
    cd ../sample-factory && python -m sf_examples.retro.train_retro --algo=APPO --env=${ENV} --experiment="${ENV}_test" \
        --device=gpu --restart_behavior="overwrite" --num_workers=60
    ;;

  *)
    echo "Invalid selection."
    ;;
esac