#!/bin/bash

set -e

echo "[INFO] Updating system packages..."
sudo apt update -y
sudo apt install -y apt-transport-https ca-certificates curl gnupg lsb-release software-properties-common
#!/bin/bash

# Update and install bash-completion
sudo apt update
sudo apt install -y bash-completion

# Enable bash-completion if not already in .bashrc
if ! grep -q "bash_completion" /home/vagrant/.bashrc; then
  echo "if [ -f /etc/bash_completion ]; then" >> /home/vagrant/.bashrc
  echo "  . /etc/bash_completion" >> /home/vagrant/.bashrc
  echo "fi" >> /home/vagrant/.bashrc
fi

# Ensure permissions and ownership are correct
chown vagrant:vagrant /home/vagrant/.bashrc

# Detect OS
DISTRO=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
CODENAME=$(lsb_release -cs)

echo "[INFO] Detected OS: $DISTRO ($CODENAME)"

# Add Docker GPG key
echo "[INFO] Adding Docker GPG key..."
curl -fsSL https://download.docker.com/linux/$DISTRO/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add Docker repository
echo "[INFO] Adding Docker APT repository..."
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/$DISTRO \
  $CODENAME stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update APT again and install Docker
echo "[INFO] Installing Docker..."
sudo apt update -y
sudo apt install -y docker-ce docker-ce-cli containerd.io

# Enable Docker service
echo "[INFO] Enabling and starting Docker service..."
sudo systemctl enable docker
sudo systemctl start docker

# Optional: Add vagrant user to docker group
echo "[INFO] Adding 'vagrant' user to docker group..."
sudo usermod -aG docker vagrant

echo "[INFO] Docker installation complete!"

