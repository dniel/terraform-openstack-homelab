HELM ?=v3.19.0
SONOBUOY ?= 0.57.3

KUBECTL ?= $(shell curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)
CLUSTERCTL ?= 0.4.0

deps: helm kubectl tofu sonobuoy

arkade:
	curl -sLS https://get.arkade.dev | sh

# Install latest helm
helm: arkade
	arkade get helm

# Install known latest tofu
tofu: arkade
	arkade get tofu

# Install latest kubectl
kubectl: arkade
	arkade get kubectl

# Install latest known clusterctl
clusterctl: arkade
	arkade get clusterctl

jq: arkade
	arkade get jq

# Install latest known sonobuoy
sonobuoy: jq
	curl -L "https://github.com/vmware-tanzu/sonobuoy/releases/download/v${SONOBUOY}/sonobuoy_${SONOBUOY}_linux_amd64.tar.gz" --output sonobuoy.tar.gz && \
	mkdir -p tmp && \
	tar -xzf sonobuoy.tar.gz -C tmp/ && \
	chmod +x tmp/sonobuoy && \
	sudo mv tmp/sonobuoy /usr/local/bin/sonobuoy && \
	rm -rf sonobuoy.tar.gz tmp

# Run conformance
conformance:
	sonobuoy run --sonobuoy-image ghcr.io/stackhpc/sonobuoy:v${SONOBUOY} --systemd-logs-image ghcr.io/stackhpc/systemd-logs:v0.3 --mode=certified-conformance

# Retrieve conformance results, requires kubectl
result:
	$(eval dir=k8s-conformance/$(shell kubectl version --short=true | grep Server | cut -f3 -d' ')/)
	$(eval output=$(shell sonobuoy retrieve))
	mkdir -p /tmp/${output} ${dir}
	tar xzf ${output} -C /tmp/${output}
	cp /tmp/${output}/plugins/e2e/results/global/* ${dir}
	rm -rf /tmp/${output} ${output}