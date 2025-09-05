#!/bin/bash

sudo apt-get update
sudo apt-get --assume-yes upgrade
sudo apt-get --assume-yes install software-properties-common
sudo apt-get --assume-yes install jq
sudo apt-get --assume-yes install build-essential
sudo apt-get --assume-yes install linux-headers-$(uname -r)

# Install Miniconda
wget https://repo.anaconda.com/miniconda/Miniconda3-py312_24.5.0-0-Linux-x86_64.sh
chmod +x Miniconda3-py312_24.5.0-0-Linux-x86_64.sh
./Miniconda3-py312_24.5.0-0-Linux-x86_64.sh -b -p $HOME/miniconda3
~/miniconda3/bin/conda init bash
source ~/.bashrc

# Confirm GPU is attached
lspci | grep -i nvidia
# Confirm GPU not recognized: command not found
nvidia-smi

# Install NVIDIA drivers and CUDA
# https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&Distribution=Ubuntu&target_version=24.04&target_type=deb_local
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2404/x86_64/cuda-ubuntu2404.pin
sudo mv cuda-ubuntu2404.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/13.0.0/local_installers/cuda-repo-ubuntu2404-13-0-local_13.0.0-580.65.06-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu2404-13-0-local_13.0.0-580.65.06-1_amd64.deb
sudo cp /var/cuda-repo-ubuntu2404-13-0-local/cuda-*-keyring.gpg /usr/share/keyrings/
sudo apt-get update
sudo apt-get -y install cuda-toolkit-13-0
source ~/.bashrc

# Install PyTorch
# https://pytorch.org/get-started/locally
pip install torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu129
echo -e "import torch\nprint(torch.cuda.is_available())\nprint(torch.cuda.get_device_name(0))" > test_cuda.py
python test_cuda.py

## run these lines in the vm to make sure port 8188 is open for external access
#sudo ufw allow 8188/tcp
#sudo ufw reload
#sudo firewall-cmd --zone=public --add-port=8188/tcp --permanent
#sudo firewall-cmd --reload
#sudo apt-get install iptables
#sudo iptables -A INPUT -p tcp --dport 8188 -j ACCEPT
