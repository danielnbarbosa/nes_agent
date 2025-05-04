#!/bin/bash

# train for some time on many different sections
# allows agent to gain experience deeper in the game more quickly
# M1: 1M env steps in 12 min
# A10: 10M env steps in XX min

# ./train_multi.sh cpu v100
# ./train_multi.sh gpu v100_A10


ENV="DoubleDragon-Nes"
TRAIN_FOR_ENV_STEPS=0

VERSION="$2"  #  e.g. "v15_A100"

cd ../sample-factory


# map environment to stages
if [ $ENV == "KungFu-Nes" ] 
then
    STAGES="1 2 3 4 5"
elif [ $ENV == "DoubleDragon-Nes" ] 
then
    STAGES="1-1-1 1-1-2"
fi

case "$1" in
  cpu)
    STEPS_DELTA=1000000
    for i in {1..10000}
    do
        for STAGE in $STAGES
        do
            let "TRAIN_FOR_ENV_STEPS+=STEPS_DELTA"
            echo "Starting train loop $i on stage $STAGE"
            python -m sf_examples.retro.train_retro --algo=APPO --env=${ENV} --experiment="${ENV}_${VERSION}" --state="Stage${STAGE}" \
              --device=cpu --with_wandb=True --wandb_project="${ENV}" --train_for_env_steps=${TRAIN_FOR_ENV_STEPS}
            echo "Finished train loop $i on stage $STAGE"
            sleep 5  # let things settle before starting next run
            echo "Finished sleep loop $i on stage $STAGE"
            #echo "${STAGE} ${TRAIN_FOR_ENV_STEPS}"
        done
    done
  ;;

  gpu)
    STEPS_DELTA=10000000
    for i in {1..10000}
    do
        for STAGE in $STAGES
        do
            let "TRAIN_FOR_ENV_STEPS+=STEPS_DELTA"
            python -m sf_examples.retro.train_retro --algo=APPO --env=${ENV} --experiment="${ENV}_${VERSION}" --state="Stage${STAGE}" \
              --device=gpu --with_wandb=True --wandb_project="${ENV}" --train_for_env_steps=${TRAIN_FOR_ENV_STEPS} --num_workers=60
            sleep 2  # let things settle before starting next run
            #echo "${STAGE} ${TRAIN_FOR_ENV_STEPS}"
        done
    done
  ;;

  *)
    echo "Invalid selection."
    ;;
esac
