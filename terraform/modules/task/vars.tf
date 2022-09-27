variable "name" {
  type = string
}
variable "name_prefix" {
  default = ""
}

variable "cpu" {}
variable "desired_count" {
  type = number
}
variable "memory" {}
variable "environment" {
  type = string
}

variable "tags" {}

variable "logConfiguration" {}
variable "task_role_arn" {
  default = ""
}
variable "execution_role_arn" {
  default = ""
}

variable "image" {}

variable "entrypoint" {
  type = list(string)
}

variable "command" {
  type = list(string)
}

variable "cluster" {}

variable "subnets" {
  type = list(any)
}

variable "security_groups" {
  default = []
}

variable "task_environment" {
  type = list(any)
}

variable "task_secrets" {
  type    = list(any)
  default = []
}
variable "with_sqs" {
  default = false
}

variable "with_service" {
  default = false
}

variable "with_cronjob" {
  default = false
}

variable "schedule_expression" {
  type    = string
  default = ""
}
variable "fifo_queue" {
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

variable "sqs_queue_name" {
  type    = string
  default = ""
}

variable "autoscaling_queue_name" {
  type    = string
  default = ""
}

variable "enable_sqs_autoscaling" {
  default = false
}

variable "enable_cpu_autoscaling" {
  default = false
}
