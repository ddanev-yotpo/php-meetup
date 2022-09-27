locals {
  name         = var.name
  queue_name   = var.queue_name
  cluster_name = var.cluster_name

  max_capacity = var.max_capacity == 0 ? var.desired_count : var.max_capacity
  min_capacity = var.min_capacity == 0 ? var.desired_count : var.min_capacity

  default_tags = {
    Environment = var.environment
    Terraform   = "true"
  }

  tags                = length(var.tags) > 0 ? merge(local.default_tags, var.tags) : local.default_tags
  service_name        = var.service.name
  service_id          = var.service.id
  service_resource_id = "service/${local.cluster_name}/${local.service_name}${replace(local.service_id, "/.*/", "")}"
}