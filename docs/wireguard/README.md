# Wireguard VPN

Main setup guide: https://www.digitalocean.com/community/tutorials/how-to-set-up-wireguard-on-ubuntu-20-04

**ToC**
- [Wireguard VPN](#wireguard-vpn)
  * [New user setup](#new-user-setup)
    + [Install the wireguard client](#install-the-wireguard-client)
    + [Generate your private and public keys](#generate-your-private-and-public-keys)
      - [Linux](#linux)
      - [OSX](#osx)
    + [Give the public key to your VPN administrator](#give-the-public-key-to-your-vpn-administrator)
    + [Linux](#linux-1)
      - [Connect to the tunnel](#connect-to-the-tunnel)
    + [OSX](#osx-1)
  * [VPN Administrator](#vpn-administrator)
    + [What to do when someone gives you a public key](#what-to-do-when-someone-gives-you-a-public-key)
  * [WireGuard Server info](#wireguard-server-info)
  * [Adding a peer on the Wireguard VPN server](#adding-a-peer-on-the-wireguard-vpn-server)
  * [Removing a peer](#removing-a-peer)
  * [User table](#user-table)

<small><i><a href='http://ecotrust-canada.github.io/markdown-toc/'>Table of contents generated with markdown-toc</a></i></small>


## New user setup

### Install the wireguard client

https://www.wireguard.com/install/

### Generate your private and public keys

#### Linux

Private keys:
```
wg genkey | sudo tee /etc/wireguard/private.key
```

Public keys:
```
sudo cat /etc/wireguard/private.key | wg pubkey | sudo tee /etc/wireguard/public.key
```

#### OSX
https://serversideup.net/how-to-configure-a-wireguard-macos-client/

The `Add an empty tunnel` step will help you to generate your public and private keys


### Give the public key to your VPN administrator
The public key string is not a secret and can be passed around freely via Slack or email.

Give this public key to your VPN administrator.

You should never pass around your private key.


### Linux
Use the file in the same directory as this `README.md` named `client-wg-config.conf`.

Put the content of that config file into your local computer at: `/etc/wireguard/wg0.conf`

Replace the `<clients private key>` with your own private key.

#### Connect to the tunnel

```
sudo wg-quick up wg0
```

Check your local routes:
```
ip route
```

Check the wireguard status:
```
sudo wg
```

Turn off the VPN:
```
sudo wg-quick down wg0
```

### OSX

Follow the directions in this guide: https://serversideup.net/how-to-configure-a-wireguard-macos-client/

Use the file in the same directory as this `README.md` named `client-wg-config.conf`.  This will be your 
config.

Replace the `<clients private key>` with your own private key.



## VPN Administrator

### What to do when someone gives you a public key
This means someones wants to connect to this Wireguard VPN.

The following steps will get them setup.

## WireGuard Server info

* Location: 641669687490 (production AWS account)
* AWS Region: us-east-1

How to access it:
* The ssh port is not enabled on the machine
* You have to use AWS SSM to access the machine
* GUI
  * Log into the AWS production account via the web gui
  * Navigate to: AWS System Manager -> Node Management -> Session Manager
  * Click on "Start Session"
  * Click on the radio button for node `i-02bb2da37071c6c04`
  * Click on "Start Session"
  * A new tab will open up with a web terminal


VPN CIDR: 10.2.200.0/24

## Adding a peer on the Wireguard VPN server
Run on the Wireguard server.

You will use that public key to add the user in:
```
sudo wg set wg0 peer <user/clients public key> allowed-ips 10.2.200.1
```

Check the status:
```
sudo wg
```

## Removing a peer

```
sudo wg set wg0 peer <user/clients public key>  remove
```

## User table
| User           | Assigned IP    | Add command                                                                                  |
|----------------|----------------|----------------------------------------------------------------------------------------------|
| garland        | 10.2.200.1/24  | sudo wg set wg0 peer OnA5n39plVMsap8MkADWgr0RPL0LCbzVFb4gLwSnGTQ= allowed-ips 10.2.200.1     |
|                |                |                                                                                              |
|                |                |                                                                                              |

* Each user **MUST** have a unique "Assigned IP".  The easiest way is to increment the last octet by 1.
* Then run the "Add command" on the Wireguard server
* Add each user to this table for record keeping and also used to decommision a user
