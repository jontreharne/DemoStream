####### bootstrap #######
#!/bin/bash
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
<h2>This is Webserver 1</h2>
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

sed -i '/^Listen 443$/a <VirtualHost *:443>\nDocumentRoot /var/www/html\nServerName webserver2.jws-awsome-domain.co.uk\nSSLEngine on\nSSLCertificateFile /etc/letsencrypt/live/webserver2.jws-awsome-domain.co.uk/cert.pem\nSSLCertificateKeyFile /etc/letsencrypt/live/webserver2.jws-awsome-domain.co.uk/privkey.pem\nSSLCertificateChainFile /etc/letsencrypt/live/webserver2.jws-awsome-domain.co.uk/chain.pem\nSSLProtocol all -SSLv2 -SSLv3\nSSLCipherSuite ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:AES:CAMELLIA:DES-CBC3-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!MD5:!PSK:!aECDH:!EDH-DSS-DES-CBC3-SHA:!EDH-RSA-DES-CBC3-SHA:!KRB5-DES-CBC3-SHA\nSSLHonorCipherOrder     on\nSSLOptions +StrictRequire\n# Add vhost name to log entries:\nLogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-agent}i\"" vhost_combined\nLogFormat "%v %h %l %u %t \"%r\" %>s %b" vhost_common\n</VirtualHost>\n' /etc/httpd/conf.d/ssl.conf
