#!/bin/bash

# sync latest model from the server and enjoy it
# assumes USER, IP and PORT are exported in the terminal

# ./enjoy.sh SuperMarioBros-Nes v10 1-1 log
# ./enjoy.sh SuperMarioBros-Nes v10 1-1 log-sync
# ./enjoy.sh SuperMarioBros-Nes v10 1-1 eval


LOCAL="/Users/daniel/src/github/danielnbarbosa/nes_agent"
#REMOTE="/home/${USER}/nes_agent"
REMOTE="/workspace/nes_agent"

ENV="$1"
VERSION="$2"
STAGE="$3"


sync () {
echo "Syncing latest checkpoint.   Server ---> local."
rsync -av -e "ssh -o ControlPath=/tmp/ssh-%r@%h:%p -p ${PORT}" "${USER}@${IP}:${REMOTE}/sample-factory/train_dir/${ENV}_${VERSION}/*.*" "${LOCAL}/sample-factory/train_dir/${ENV}_${VERSION}/"
LATEST_FILE=$(ssh -o ControlPath=/tmp/ssh-%r@%h:%p -p ${PORT} ${USER}@${IP} "ls -t ${REMOTE}/sample-factory/train_dir/${ENV}_${VERSION}/checkpoint_p0/checkpoint*.pth | head -n 1")
if [ ${#LATEST_FILE} -gt 0 ]; then
    rsync -av -e "ssh -o ControlPath=/tmp/ssh-%r@%h:%p -p ${PORT}" "${USER}@${IP}:${LATEST_FILE}" "${LOCAL}/sample-factory/train_dir/${ENV}_${VERSION}/checkpoint_p0/"
fi
}


case "$4" in
  log)
    cd ../sample-factory && python -m sf_examples.retro.enjoy_retro --algo=APPO --env=${ENV} --experiment="${ENV}_${VERSION}" \
    --device=cpu  --load_checkpoint_kind=latest --train_dir=${LOCAL}/sample-factory/train_dir --state="Stage${STAGE}" --mode="log"
    ;;
  log-sync)
    sync
    cd ../sample-factory && python -m sf_examples.retro.enjoy_retro --algo=APPO --env=${ENV} --experiment="${ENV}_${VERSION}" \
    --device=cpu  --load_checkpoint_kind=latest --train_dir=${LOCAL}/sample-factory/train_dir --state="Stage${STAGE}" --mode="log"
    ;;
  eval)
    sync
    cd ../sample-factory && python -m sf_examples.retro.enjoy_retro --algo=APPO --env=${ENV} --experiment="${ENV}_${VERSION}" \
    --device=cpu  --load_checkpoint_kind=latest --train_dir=${LOCAL}/sample-factory/train_dir --state="Stage${STAGE}" --mode="eval" --no_render --max_num_episodes=10
    ;;
  eval-cont)
    for i in {1..500}
    do
      sync
      cd ../sample-factory && python -m sf_examples.retro.enjoy_retro --algo=APPO --env=${ENV} --experiment="${ENV}_${VERSION}" \
      --device=cpu  --load_checkpoint_kind=latest --train_dir=${LOCAL}/sample-factory/train_dir --state="Stage${STAGE}" --mode="eval" --no_render --max_num_episodes=10
      sleep 75
    done
    ;;
  movie)
    cd ../sample-factory && python -m sf_examples.retro.enjoy_retro --algo=APPO --env=${ENV} --experiment="${ENV}_${VERSION}" \
    --device=cpu  --load_checkpoint_kind=latest --train_dir=${LOCAL}/sample-factory/train_dir --state="Stage${STAGE}" --mode="eval" --no_render --save_video --max_num_episodes=1
    ;;
  *)
    echo "Invalid option.  Valid options are: log, log-sync, eval, eval-cont, movie."
    ;;
esac
