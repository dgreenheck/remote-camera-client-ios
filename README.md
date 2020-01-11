# image-server-ios

iOS app for capturing and storing images on a local web server.

## Raspberry Pi Setup

I'm using a Raspberry Pi as the web server, but you can use any other machine you have available.

### 1. Install Raspbian
https://www.raspberrypi.org/documentation/raspbian/

### 2. Setup SSH
To remotely connect to the server, you will need to enable SSH.
https://www.raspberrypi.org/documentation/remote-access/ssh/

### 3. Setup Static IP Address
This step is necessary to prevent the DHCP server from reassigning the Pi a different address each time it is rebooted.
```
sudo nano /etc/dhcpcd.conf
```
Add the following lines to setup a static IP (assuming server is connected to router via wireless). Obviously these parameter will need to be made specific to your network.
```
interface wlan0
static ip_address=192.168.0.200/24
static routers=192.168.0.1
static domain_name_servers=192.168.0.1
```

### 4. Update System Packages
```
sudo apt-get update
sudo apt-get dist-upgrade
```

### 5. Install Node.js
Node.js is an open-source, cross-platform JavaScript run-time environment. The server side JavaScript code will handle transactions between the server-side image database and the client.
```
curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
sudo apt-get install -y nodejs
```
You can check if the installation was successful by checking the version numbers of the installed components.
```
node -v
npm -v
```

### 6. Install MongoDB
MongoDB is a document based database which is used to store the image data captured from the phone. The JavaScript code will interface with the database, querying and modifying data per the client requests.
```
sudo apt-get install mongodb-server
```
Once again you can verify the installation by checking the version number
```
mongodo --version
```
The MongoDB module also has to be installed for Node.js
```
sudo npm install mongodb
```

### 7. (Optional) Setup Port Forwarding
If you want to access your web server outside of your private network, you will need to setup port forwarding on your router. If you only want to use the application on your private network, this step is not necessary.
