variable "subnet_ids" {}
variable "sg_id" {}
variable "ami_id" {}
variable "user_data_path" {}
variable "key_name" {
  description = "The name of the SSH key pair"
  type        = string
}
variable "private_key_path" {
  description = "Path to the private key for SSH"
  type        = string
}

variable "backend_url" {
  description = "URL of the backend internal ALB"
  type        = string
}
