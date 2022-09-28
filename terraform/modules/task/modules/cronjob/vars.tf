variable "name" {
  type = string
}

variable "cluster" {}

variable "environment" {
  type = string
}

variable "command" {
  type = list(string)
}

variable "tags" {}

variable "subnets" {
  type = list(any)
}

variable "security_groups" {
  default = []
}

variable "task_definition_arn" {
  type = string
}

variable "task_count" {
  type = number
}

variable "assign_public_ip" {
  default = true
}

variable "schedule_expression" {
  type = string
}

variable "container_name" {
  type = string
}