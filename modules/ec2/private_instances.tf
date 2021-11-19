# # Create an instance on each private subnet
# resource "aws_instance" "private_instances" {
#   count                  = length(var.private_subnets)
#   ami                    = var.ami
#   key_name               = var.key_pair_name
#   instance_type          = var.instance_type
#   vpc_security_group_ids = ["${aws_security_group.private_instances.id}"]
#   subnet_id              = element(var.private_subnets, count.index)

#   tags = {
#     Name = "${var.resource_prefix}private-instance-private-subnet-${count.index}"
#   }
# }

# Create a front-end instance on each private subnet
resource "aws_instance" "frontend_instances" {
  count                  = length(var.private_subnets)
  ami                    = var.ami
  key_name               = var.key_pair_name
  instance_type          = var.instance_type
  vpc_security_group_ids = ["${aws_security_group.private_instances.id}"]
  subnet_id              = element(var.private_subnets, count.index)

  tags = {
    Name = "${var.resource_prefix}front-end-private-subnet-${count.index}"
  }

  	user_data = <<-EOF
    #!/bin/bash
    # Front-end commands that can be used as script on startup
	#Update
	sudo yum update -y
	#Install nginx
	sudo amazon-linux-extras install -y nginx1
	#Install php 7.4
	sudo amazon-linux-extras install -y php7.4
	#Start nginx
	sudo systemctl start nginx 
	# Enable nginx on reboot
	sudo systemctl enable nginx
	#Start php fpm
	sudo systemctl start php-fpm
	# Enable php-fpm on reboot
	sudo systemctl enable php-fpm
	#Create the sites-available and sites enabled
	sudo mkdir /etc/nginx/sites-available
	sudo mkdir /etc/nginx/sites-enabled
	# Edit the nginx conf
	sudo sed -i '36 a\    include /etc/nginx/sites-enabled/*;' /etc/nginx/nginx.conf
	#Create the default website
	sudo tee /etc/nginx/sites-available/default > /dev/null <<'EOT'
	server {
		listen 80;
		listen [::]:80;
		root /var/www/html;
		index  index.php index.html index.htm;
		
		location / {
			try_files $uri $uri/ =404;       
		}

		# pass PHP scripts to FastCGI server
		location ~ \.php$ {
			include fastcgi_params;
			fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
			fastcgi_split_path_info ^(.+\.php)(/.+)$;
			fastcgi_index index.php;
			# fastcgi_intercept_errors on;
			# fastcgi_keep_conn on;
			# fastcgi_read_timeout 300;
			#
			# With php-fpm (or other unix sockets):
			fastcgi_pass  unix:/var/run/php-fpm/www.sock;
			# With php-cgi (or other tcp sockets):
			# fastcgi_pass 127.0.0.1:9000;
		}
	}
	EOT

	#Create the root sources
	sudo mkdir -p /var/www/html
	#Create the php index
	sudo tee /var/www/html/index.php > /dev/null <<'EOT'
	<?php
	echo '<h1>Frontend</h1>';
	echo gethostname();

	echo '<h1>Backend</h1>';
	// ip of reverse proxy
	echo file_get_contents('http://${aws_instance.reverseproxy_instances.0.private_ip}');
	EOT

	# Symlink to enable default website
	sudo ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

	#Restart services
	sudo systemctl restart nginx 
	sudo systemctl restart php-fpm
  EOF
}

# Create a reverse proxy instance on each private subnet
resource "aws_instance" "reverseproxy_instances" {
  count                  = length(var.private_subnets)
  ami                    = var.ami
  key_name               = var.key_pair_name
  instance_type          = var.instance_type
  vpc_security_group_ids = ["${aws_security_group.private_instances.id}"]
  subnet_id              = element(var.private_subnets, count.index)

  tags = {
    Name = "${var.resource_prefix}reverse-proxy-private-subnet-${count.index}"
  }

	user_data = <<-EOF
    #!/bin/bash
    # Reverse-proxy commands that can be used as script on startup
	#Update
	sudo yum update -y
	#Install nginx
	sudo amazon-linux-extras install -y nginx1
	#Start nginx
	sudo systemctl start nginx 
	# Enable nginx on reboot
	sudo systemctl enable nginx
	#Create the sites-available and sites enabled
	sudo mkdir /etc/nginx/sites-available
	sudo mkdir /etc/nginx/sites-enabled
	# Edit the nginx conf
	sudo sed -i '36 a\    include /etc/nginx/sites-enabled/*;' /etc/nginx/nginx.conf
	#Create the default website
	sudo tee /etc/nginx/sites-available/default > /dev/null <<'EOT'
	upstream BACKEND {
	server ${aws_instance.backend_instances.0.private_ip}; 
	}

	server {
		listen 80;
		listen [::]:80;
		
		location / {
			proxy_pass http://BACKEND;       
		}
	}
	EOT

	# Symlink to enable default website
	sudo ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

	#Restart services
	sudo systemctl restart nginx 
  EOF
}

# Create a back-end instance on each private subnet
resource "aws_instance" "backend_instances" {
  count                  = length(var.private_subnets)
  ami                    = var.ami
  key_name               = var.key_pair_name
  instance_type          = var.instance_type
  vpc_security_group_ids = ["${aws_security_group.private_instances.id}"]
  subnet_id              = element(var.private_subnets, count.index)

  tags = {
    Name = "${var.resource_prefix}back-end-private-subnet-${count.index}"
  }

	user_data = <<-EOF
    #!/bin/bash
    # Back-end commands that can be used as script on startup

	#Update
	sudo yum update -y
	#Install nginx
	sudo amazon-linux-extras install -y nginx1
	#Install php 7.4
	sudo amazon-linux-extras install -y php7.4
	#Start nginx
	sudo systemctl start nginx 
	# Enable nginx on reboot
	sudo systemctl enable nginx
	#Start php fpm
	sudo systemctl start php-fpm
	# Enable php-fpm on reboot
	sudo systemctl enable php-fpm
	#Create the sites-available and sites enabled
	sudo mkdir /etc/nginx/sites-available
	sudo mkdir /etc/nginx/sites-enabled
	# Edit the nginx conf
	sudo sed -i '36 a\    include /etc/nginx/sites-enabled/*;' /etc/nginx/nginx.conf
	#Create the default website
	sudo tee /etc/nginx/sites-available/default > /dev/null <<'EOT'
	server {
		listen 80;
		listen [::]:80;
		root /var/www/html;
		index  index.php index.html index.htm;
		
		location / {
			try_files $uri $uri/ =404;       
		}

		# pass PHP scripts to FastCGI server
		location ~ \.php$ {
			include fastcgi_params;
			fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
			fastcgi_split_path_info ^(.+\.php)(/.+)$;
			fastcgi_index index.php;
			# fastcgi_intercept_errors on;
			# fastcgi_keep_conn on;
			# fastcgi_read_timeout 300;
			#
			# With php-fpm (or other unix sockets):
			fastcgi_pass  unix:/var/run/php-fpm/www.sock;
			# With php-cgi (or other tcp sockets):
			# fastcgi_pass 127.0.0.1:9000;
		}
	}
	EOT
	#Create the root sources
	sudo mkdir -p /var/www/html
	#Create the php index
	sudo tee /var/www/html/index.php > /dev/null <<'EOT'
	<?php

	// Include database configuration file
	require 'conf.php';


	$data = array();
	$data['hostname'] = gethostname();

	header('Content-Type: application/json');

	if (!$link = @mysqli_connect($mysql_host, $mysql_user, $mysql_pass, $mysql_db)) {
			$data['error'] = mysqli_connect_error();
			echo json_encode($data);
			exit();
	}

	// Check connection
	if (mysqli_connect_error()) {
			$data['error'] = mysqli_connect_error();
			echo json_encode($data);
			exit();
	}

	// Query users
	$query = 'SELECT * FROM ' . $mysql_db . '.users';
	if ( ($result = mysqli_query($link, $query)) === FALSE ) {
			$data['error'] = mysqli_error();
			echo json_encode($data);
			mysqli_free_result($result);
			exit();
	}

	// Gather data
	while ($row = mysqli_fetch_array($result)) {
			$data['data'][] = $row;
	}

	// Free result set
	mysqli_free_result($result);

	// Close connection
	mysqli_close($link);

	// Output
	echo json_encode($data);
	EOT

	#Create the php conf
	sudo tee /var/www/html/conf.php > /dev/null <<'EOT'
	<?php

	/*
	* Database configuration file
	*/
	// ip of the database
	$mysql_host = '${aws_instance.database_instances.0.private_ip}';
	$mysql_user = '${var.db_user}';
	$mysql_pass = '${var.db_pass}';
	$mysql_db = 'mydb';
	EOT

	# Symlink to enable default website
	sudo ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default
	#Restart services
	sudo systemctl restart nginx 
	sudo systemctl restart php-fpm

  EOF
}

# Create a database instance on each private subnet
resource "aws_instance" "database_instances" {
  count                  = length(var.private_subnets)
  ami                    = var.ami
  key_name               = var.key_pair_name
  instance_type          = var.instance_type
  vpc_security_group_ids = ["${aws_security_group.private_instances.id}"]
  subnet_id              = element(var.private_subnets, count.index)

  tags = {
    Name = "${var.resource_prefix}datanase-private-subnet-${count.index}"
  }

	user_data = <<-EOF
    #!/bin/bash
    # Sql commands that can be used as script on startup

    # Perform update
    sudo yum update -y 
    # Install mariadb-server
    sudo yum install -y mariadb-server
    # Start mariadb-server
    sudo systemctl start mariadb 
    # Enable mariadb-server on reboot
    sudo systemctl enable mariadb
    # sql init file
    sudo tee ~/dump.sql > /dev/null <<'EOT'
    CREATE DATABASE mydb;

    create TABLE mydb.users (
    id int(8) unsigned zerofill not null auto_increment primary key,
    name varchar(30) not null
    );
    INSERT INTO mydb.users (name) VALUES ('user1');
    INSERT INTO mydb.users (name) VALUES ('user2');
    INSERT INTO mydb.users (name) VALUES ('user3');
    INSERT INTO mydb.users (name) VALUES ('user4');
    INSERT INTO mydb.users (name) VALUES ('user5');
    INSERT INTO mydb.users (name) VALUES ('user6');
    INSERT INTO mydb.users (name) VALUES ('user7');

    CREATE USER '${var.db_user}' IDENTIFIED BY '${var.db_pass}';
    GRANT SELECT ON mydb.users TO '${var.db_user}';
    EOT
    # apply to database
    mysql -h localhost -u root < ~/dump.sql
  EOF

  #You should run secure install on this instance before making public
  #sudo mysql_secure_installation
   

}