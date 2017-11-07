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
