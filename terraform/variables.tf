variable "region" {
  default = "us-east-2"
}
variable "AmiLinux" {
  type = "map"
  default = {
    us-east-1 = "ami-b73b63a0" # Virginia
    us-west-2 = "ami-5ec1673e" # Oregon
    eu-west-1 = "ami-9398d3e0" # Ireland
    us-east-2 = "ami-ea87a78f" # Ohio
  }
  description = "I add only 3 regions (Virginia, Oregon, Ireland) to show the map feature but you can add all the regions that you need"
}

variable "credentialsfile" {
  default = "/home/jenkins/.aws/credentials" #replace your home directory
  description = "Where your access and secret_key are stored, you create the file when you run the aws config"
}

variable "vpc-fullcidr" {
    default = "172.28.0.0/16"
  description = "The vpc cdir"
}
variable "Subnet-Public-AzA-CIDR" {
  default = "172.28.0.0/24"
  description = "The Public CIDR of the subnet"
}
variable "Subnet-Private-AzA-CIDR" {
  default = "172.28.3.0/24"
  description = "The Private CIDR of the subnet"
}
variable "key_name" {
  default = "grafana01"
  description = "The ssh key to use in the EC2 machines"
}
variable "DnsZoneName" {
  default = "haimcohen.internal"
  description = "The internal DNS name"
}
