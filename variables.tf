variable "project" {
    type = "string"
}

variable "region" {
    default = "europe-west1"
}

variable "instance-zone" {
    default = "europe-west1-b"
}

variable "instance-type" {
    default = "f1-micro"
}

variable "instance-count" {
    default = 3
}