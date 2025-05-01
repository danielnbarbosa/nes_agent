#!/bin/bash

# prep lambda labs server for training

echo "Installing deps"
echo "---------------"
sudo apt update
sudo apt install build-essential libssl-dev zlib1g-dev libbz2-dev \
    libreadline-dev libsqlite3-dev curl git libncursesw5-dev xz-utils \
    tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev -y  # to build newer python
sudo apt install python3-opengl xvfb -y  # for training using stable-retro
pip install pipx pipenv
mkdir nes_agent
cd nes_agent

echo "Installing pyenv"
echo "---------------"
curl -fsSL https://pyenv.run | bash
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.profile
echo '[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.profile
echo 'eval "$(pyenv init - bash)"' >> ~/.profile
. ~/.profile

echo "Installing sample-factory"
echo "-------------------------"
git clone https://github.com/danielnbarbosa/sample-factory.git
yes | pipenv install sample-factory --python=3.12.9

echo "Installing stable-retro"
echo "-----------------------"
git clone https://github.com/danielnbarbosa/stable-retro.git
cd stable-retro
pipenv run pip install -e .
pipenv install stable-baselines3 pyglet==1.5.27  # for training using stable-retro
pipenv run python -m retro.import ../roms

echo ""
echo "Now run:"
echo './sync.sh $IP code  (on local)'
echo "cd nes_agent"
echo "pipenv shell"
echo "cd scripts"
echo "wandb login"
echo "tmux"
echo "./train.sh gpu vXX 1"
echo './sync.sh $IP logs  (on local)'
echo "./enjoy.sh vXX_A10 best 1  (on local)"