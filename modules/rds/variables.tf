variable "private_subnet_ids" {
  type = list(string)
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type = string
  sensitive = true
}

variable "app_sg_id" {
  type = string
}

