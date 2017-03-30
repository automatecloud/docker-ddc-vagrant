# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(2) do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
    # UCP 2.1 node for DDC
    config.vm.define "ucpnode01" do |ucpnode01|
      ucpnode01.vm.box = "ubuntu/xenial64"
      ucpnode01.vm.network :private_network, ip: "192.168.3.10"
      ucpnode01.vm.hostname = "ucpnode01"
      config.vm.provider :virtualbox do |vb|
         vb.customize ["modifyvm", :id, "--memory", "3072"]
         vb.customize ["modifyvm", :id, "--cpus", "2"]
         vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
         vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      end
      ucpnode01.vm.provision "shell", inline: <<-SHELL
       # Prepare repository
       echo "Prepare repository"
       export DOWNLOAD_LINK=$(cat /vagrant/input/download-link)
       sudo apt-get update
       sudo apt-get install -y apt-transport-https ca-certificates ntp curl software-properties-common
       curl -fsSL ${DOWNLOAD_LINK}/gpg | sudo apt-key add -
       sudo add-apt-repository "deb [arch=amd64] ${DOWNLOAD_LINK} $(lsb_release -cs) stable-17.03"
       sudo apt-get update
       # Install Docker EE
       echo "Install Docker EE"
       sudo apt-get -y install docker-ee
       #Trust self-signed certificates
       cp /vagrant/input/certificates/ca.pem /usr/local/share/ca-certificates/ca.crt
       sudo update-ca-certificates
       sudo usermod -aG docker ubuntu
       docker volume create --name ucp-controller-server-certs
       cp /vagrant/input/certificates/ca.pem /var/lib/docker/volumes/ucp-controller-server-certs/_data/ca.pem
       cp /vagrant/input/certificates/UCPcrt.pem /var/lib/docker/volumes/ucp-controller-server-certs/_data/cert.pem
       cp /vagrant/input/certificates/UCPkey.pem /var/lib/docker/volumes/ucp-controller-server-certs/_data/key.pem
       ifconfig enp0s8 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}' > /vagrant/exchange/ucpnode01-ipaddr
       export UCP_IPADDR=$(cat /vagrant/exchange/ucpnode01-ipaddr)
       export UCP_PASSWORD=$(cat /vagrant/input/ucp_password)
       export HUB_USERNAME=$(cat /vagrant/input/hub_username)
       export HUB_PASSWORD=$(cat /vagrant/input/hub_password)
       export UCP_IMAGE=$(cat /vagrant/input/ucp_image)
       export UCP_SAN=$(cat /vagrant/input/ucp_san)
       docker login -u ${HUB_USERNAME} -p ${HUB_PASSWORD}
       docker pull ${UCP_IMAGE}
       docker run --rm --name ucp -v /var/run/docker.sock:/var/run/docker.sock -v /vagrant/input/docker_subscription.lic:/config/docker_subscription.lic ${UCP_IMAGE} install --host-address ${UCP_IPADDR} --admin-password ${UCP_PASSWORD} --san ${UCP_SAN} --external-server-cert
       docker swarm join-token manager | awk -F " " '/token/ {print $2}' > /vagrant/exchange/swarm-join-token-mgr
       docker swarm join-token worker | awk -F " " '/token/ {print $2}' > /vagrant/exchange/swarm-join-token-worker
       docker run --rm --name ucp -v /var/run/docker.sock:/var/run/docker.sock ${UCP_IMAGE} id | awk '{ print $1}' > /vagrant/exchange/ucpnode01-id
       export UCP_ID=$(cat /vagrant/exchange/ucpnode01-id)
       docker run --rm -i --name ucp -v /var/run/docker.sock:/var/run/docker.sock ${UCP_IMAGE} backup --id ${UCP_ID} --root-ca-only --passphrase "secret" > /vagrant/output/backupucp.tar
      SHELL
    end

    # DTR Node 1 for DDC setup
    config.vm.define "dtrnode01" do |dtrnode01|
      dtrnode01.vm.box = "ubuntu/xenial64"
      dtrnode01.vm.network :private_network, ip: "192.168.3.11"
      dtrnode01.vm.hostname = "dtrnode01"
      config.vm.provider :virtualbox do |vb|
         vb.customize ["modifyvm", :id, "--memory", "3072"]
         vb.customize ["modifyvm", :id, "--cpus", "2"]
         vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
         vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
         #vb.name = "dtrnode01"
      end
      dtrnode01.vm.provision "shell", inline: <<-SHELL
        # Prepare repository
        echo "Prepare repository"
        export DOWNLOAD_LINK=$(cat /vagrant/input/download-link)
        sudo apt-get update
        sudo apt-get install -y apt-transport-https ca-certificates ntp curl software-properties-common
        curl -fsSL ${DOWNLOAD_LINK}/gpg | sudo apt-key add -
        sudo add-apt-repository "deb [arch=amd64] ${DOWNLOAD_LINK} $(lsb_release -cs) stable-17.03"
        sudo apt-get update
        # Install Docker EE
        echo "Install Docker EE"
        sudo apt-get -y install docker-ee
        #Trust self-signed certificates
        cp /vagrant/input/certificates/ca.pem /usr/local/share/ca-certificates/ca.crt
        sudo update-ca-certificates
        sudo usermod -aG docker ubuntu
        ifconfig enp0s8 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}' > /vagrant/exchange/dtrnode01-ipaddr
        export HUB_USERNAME=$(cat /vagrant/input/hub_username)
        export HUB_PASSWORD=$(cat /vagrant/input/hub_password)
        docker login -u ${HUB_USERNAME} -p ${HUB_PASSWORD}
        cat /dev/urandom | tr -dc 'a-f0-9' | fold -w 12 | head -n 1 > /vagrant/exchange/dtr-replica-id
        export UCP_PASSWORD=$(cat /vagrant/input/ucp_password)
        export UCP_IPADDR=$(cat /vagrant/exchange/ucpnode01-ipaddr)
        export DTR_IPADDR=$(cat /vagrant/exchange/dtrnode01-ipaddr)
        export SWARM_JOIN_TOKEN_WORKER=$(cat /vagrant/exchange/swarm-join-token-worker)
        export DTR_REPLICA_ID=$(cat /vagrant/exchange/dtr-replica-id)
        export UCP_IMAGE=$(cat /vagrant/input/ucp_image)
        export DTR_IMAGE=$(cat /vagrant/input/dtr_image)
        export DTR_URL=$(cat /vagrant/input/dtr_url)
        export UCP_URL=$(cat /vagrant/input/ucp_url)
        docker pull ${UCP_IMAGE}
        docker pull ${DTR_IMAGE}
        docker swarm join --token ${SWARM_JOIN_TOKEN_WORKER} ${UCP_IPADDR}:2377
        # Wait for Join to complete
        sleep 30
        # Install DTR
        curl -k https://ucp.docker.vm/ca > ucp-ca.pem
        echo docker run --rm ${DTR_IMAGE} install --hub-username ${HUB_USERNAME} --hub-password ${HUB_PASSWORD} --ucp-url ${UCP_URL} --ucp-node dtrnode01 --replica-id $DTR_REPLICA_ID --dtr-external-url ${DTR_URL} --ucp-username admin --ucp-password ${UCP_PASSWORD} --ucp-ca "$(cat /vagrant/input/certificates/ca.pem)" --dtr-ca "$(cat /vagrant/input/certificates/ca.pem)" --dtr-cert "$(cat /vagrant/input/certificates/DTRcrt.pem)" --dtr-key "$(cat /vagrant/input/certificates/DTRkey.pem)"
        docker run --rm ${DTR_IMAGE} install --hub-username ${HUB_USERNAME} --hub-password ${HUB_PASSWORD} --ucp-url ${UCP_URL} --ucp-node dtrnode01 --replica-id $DTR_REPLICA_ID --dtr-external-url ${DTR_URL} --ucp-username admin --ucp-password ${UCP_PASSWORD} --ucp-ca "$(cat /vagrant/input/certificates/ca.pem)" --dtr-ca "$(cat /vagrant/input/certificates/ca.pem)" --dtr-cert "$(cat /vagrant/input/certificates/DTRcrt.pem)" --dtr-key "$(cat /vagrant/input/certificates/DTRkey.pem)"
        #docker run --rm ${DTR_IMAGE} install --hub-username ${HUB_USERNAME} --hub-password ${HUB_PASSWORD} --ucp-url ${UCP_URL} --ucp-node dtrnode01 --replica-id $DTR_REPLICA_ID --dtr-external-url ${DTR_IPADDR} --ucp-username admin --ucp-password ${UCP_PASSWORD} --ucp-ca "$(cat ucp-ca.pem)"
        # Run backup of DTR
        docker run --rm ${DTR_IMAGE} backup --ucp-url ${UCP_URL} --existing-replica-id ${DTR_REPLICA_ID} --ucp-username admin --ucp-password ${UCP_PASSWORD} --ucp-ca "$(cat ucp-ca.pem)" > /vagrant/output/backup.tar
        # Trust self-signed DTR CA
        openssl s_client -connect ${DTR_IPADDR}:443 -showcerts </dev/null 2>/dev/null | openssl x509 -outform PEM | sudo tee /usr/local/share/ca-certificates/${DTR_IPADDR}.crt
        sudo update-ca-certificates
        sudo service docker restart
        # Wait some seconds and start automate configuration
      SHELL
    end

    # Application Worker Node
    config.vm.define "workernode01" do |workernode01|
      workernode01.vm.box = "ubuntu/xenial64"
      workernode01.vm.network :private_network, ip: "192.168.3.12"
      workernode01.vm.hostname = "workernode01"
      config.vm.provider :virtualbox do |vb|
         vb.customize ["modifyvm", :id, "--memory", "2048"]
         vb.customize ["modifyvm", :id, "--cpus", "2"]
         vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
         vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
         #vb.name = "workernode01"
      end
      workernode01.vm.provision "shell", inline: <<-SHELL
       # Prepare repository
       echo "Prepare repository"
       export DOWNLOAD_LINK=$(cat /vagrant/input/download-link)
       sudo apt-get update
       sudo apt-get install -y apt-transport-https ca-certificates ntp curl software-properties-common
       curl -fsSL ${DOWNLOAD_LINK}/gpg | sudo apt-key add -
       sudo add-apt-repository "deb [arch=amd64] ${DOWNLOAD_LINK} $(lsb_release -cs) stable-17.03"
       sudo apt-get update
       # Install Docker EE
       echo "Install Docker EE"
       sudo apt-get -y install docker-ee
       # Trust self-signed certificates
       cp /vagrant/input/certificates/ca.pem /usr/local/share/ca-certificates/ca.crt
       sudo update-ca-certificates
       sudo usermod -aG docker ubuntu
       ifconfig enp0s8 | grep 'inet addr:' | cut -d: -f2 | awk '{ print $1}' > /vagrant/exchange/workernode01-ipaddr
       export HUB_USERNAME=$(cat /vagrant/input/hub_username)
       export HUB_PASSWORD=$(cat /vagrant/input/hub_password)
       export UCP_IMAGE=$(cat /vagrant/input/ucp_image)
       docker login -u ${HUB_USERNAME} -p ${HUB_PASSWORD}
       docker pull ${UCP_IMAGE}
       # Join Swarm as worker
       export UCP_IPADDR=$(cat /vagrant/exchange/ucpnode01-ipaddr)
       export DTR_IPADDR=$(cat /vagrant/exchange/dtrnode01-ipaddr)
       export SWARM_JOIN_TOKEN_WORKER=$(cat /vagrant/exchange/swarm-join-token-worker)
       docker swarm join --token ${SWARM_JOIN_TOKEN_WORKER} ${UCP_IPADDR}:2377
       # Trust self-signed DTR CA
       openssl s_client -connect ${DTR_IPADDR}:443 -showcerts </dev/null 2>/dev/null | openssl x509 -outform PEM | sudo tee /usr/local/share/ca-certificates/${DTR_IPADDR}.crt
       sudo update-ca-certificates
       sudo service docker restart
       # Install Compose
       # curl -L https://github.com/docker/compose/releases/download/1.10.0-rc2/docker-compose-`uname -s`-`uname -m` > /usr/local/bin/docker-compose
       # chmod +x /usr/local/bin/docker-compose
     SHELL
    end



  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end
end
