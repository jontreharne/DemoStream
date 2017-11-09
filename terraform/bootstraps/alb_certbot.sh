#!/bin/bash
domainname=`cat /tmp/myhostname`

## download & install Certbot
curl -O https://dl.eff.org/certbot-auto
chmod +x certbot-auto
mv certbot-auto /usr/local/bin/certbot-auto
sleep 5
##### Force Renew of Certificate ######
#/usr/local/bin/certbot-auto certonly --standalone -d ${domainname} -m jonathan.williams@capgemini.com --staging -n --debug --agree-tos
#aws iam upload-server-certificate --server-certificate-name ${domainname} --certificate-body file:///etc/letsencrypt/live/${domainname}/cert.pem --private-key file:///etc/letsencrypt/live/${domainname}/privkey.pem --certificate-chain file:///etc/letsencrypt/live/${domainname}/chain.pem
