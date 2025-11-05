SONOBUOY ?= 0.57.3

deps: helm kubectl tofu sonobuoy

arkade:
	curl -sLS https://get.arkade.dev | sh
	mkdir $$HOME/.arkade && chown -R ubuntu:ubuntu $$HOME/.arkade

# Install latest helm
helm: arkade
	arkade get helm
	sudo mv $$HOME/.arkade/bin/helm /usr/local/bin/
	sudo chmod +x /usr/local/bin/helm

# Install known latest tofu
tofu: arkade
	arkade get tofu
	sudo mv $$HOME/.arkade/bin/tofu /usr/local/bin/
	sudo chmod +x /usr/local/bin/tofu

# Install latest kubectl
kubectl: arkade
	arkade get kubectl
	sudo mv $$HOME/.arkade/bin/kubectl /usr/local/bin/
	sudo chmod +x /usr/local/bin/kubectl

# Install latest known clusterctl
clusterctl: arkade
	arkade get clusterctl
	sudo mv $$HOME/.arkade/bin/clusterctl /usr/local/bin/
	sudo chmod +x /usr/local/bin/clusterctl

jq: arkade
	arkade get jq
	sudo mv $$HOME/.arkade/bin/jq /usr/local/bin/
	sudo chmod +x /usr/local/bin/jq

packer:
	wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
	sudo apt update && sudo apt install packer

govc:
	# Extract govc binary to /usr/local/bin.
	# Note: The "tar" command must run with root permissions.
	curl -L -o - "https://github.com/vmware/govmomi/releases/latest/download/govc_$(uname -s)_$(uname -m).tar.gz" | tar -C /usr/local/bin -xvzf - govc

docker:
	# Add Docker's official GPG key:
	sudo install -m 0755 -d /etc/apt/keyrings
	sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
	sudo chmod a+r /etc/apt/keyrings/docker.asc

	# Add the repository to Apt sources:
	echo \
	  "deb [arch=$$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
	  $$(. /etc/os-release && echo "$${UBUNTU_CODENAME:-$$VERSION_CODENAME}") stable" | \
	  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

	# install docker
	sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

	# post install
	sudo groupadd -f docker
	sudo usermod -aG docker ubuntu

	sudo systemctl enable docker
	sudo systemctl start docker