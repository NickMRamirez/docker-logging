HAPROXY_VERSION = "2.6"

install_haproxy = %Q{
    curl https://haproxy.debian.net/bernat.debian.org.gpg | gpg --dearmor > /usr/share/keyrings/haproxy.debian.net.gpg
    echo deb "[signed-by=/usr/share/keyrings/haproxy.debian.net.gpg]" http://haproxy.debian.net bullseye-backports-#{HAPROXY_VERSION} main > /etc/apt/sources.list.d/haproxy.list
    apt-get update
    apt-get install -y haproxy=#{HAPROXY_VERSION}.\*

    cp /vagrant/haproxy/haproxy.cfg /etc/haproxy/
    systemctl reload haproxy
}

install_docker = %Q{
    export DEBIAN_FRONTEND=noninteractive

    # Install Docker
    if [ ! $(which docker) ]; then
      sudo apt-get update
      sudo apt-get -y install ca-certificates curl gnupg
      sudo install -m 0755 -d /etc/apt/keyrings
      curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
      sudo chmod a+r /etc/apt/keyrings/docker.gpg
      echo \
        "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
        "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
      sudo apt-get update
      sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

      # Configure logging driver to be syslog
      mkdir -p /etc/docker
      cp /vagrant/haproxy/daemon.json /etc/docker/
      systemctl restart docker

    else
      echo "docker already installed."
    fi
}

Vagrant.configure("2") do |config|

  config.vm.define "haproxy" do |server|
    server.vm.box = "debian/bullseye64"
    server.vm.hostname = "haproxy"
    server.vm.provision "shell", inline: install_haproxy
    server.vm.provision "shell", inline: install_docker
    server.vm.network "private_network", ip: "192.168.56.41"
  end

  config.vm.define "syslog1" do |server|
    server.vm.box = "debian/bullseye64"
    server.vm.hostname = "syslog1"
    server.vm.provision "shell", inline: install_docker
    server.vm.network "private_network", ip: "192.168.56.42"
  end
end