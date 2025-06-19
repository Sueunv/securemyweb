variable "ami_id" {}
variable "instance_type" {}
variable "subnet_id" {}
variable "sg_id" {}
variable "user_data" {
  description = "User data script for web instance"
  type        = string
  default     = ""
}


