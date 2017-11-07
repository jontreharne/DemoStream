####### bootstrap #######
#!/bin/bash
yum update -y
yum install httpd -y
yum install php -y
yum install php-mysql -y
service httpd start
chkconfig httpd on
cat <<EOF >/var/www/html/index.html
<html>
<head>
  <title>HTML WEBPAGE</title>
</head>
<body>
<h1>Hello Ian and Jamie</h1>
<h2>This is Website 1</h2>
</body>
</html>
EOF
echo "healthy" > /var/www/html/healthy.html
