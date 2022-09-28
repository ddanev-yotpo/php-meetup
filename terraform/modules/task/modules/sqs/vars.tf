variable "name" {
  type = string
}
variable "environment" {
  type = string
}

variable "tags" {}

variable "visibility_timeout_seconds" {
  default = 30
}

variable "fifo_queue" {
  default = false
}

variable "high_throughput_fifo" {
  default = false
}

variable "delay_seconds" {
  default = 0
}

variable "message_retention_seconds" {
  default = 345600
}