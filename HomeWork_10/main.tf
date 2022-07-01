terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
}

resource "aws_instance" "my_web_server" {
  ami           = "ami-0c9354388bb36c088"
  instance_type = "t2.micro"


  user_data = <<-EOF
                #!/bin/bash
                sudo apt-get update
                sudo curl -fsSL https://get.docker.com/ | sh
                sudo systemctl restart docker
                cd ~/wordpress
                sudo docker run -e MYSQL_ROOT_PASSWORD=password -e MYSQL_DATABASE=wordpress --name wordpressdb -v "$PWD/database":/var/lib/mysql -d mariadb:latest
                sudo docker pull wordpress
                sudo docker run -e WORDPRESS_DB_USER=root -e WORDPRESS_DB_PASSWORD=password --name wordpress --link wordpressdb:mysql -p 80:80 -v "$PWD/html":/var/www/html -d wordpress
                EOF

  tags = {
    Name = "my_web_server"
  }
}
