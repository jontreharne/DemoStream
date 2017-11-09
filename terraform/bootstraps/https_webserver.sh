####### bootstrap #######
#!/bin/bash
domainname=`cat /tmp/myhostname`
yum update -y
yum install httpd -y
service httpd start
chkconfig httpd on
cat <<EOF >/var/www/html/index.html
<html>
<head>
  <title>Let's Encrypt Demo</title>
</head>
<body>
<h1>Hello Digital DevOps Brum!</h1>
<h2>This is $domainname</h2>
</body>
</html>
EOF
echo "healthy" > /var/www/html/healthy.html

## download & install Certbot
curl -O https://dl.eff.org/certbot-auto
chmod +x certbot-auto
mv certbot-auto /usr/local/bin/certbot-auto

####### make webserver HTTPS and terminate in Apache #######
## Install Apache mod_ssl module
yum install mod_ssl -y

cat <<EOF >/etc/httpd/conf.d/ssl.conf
LoadModule ssl_module modules/mod_ssl.so
Listen 443
<VirtualHost *:443>
DocumentRoot /var/www/html
ServerName $domainname
SSLEngine on
SSLCertificateFile /etc/letsencrypt/live/$domainname/cert.pem
SSLCertificateKeyFile /etc/letsencrypt/live/$domainname/privkey.pem
SSLCertificateChainFile /etc/letsencrypt/live/$domainname/chain.pem
SSLProtocol             all -SSLv2 -SSLv3
SSLCipherSuite          ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:AES:CAMELLIA:DES-CBC3-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!MD5:!PSK:!aECDH:!EDH-DSS-DES-CBC3-SHA:!EDH-RSA-DES-CBC3-SHA:!KRB5-DES-CBC3-SHA
SSLHonorCipherOrder     on
SSLOptions +StrictRequire
# Add vhost name to log entries:
LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-agent}i\"" vhost_combined
LogFormat "%v %h %l %u %t \"%r\" %>s %b" vhost_common
</VirtualHost>
EOF
