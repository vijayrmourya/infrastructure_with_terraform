#!/bin/bash

# Install dependencies
sudo apt update
sudo apt install -y apache2

# Get the instance ID and availability zone
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
AVAILABILITY_ZONE=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)

sudo mkdir -p /var/www/html/
# Create an index.html file with the instance information
sudo bash -c "cat <<EOF >/var/www/html/index.html
<html>
<head>
  <title>Welcome to $INSTANCE_ID</title>
</head>
<body>
  <h1>Welcome to $INSTANCE_ID</h1>
  <p>Instance Availability Zone: $AVAILABILITY_ZONE</p>
</body>
</html>
EOF"

# Restart the web server to reflect the changes
sudo service apache2 restart

echo "Static web page hosted successfully. You can access it using the public IP address of the EC2 instance."
