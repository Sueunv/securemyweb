variable "ami_id" {}
variable "instance_type" {}
variable "subnet_id" {}
variable "sg_id" {}
variable "key_name" {
  type        = string
  description = "The name of the SSH key pair"
}

