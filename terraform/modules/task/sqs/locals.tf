locals {
  name       = var.name
  queue_name = local.name
  default_tags = {
    Environment = var.environment
    Terraform   = "true"
  }

  tags = length(var.tags) > 0 ? merge(local.default_tags, var.tags) : local.default_tags
}