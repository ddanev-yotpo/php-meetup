variable "name" {
  type = string
}

variable "cluster" {}

variable "task_definition_arn" {
  type = string
}

variable "desired_count" {
  type = number
}

variable "subnets" {
  type = list(any)
}

variable "security_groups" {
  default = []
}

variable "environment" {
  type = string
}

variable "tags" {}

variable "assign_public_ip" {
  default = true
}

variable "health_check_grace_period_seconds" {
  description = "Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown, up to 1800. Only valid for services configured to use load balancers."
  default     = 0
}