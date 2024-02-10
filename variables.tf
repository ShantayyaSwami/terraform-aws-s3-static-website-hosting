variable "region" {
  default = "ap-south-1"
}

variable "bucket-name" {
  default = "shantayyaswami.in"
}

variable "static-files" {
  type    = list(string)
  default = ["index.html", "error.html"]
}