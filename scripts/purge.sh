#!/bin/bash

# delete old checkpoints
# only keep the latest checkpoint from each experiment

cd ../sample-factory/train_dir/

DIRS=$(ls -d SuperMarioBros-Nes_v27*)
for DIR in $DIRS
do
  echo "Purging $DIR"
  CHECKPOINT_DIR=$DIR/checkpoint_p0
  if [ -d "$CHECKPOINT_DIR" ]
  then
    cd $DIR/checkpoint_p0
    LATEST_FILE=$(ls -1 | tail -1)
    if [ -f "$LATEST_FILE" ]
    then
      cp $LATEST_FILE save.pth
      rm checkpoint_*.pth
      mv save.pth $LATEST_FILE
    fi
    cd ../..
  fi
done
