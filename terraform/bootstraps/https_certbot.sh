####### bootstrap #######
#!/bin/bash
## Generate Certificate & Sign via Let's Encrypt
certbot-auto certonly --standalone -d webserver2.jws-awsome-domain.co.uk -m jonathan.williams@capgemini.com --agree-tos -n --debug
## Add SSL vHost to /etc/httpd/conf.d/ssl.conf ##

## Restart Apache to pick up changes
service httpd restart
##### Create Route53 Record Set #####
www.jws-awsome-domain.co.uk
##### Generate New Certifcate using certbot-auto ####
certbot-auto certonly --standalone -d www.jws-awsome-domain.co.uk -m jonathan.williams@capgemini.com --agree-tos -n --debug
#### Upload to IAM ####
cd /etc/letsencrypt/live/www.jws-awsome-domain.co.uk/
aws iam upload-server-certificate --server-certificate-name www.jws-awsome-domain.co.uk --certificate-body file://cert.pem --private-key file://privkey.pem --certificate-chain file://chain.pem
