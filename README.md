# docker-ddc-vagrant
Vagrantfile to install Docker Datacenter

## Versions

The Vagrantiles installes 3 virtual machines with the following versions (Updated 2017/02/01):

 * CS Docker Engine 1.13 Beta
 * Docker UCP 2.1.0 Beta
 * Docker DTR 2.2.0 Beta

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

### Environment variables

Create the following folders within your Vagrantfile

config
config/input
config/input/certificates
config/output

Create the following files with necessary environment informations inside the directory of your Vagrantfile:

* config/input/ucp_password (the password that should be used for the ucp admin)
* config/input/hub_username (the username of your DockerID Hub account)
* /config/input/hub_password (the password of zour DockerID Hub account)
* /config/input/image_ucp (name of the image to use for UCP installation)
* /config/input/image_dtr (name of the image to use for DTR installation)

Copy the following certificates into the config certificates folder:

* CA Certificate: configuration/input/certificates/ca.pem
* UCP Private Key: configuration/input/certificates/UCPkey.pem
* UCP Certificate: configuration/input/certificates/UCPcrt.pem
* DTR Private Key: configuration/input/certificates/DTRkey.pem
* DTR Certificate: configuration/input/certificates/DTRcrt.pem

Configure your Mac OS local keychain to trust the certificates by using the Keychain Access tool and import the ca.pem, DTRcrt.pem and UCPkey.pem. 

### License file

Get your license file and put it inside the directory config/input of your Vagrantfile with the name docker_113_beta_subscription.lic

### Create your own CA and Certificates for UCP and DTR

You need to install OpenSSL for Mac. I use Homebrew (http://brew.sh):

```
brew install openssl
```

* Create a CA key pair

```
openssl genrsa -out CAkey.pem 2048
```

* Use the new CA key pair to create to sign the CA certificate

```
openssl req -new -key CAkey.pem -x509 -days 3650 -out ca.pem -sha256
```

* Create a new UCP key pair

```
openssl genrsa -out UCPkey.pem 2048
```

* Use the CA to create a key pair and csr for the UCP server

```
openssl req -subj "/CN=ucp.andreasmac.local" -new -key UCPkey.pem -out UCP.csr -sha256
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

* Use the CA to create a key pair and csr for the DTR server

```
openssl req -subj "/CN=dtr.andreasmac.local" -new -key DTRkey.pem -out DTR.csr -sha256
```

* Use the CA to sign the DTR CSR

```
openssl x509 -req -days 3650 -in DTR.csr -CA ca.pem -CAkey CAkey.pem -CAcreateserial -out DTRcrt.pem -extensions v3_req -sha256
```

* Remove the passphrase from the DTR server's private key

```
 openssl rsa -in DTRkey.pem -out DTRkey.pem
```

* Import your keys into your local MAC.

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
