# Deploy a Cisco CSR Cluster on Exoscale

* [Requirements](#requirements)
* [Introduction](#introduction)
* [Deployment Guide](#deployment)
	- [Prepare API Client](#prepareapiclient)
	- [Register a Custom Template on Exoscale](#registertemplate)
* [Basic Configuration](#basicconfig)
	- [Enable SSH](#enablessh)
	- [Add User(#adduser)
	- [Enable HSRP(#enablehsrp)
	- [Check the Standby Status(#checkstandby)


## Requirements

* You have access to the [Exoscale Portal](https://portal.exoscale.com)
* You're familiar with Cisco CSR1000V. If not, start with [Cisco Administration Guide](https://www.cisco.com/c/en/us/td/docs/ios-xml/ios/ipapp_fhrp/configuration/xe-16/fhp-xe-16-book/fhp-hsrp.html) or contact [A1 Digital](mailto:vendors.security@a1.digital)
* You have valid licenses for your Cisco CSR1000V instances
* You're familiar with Linux command line tools and scripting
* You already have some private networks defined on Exoscale you want to make available

## Introduction


## Basic Configuration
### Enable DHCP

csr(config)#hostname csr1
csr1(config)#interface gigabitEthernet 1
csr1(config-if)# ip address dhcp

### Enable SSH

(config)# hostname asr1
(config)# ip domain-name localhost.localdomain
(config)# crypto key generate rsa

(config)# enable secret cisco

(config)# service password-encryption
(config)# line vty 0 4

(config-line)# transport input ssh
(config-line)# login local
(config-line)# password 0 cisco

(config-line)# logging synchronous

(config-line)# login local

### Add User

(config)# username cisco password cisco
(config)# username cisco privilege 15
### Enable HSRP
#### Primary node

asr1(config)#interface gigabitEthernet 2

asr1(config)#ip address 10.0.0.253 255.255.255.0

asr1(config)#standby 1 ip 10.0.0.254

asr1(config)#standby 1 priority 150

asr1(config)#standby 1 preempt delay minimum 5 reload 10

asr1(config)#standby use-bia

#### Secondary node

asr2(config)#interface gigabitEthernet 2

asr2(config)#ip address 10.0.0.252 255.255.255.0

asr2(config)#standby 1 ip 10.0.0.254

asr2(config)#standby 1 priority 10

asr2(config)#standby 1 preempt delay minimum 5 reload 10

asr2(config)#standby use-bia
### Check the Standby Status

asr1#show standby

