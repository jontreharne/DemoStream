####### bootstrap #######
#!/bin/bash
yum update -y
yum install httpd -y
yum install php -y
yum install mysql -y
yum install php-mysql -y
service httpd start
chkconfig httpd on
cat <<EOF >/var/www/html/healthy.php
<?php
$servername = "carparkdetails.c3jxoithm3hc.eu-west-2.rds.amazonaws.com";
$username = "admin";
$password = "xxxxxxx";

// Create connection
$conn = new mysqli($servername, $username, $password);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
echo "Connected successfully";
?>
EOF
