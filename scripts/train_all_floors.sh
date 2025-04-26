#!/bin/bash

# train for some time on each floor
# allows agent to gain experience deeper in the game more quickly
# M1: 1M env steps in 6.5 min
# A100: 10M env steps in 7.5 min
# A100: 10M env steps in 6 min

# ./train_all_floors.sh cpu v100
# ./train_all_floors.sh gpu v100_A10


ENV="KungFu-Nes"
TRAIN_FOR_ENV_STEPS=0

EXPERIMENT_SUFFIX="$2"  #  e.g. "v15_A100"

cd ../sample-factory

case "$1" in
  cpu)
    STEPS_DELTA=1000000
    for i in {1..10000}
    do
        for FLOOR in {1..5}
        do
            let "TRAIN_FOR_ENV_STEPS+=STEPS_DELTA" 
            python -m sf_examples.retro.train_retro --algo=APPO --env=${ENV} --experiment="${ENV}_${EXPERIMENT_SUFFIX}" --state="1Player.Level${FLOOR}.state" \
              --device=cpu --with_wandb=True --wandb_project="${ENV}" --train_for_env_steps=${TRAIN_FOR_ENV_STEPS}
            sleep 2  # let things settle before starting next run
            #echo "${FLOOR} ${TRAIN_FOR_ENV_STEPS}"
        done
    done
  ;;

  gpu)
    STEPS_DELTA=10000000
    for i in {1..10000}
    do
        for FLOOR in {1..5}
        do
            let "TRAIN_FOR_ENV_STEPS+=STEPS_DELTA" 
            python -m sf_examples.retro.train_retro --algo=APPO --env=${ENV} --experiment="${ENV}_${EXPERIMENT_SUFFIX}" --state="1Player.Level${FLOOR}.state" \
              --device=gpu --with_wandb=True --wandb_project="${ENV}" --train_for_env_steps=${TRAIN_FOR_ENV_STEPS} --num_workers=60
            sleep 2  # let things settle before starting next run
            #echo "${FLOOR} ${TRAIN_FOR_ENV_STEPS}"
        done
    done
  ;;

  *)
    echo "Invalid selection."
    ;;
esac