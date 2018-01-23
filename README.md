# docker-ddc-vagrant
Vagrantfile to install Docker Datacenter

## Versions

The Vagrantiles installes 3 virtual machines with the following versions (Updated 2018/01/23):

 * Docker Enterprise Engine 17.06 (GA)
 * Docker UCP 2.2.5
 * Docker DTR 2.4.1

## Requirements

### Download vagrant from Vagrant website

```
https://www.vagrantup.com/downloads.html
```

### Download some Vagrant plugins

```
vagrant plugin install vagrant-hostsupdater
vagrant plugin install vagrant-multiprovider-snap
```

### Install Virtual Box

```
https://www.virtualbox.org/wiki/Downloads
```

### General recommendations

The environment is currently limited to 3 systems and you should not change the names of the systems and also not the IP addresses unless you really need to. Otherwise there is no guarantee that the setup works.

1. A UCP Manager node with name ucpnode01 that will be available via the SAN ucp.docker.vm available via IP 192.168.3.10
2. A Docker Trusted Registry UCP Worker Node dtrnode01 that will be available via the DTR dtr.docker.vm available via IP 192.168.3.11
3. A UCP Worker Node workernode01 available via IP 192.168.3.12

The UCP Swarm is not restricted to run container workload only on worker nodes.

### Environment variables

The following folder input is part of the repository and it should include all necessary configuration files

Create the following files with necessary environment informations inside the directory of your Vagrantfile:

* input/ucp_password (the password that should be used for the ucp admin)
* input/download-link (the individual Docker EE download link for Docker Datacenter on Ubuntu you get via store.docker.com)
* input/hub_username (the username of your DockerID account)
* input/hub_password (the password of zour DockerID account)
* input/ucp_image (name of the image to use for UCP installation ex. docker/ucp:2.2.5)
* input/dtr_image (name of the image to use for DTR installation ex. docker/dtr:2.4.1)
* input/ucp_san (the UCP SAN used within your UCP certificates ex. ucp.docker.vm. Please don't change it)
* input/ucp_url (the complete UCP URL ex. https://ucp.docker.vm)

Copy the following certificates into the config certificates folder (If you don't have certificates please find insctructions below:

* CA Certificate: input/certificates/ca.pem
* UCP Private Key: input/certificates/UCPkey.pem
* UCP Certificate: input/certificates/UCPcrt.pem
* DTR Private Key: input/certificates/DTRkey.pem
* DTR Certificate: input/certificates/DTRcrt.pem

Configure your Mac OS local keychain to trust the certificates by using the Keychain Access tool and import the ca.pem, DTRcrt.pem and UCPkey.pem.

The output folder will include backups and the exchange folder informations that will be transferred between all VMs via files.

### License file

Get your license file on Docker Store (https:/store.docker.com) and put it inside the directory input of your Vagrantfile with the name input/docker_subscription.lic

### Create your own CA and Certificates for UCP and DTR

You need to install OpenSSL for Mac. I use Homebrew (http://brew.sh):

```
brew install openssl
```

* Create a CA key pair

```
openssl genrsa -out CAkey.pem 2048
```

* Use the new CA key pair to create to sign the CA certificate. You should give it the CN ca.docker.vm. You can use what ever country codes etc. necessary.

```
openssl req -new -key CAkey.pem -x509 -days 3650 -out ca.pem -sha256
```

* Create a new UCP key pair

```
openssl genrsa -out UCPkey.pem 2048
```

* Use the CA to create a key pair and csr for the UCP server. you should use the CA name ucp.docker.vm!

```
openssl req -subj "/CN=ucp.docker.vm" -new -key UCPkey.pem -out UCP.csr -sha256
```

* Use the CA to sign the UCP CSR

```
openssl x509 -req -days 3650 -in UCP.csr -CA ca.pem -CAkey CAkey.pem -CAcreateserial -out UCPcrt.pem -extensions v3_req -sha256
```

* Remove the passphrase from the UCP server's private key

```
 openssl rsa -in UCPkey.pem -out UCPkey.pem
```

* Create a new DTR key pair

```
openssl genrsa -out DTRkey.pem 2048
```

* Use the CA to create a key pair and csr for the DTR server. You should use the CN dtr.docker.vm!

```
openssl req -subj "/CN=dtr.docker.vm" -new -key DTRkey.pem -out DTR.csr -sha256
```

* Use the CA to sign the DTR CSR

```
openssl x509 -req -days 3650 -in DTR.csr -CA ca.pem -CAkey CAkey.pem -CAcreateserial -out DTRcrt.pem -extensions v3_req -sha256
```

* Remove the passphrase from the DTR server's private key

```
 openssl rsa -in DTRkey.pem -out DTRkey.pem
```

* Import your keys into your local MAC by using the Keychain Access application. I import them always as trusted certificates, so you will have no red non trusted certificate messages within your browser.

## Usage

### Bring up/resume UCP, DTR, and Worker nodes

```
vagrant up
```
or

```
vagrant up ucpnode01 dtrnode1 workernode01
```

### Stop UCP, DTR, and Worker nodes

```
vagrant halt
```
or

```
vagrant halt ucpnode01 dtrnode1 workernode01
```
### Destroy UCP, DTR, and Worker nodes

```
vagrant destroy
```
or

```
vagrant destroy ucpnode01 dtrnode1 workernode01
```
### Using Snapshots to quickly roll back

I recommend installing the plugin vagrant-multiprovider-snap to take snapshots and quickly move back to old stable state. You can install the plugin with the following:

```
vagrant plugin install vagrant-multiprovider-snap
```

### Create a snapshot

You should create a snapshot after the deployment of the DDC finished. You should also specify a name for the snapshot.

```
vagrant snap take --name="DDC Basic installation"
```

### Rollback to a snapshot

You can simply roll back to an existing snapshot by using the following command with or without specification of the name

```
vagrant snap rollback --name="DDC Basic installation"
```
