####### bootstrap #######

#!/bin/bash
yum update -y
yum install httpd -y
hostname=`aws ec2 describe-tags --region eu-west-2 --filters "Name=resource-id,Values=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)" "Name=key,Values=Name" --query "Tags[?Key=='Name'].{Value:Value}" --output text`
service httpd start
chkconfig httpd on
cat <<EOF >/var/www/html/index.html
<html>
<head>
  <title>Let's Encrypt Demo</title>
</head>
<body>
<h1>Hello Digital DevOps Brum!</h1>
<h2>This is ${hostname}</h2>
</body>
</html>
EOF
echo "healthy" > /var/www/html/healthy.html
