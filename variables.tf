variable "project_id" {
  type = string
}

variable "project_region" {
  type    = string
  default = "europe-west1"
}

variable "instance_zones" {
  type    = list(string)
  default = ["europe-west1-b", "europe-west1-c", "europe-west1-d"]
}

variable "server_instance_type" {
  type    = string
  default = "e2-medium"
}

variable "server_instance_count" {
  type    = number
  default = 3
}

variable "server_instance_image" {
  type    = string
  default = "nomad-104"
}

variable "server_instance_tag" {
  type    = string
  default = "nomad-server"
}

variable "client_instance_type" {
  type    = string
  default = "e2-medium"
}

variable "client_instance_count" {
  type    = number
  default = 3
}

variable "client_instance_image" {
  type    = string
  default = "nomad-104"
}

variable "client_instance_tag" {
  type    = string
  default = "nomad-client"
}

variable "whitelist" {
    type = list(string)
    default = []
}