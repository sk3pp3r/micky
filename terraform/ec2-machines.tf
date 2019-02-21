
resource "aws_instance" "database" {
  ami           = "${lookup(var.AmiLinux, var.region)}"
  instance_type = "t2.micro"
  associate_public_ip_address = "false"
  subnet_id = "${aws_subnet.PrivateAZA.id}"
  vpc_security_group_ids = ["${aws_security_group.Database.id}"]
  key_name = "${var.key_name}"
  tags {
        Name = "database"
        Service = "DevOps"
        Stack = "DevOps"
  }
  user_data = <<HEREDOC
  #!/bin/bash
  sleep 180
  yum update -y
  yum install -y mysql55-server
  service mysqld start
  /usr/bin/mysqladmin -u root password 'secret'
  mysql -u root -psecret -e "create user 'root'@'%' identified by 'secret';" mysql
  mysql -u root -psecret -e 'CREATE TABLE mytable (mycol varchar(255));' test
  mysql -u root -psecret -e "INSERT INTO mytable (mycol) values ('Haim_Cohen_is_the_best') ;" test
 HEREDOC
}

resource "aws_instance" "grafana" {
  ami           = "${lookup(var.AmiLinux, var.region)}"
  instance_type = "t2.micro"
  associate_public_ip_address = "true"
  subnet_id = "${aws_subnet.PublicAZA.id}"
  vpc_security_group_ids = ["${aws_security_group.Grafana.id}"]
  key_name = "${var.key_name}"
  tags {
        Name = "grafana"
        Service = "DevOps"
        Stack = "DevOps"
  }
user_data = <<HEREDOC
#!/bin/bash
sudo yum update -y
sudo yum install docker -y
sudo service docker start
sudo usermod -a -G docker ec2-user
sudo docker pull grafana/grafana
sudo docker run -d --name=grafana -p 3000:3000 grafana/grafana
HEREDOC
}

resource "aws_instance" "elk" {
  ami           = "ami-0f65671a86f061fcd"
  instance_type = "t3.medium"
  associate_public_ip_address = "true"
  subnet_id = "${aws_subnet.PublicAZA.id}"
  vpc_security_group_ids = ["${aws_security_group.Grafana.id}"]
  key_name = "${var.key_name}"
  tags {
        Name = "elk"
        Service = "DevOps"
        Stack = "DevOps"
  }
  user_data = <<HEREDOC
#!/usr/bin/env bash
sudo apt-get update
sudo apt-get install openjdk-8-jre-headless -y
sudo wget --directory-prefix=/opt/ https://artifacts.elastic.co/downloads/logstash/logstash-6.0.0-rc2.deb
sudo dpkg -i /opt/logstash-6.0.0-rc2.deb
sudo wget --directory-prefix=/opt/ https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.0.0-rc2.deb
sudo dpkg -i /opt/elasticsearch-6.0.0-rc2.deb
sudo apt-get install apt-transport-https -y
sudo wget --directory-prefix=/opt/ https://artifacts.elastic.co/downloads/kibana/kibana-6.0.0-rc2-amd64.deb
sudo dpkg -i /opt/kibana-6.0.0-rc2-amd64.deb
sudo systemctl restart logstashsudo systemctl enable logstash
sudo systemctl restart elasticsearch
sudo systemctl enable elasticsearch
sudo systemctl restart kibana
sudo systemctl enable kibana
HEREDOC
}
