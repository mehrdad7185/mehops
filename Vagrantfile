# -*- mode: ruby -*-
# vi: set ft=ruby :

# Define box images
IMAGE_UBUNTU_2204 = "bento/ubuntu-22.04"
IMAGE_DEBIAN_12   = "bento/debian-12"

Vagrant.configure(2) do |config|
  # Controller Node: reverse proxy + Prometheus + Grafana
  config.vm.define "controller" do |controller_vm|
    controller_vm.vm.box = IMAGE_UBUNTU_2204
    controller_vm.vm.hostname = "controller"
    controller_vm.vm.network "private_network", ip: "192.168.56.10"
    controller_vm.vm.network "forwarded_port", guest: 80, host: 8080
    controller_vm.vm.network "forwarded_port", guest: 3000, host: 3000
    controller_vm.vm.network "forwarded_port", guest: 9090, host: 9090
    controller_vm.vm.provider "virtualbox" do |v|
      v.name = "controller"
      v.memory = 4096
      v.cpus = 2
    end
    # All machines use the same bootstrap script
    controller_vm.vm.provision "shell", path: "bootstrap.sh"
  end

  # Worker 1: WordPress + DB
  config.vm.define "worker1" do |worker_vm|
    worker_vm.vm.box = IMAGE_DEBIAN_12
    worker_vm.vm.hostname = "worker1"
    worker_vm.vm.network "private_network", ip: "192.168.56.11"
    worker_vm.vm.network "forwarded_port", guest: 80, host: 8081
    worker_vm.vm.provider "virtualbox" do |v|
      v.name = "worker1"
      v.memory = 2048
      v.cpus = 2
    end
    # All machines use the same bootstrap script
    worker_vm.vm.provision "shell", path: "bootstrap.sh"
  end

  # Worker 2: ELK stack
  config.vm.define "worker2" do |worker_vm|
    worker_vm.vm.box = IMAGE_DEBIAN_12
    worker_vm.vm.hostname = "worker2"
    worker_vm.vm.network "private_network", ip: "192.168.56.12"
    worker_vm.vm.network "forwarded_port", guest: 5601, host: 5601
    worker_vm.vm.provider "virtualbox" do |v|
      v.name = "worker2"
      v.memory = 8192
      v.cpus = 3
    end
    # All machines use the same bootstrap script
    worker_vm.vm.provision "shell", path: "bootstrap.sh"
  end

  # Worker 3: Loki + exporters
  config.vm.define "worker3" do |worker_vm|
    worker_vm.vm.box = IMAGE_DEBIAN_12
    worker_vm.vm.hostname = "worker3"
    worker_vm.vm.network "private_network", ip: "192.168.56.13"
    worker_vm.vm.provider "virtualbox" do |v|
      v.name = "worker3"
      v.memory = 1024
      v.cpus = 1
    end
    # All machines use the same bootstrap script
    worker_vm.vm.provision "shell", path: "bootstrap.sh"
  end
end
