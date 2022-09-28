variable "name" {
  type = string
}

variable "environment" {
  type = string
}

variable "queue_name" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "service" {
}

variable "desired_count" {
  default = 1
}

variable "tags" {}

variable "enable_sqs_autoscaling" {
  default = false
}

variable "enable_cpu_autoscaling" {
  default = false
}

variable "max_capacity" {
  default = 6
}

variable "min_capacity" {
  default = 1
}

variable "scaling_adjustment_up" {
  default = 1
}

variable "scaling_adjustment_down" {
  default = -1
}

variable "scale_up_threshold" {
  default = 1000
}

variable "scale_down_threshold" {
  default = 0
}

variable "enable_autoscaling" {
  default = false
}