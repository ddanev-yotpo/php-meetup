locals {
  name = var.name

  base_tags = {
    Name        = local.name
    Environment = var.environment
    Terraform   = "true"
  }

  default_tags = {

  }

  tags = merge(local.base_tags, length(var.tags) > 0 ? var.tags : local.default_tags)
}