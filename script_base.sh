#!/bin/bash

apt update && apt install sudo 
sudo apt-get update
sudo apt-get install -y  ca-certificates     curl     gnupg     lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo   "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
$(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
sudo curl -L https://github.com/docker/compose/releases/download/v2.5.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

mkdir docker
cd docker/
mkdir appdata
mkdir custom 
mkdir logs 
mkdir scripts
mkdir secrets 
mkdir shared 
touch .env 
touch docker-compose.yml 
sudo chown -R root:root secrets/ 
sudo chmod -R 600 secrets/ 
sudo chown -R root:root .env 
sudo chmod -R 600 .env 
cd .. 
sudo apt install acl 
sudo chmod -R 775 docker/ 
sudo setfacl -Rdm g:docker:rwx /root/docker 
sudo setfacl -Rm g:docker:rwx /root/docker 
cd docker 
echo "PUID=1000
PGID=1000
TZ=\"America/Chicago\"
USERDIR=\"/root\"
DOCKERDIR=\"/root/docker\"
DATADIR=\"/media/storage\"" > .env 
cd shared 
echo "sainikhilnaru:$apr1$le8qz67b$k9lDqoz3BqZGjMPhYgY/z0" > .htpasswd 
cd .. 
echo "PUID=1000
PGID=1000
TZ=\"America/Chicago\"
USERDIR=\"/root\"
DOCKERDIR=\"/root/docker\"
DATADIR=\"/media/storage\"
DOMAINNAME_CLOUD_SERVER=oktaicenaru.site
LOCAL_IPS=127.0.0.1/32,10.0.0.0/8,192.168.0.0/16,172.16.0.0/12
CLOUDFLARE_IPS=173.245.48.0/20,103.21.244.0/22,103.22.200.0/22,103.31.4.0/22,141.101.64.0/18,108.162.192.0/18,190.93.240.0/20,188.114.96.0/20,197.234.240.0/22,198.41.128.0/17,162.158.0.0/15,104.16.0.0/13,104.24.0.0/14,172.64.0.0/13,131.0.72.0/22" > .env
cd appdata/ 
mkdir traefik2 
mkdir traefik2/acme 
mkdir traefik2/rules 
mkdir traefik2/rules/cloudserver 
touch traefik2/acme/acme.json 
chmod 600 traefik2/acme/acme.json 
cd .. 
cd logs/ 
mkdir cloudserver 
cd cloudserver/ 
mkdir traefik 
cd traefik/ 
touch traefik.log 
touch access.log 
cd .. 
cd .. 
cd .. 

git clone https://github.com/sainikhilnaru/AutomateApps.git 
cd AutomateApps/ 
cp docker-compose1.yml /root/docker/docker-compose.yml 
cd .. 
cd secrets 
echo "sainikhilnaru@gmail.com" > cf_email
echo "7ef4546c71a090cd9aec24448c8d5727da7f4" > cf_api_key
cd .. 
echo "PUID=1000
PGID=1000
TZ=\"America/Chicago\"
USERDIR=\"/root\"
DOCKERDIR=\"/root/docker\"
DATADIR=\"/media/storage\"
DOMAINNAME_CLOUD_SERVER=oktaicenaru.site
CLOUDFLARE_EMAIL=sainikhilnaru@gmail.com
LOCAL_IPS=127.0.0.1/32,10.0.0.0/8,192.168.0.0/16,172.16.0.0/12
CLOUDFLARE_IPS=173.245.48.0/20,103.21.244.0/22,103.22.200.0/22,103.31.4.0/22,141.101.64.0/18,108.162.192.0/18,190.93.240.0/20,188.114.96.0/20,197.234.240.0/22,198.41.128.0/17,162.158.0.0/15,104.16.0.0/13,104.24.0.0/14,172.64.0.0/13,131.0.72.0/22" > .env
cd appdata/ 
cd traefik2/rules/  
cd cloudserver/ 
cp /root/docker/AutomateApps/middlewares1.yml middlewares.yml 

echo "http:
  middlewares:
    chain-no-auth:
      chain:
        middlewares:
          - middlewares-rate-limit
          - middlewares-https-redirectscheme
          - middlewares-secure-headers
          - middlewares-compress

    chain-basic-auth:
      chain:
        middlewares:
          - middlewares-rate-limit
          - middlewares-https-redirectscheme
          - middlewares-secure-headers
          - middlewares-basic-auth
          - middlewares-compress" > middlewares-chains.yml
echo "tls:
  options:
    tls-opts:
      minVersion: VersionTLS12
      cipherSuites:
        - TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256
        - TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        - TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384
        - TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        - TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305
        - TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305
        - TLS_AES_128_GCM_SHA256
        - TLS_AES_256_GCM_SHA384
        - TLS_CHACHA20_POLY1305_SHA256
        - TLS_FALLBACK_SCSV # Client is doing version fallback. See RFC 7507
      curvePreferences:
        - CurveP521
        - CurveP384
      sniStrict: true" > tls-opts.yml
cd .. 
cd .. 
cd .. 
cd .. 
sudo mv shared/.htpasswd secrets/htpasswd 
cd secrets/ 
sudo chown root:root htpasswd 
sudo chmod -R 600 * 
cd .. 
sudo docker compose up -d
