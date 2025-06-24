#!/bin/bash

# train for some time on many different sections
# allows agent to gain experience deeper in the game more quickly
# M1: 1M env steps in 12 min
# A10: 10M env steps in XX min

# ./train_multi.sh cpu v100
# ./train_multi.sh gpu v100_A10


ENV="SuperMarioBros-Nes"
TRAIN_FOR_ENV_STEPS=0

VERSION="$2"

cd ../sample-factory


# map environment to stages
if [ $ENV == "KungFu-Nes" ] 
then
    STAGES="1 2 3 4 5"
elif [ $ENV == "DoubleDragon-Nes" ] 
then
    STAGES="1-1-1 2-1-1"
elif [ $ENV == "SuperMarioBros-Nes" ] 
then
    STAGES="1-1 1-2 1-3 1-4 2-1 2-2 2-3 2-4 3-1 3-2 3-3 3-4"
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
              --device=cpu --with_wandb=True --wandb_project="${ENV}" --train_for_env_steps=${TRAIN_FOR_ENV_STEPS} --mode="train"
            echo "Finished train loop $i on stage $STAGE"
            sleep 5  # let things settle before starting next run
            echo "Finished sleep loop $i on stage $STAGE"
            #echo "${STAGE} ${TRAIN_FOR_ENV_STEPS}"
        done
    done
  ;;

  gpu)
    STEPS_DELTA=20000000
    for i in {1..10000}
    do
        for STAGE in $STAGES
        do
            echo "Starting train loop $i on stage $STAGE"
            let "TRAIN_FOR_ENV_STEPS+=STEPS_DELTA"
            python -m sf_examples.retro.train_retro --algo=APPO --env=${ENV} --experiment="${ENV}_${VERSION}" --state="Stage${STAGE}" \
              --device=gpu --with_wandb=True --wandb_project="${ENV}" --train_for_env_steps=${TRAIN_FOR_ENV_STEPS} --num_workers=192 --mode="train"
            sleep 2  # let things settle before starting next run
            #echo "${STAGE} ${TRAIN_FOR_ENV_STEPS}"
        done
    done
  ;;

  *)
    echo "Invalid selection."
    ;;
esac
