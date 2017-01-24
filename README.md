# docker-ddc-vagrant
Vagrantfile to install Docker Datacenter

## Versions

The Vagrantiles installes 3 virtual machines with the following versions (Updated 2017/01/23):

 * CS Docker Engine 1.13 Beta
 * Docker UCP 2.1.0 Beta
 * Docker DTR 2.2.0 Beta

## Requirements

### Download vagrant from Vagrant website

```
https://www.vagrantup.com/downloads.html
```

### Install Virtual Box

```
https://www.virtualbox.org/wiki/Downloads
```

### Environment variables

Create the following files with necessary environment informations inside the directory of your Vagrantfile:

* ucp_password (the password that should be used for the ucp admin)
* hub_username (the username of your DockerID Hub account)
* hub_password (the password of zour DockerID Hub account)

### License file

Get your license file and put it inside the directory of your Vagrantfile with the name docker_113_beta_subscription.lic

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
