# image-server-ios

iOS app for capturing and storing images on a local web server.

## Raspberry Pi Setup

I'm using a Raspberry Pi as the web server, but you can use any other machine you have available.

### 1. Install Raspbian

https://www.raspberrypi.org/documentation/raspbian/

### 2. Setup SSH

To remotely connect to the server, you will need to enable SSH.

https://www.raspberrypi.org/documentation/remote-access/ssh/

### 3. Install Node.js

Node.js is an open-source, cross-platform JavaScript run-time environment. The server side JavaScript code will handle transactions between the server-side image database and the client.

First, update and upgrade your system packages
```
sudo apt-get update
sudo apt-get dist-upgrade
```

Next, install Node.js
```
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
sudo apt-get install -y nodejs
```

You can check if the installation was successful by executing
```
node -v
```
