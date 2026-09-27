variable "key_pair_name" {
  description = "AWS EC2 key pair name"
  type        = string
}

variable "mongodb_username" {
  description = "MongoDB Atlas username"
  type        = string
  sensitive   = true
}

variable "mongodb_password" {
  description = "MongoDB Atlas password"
  type        = string
  sensitive   = true
}

variable "mongodb_host" {
  description = "MongoDB Atlas cluster hostname"
  type        = string
}

variable "jwt_secret" {
  description = "JWT secret used by the user service"
  type        = string
  sensitive   = true
}