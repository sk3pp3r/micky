resource "aws_security_group" "FrontEnd" {
  name = "FrontEnd"
  tags {
        Name = "FrontEnd"
  }
  description = "FrontEnd Connection Inboud"
  vpc_id = "${aws_vpc.terraformmain.id}"

  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
        from_port = "3000"
        to_port = "3000"
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = "9200"
    to_port     = "9200"
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "BackEnd" {
  name = "BackEnd"
  tags {
        Name = "BackEnd"
  }
  description = "BackEnd Connection Inbound"
  vpc_id = "${aws_vpc.terraformmain.id}"
  ingress {
      from_port = 3306
      to_port = 3306
      protocol = "TCP"
      security_groups = ["${aws_security_group.FrontEnd.id}"]
  }
  ingress {
      from_port   = "22"
      to_port     = "22"
      protocol    = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
