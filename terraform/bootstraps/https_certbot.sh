####### bootstrap #######
#!/bin/bash
domainname=`cat /tmp/myhostname`
## Generate Certificate & Sign via Let's Encrypt
certbot-auto certonly --standalone -d ${domainname} -m jonathan.williams@capgemini.com --agree-tos -n --debug
