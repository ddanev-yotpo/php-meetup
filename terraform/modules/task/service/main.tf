resource "aws_ecs_service" "this" {
  name                               = local.name
  cluster                            = var.cluster.id
  task_definition                    = var.task_definition_arn
  desired_count                      = var.desired_count
  deployment_maximum_percent         = 100
  deployment_minimum_healthy_percent = 0
  tags                               = local.tags
  health_check_grace_period_seconds  = var.health_check_grace_period_seconds
  propagate_tags                     = "TASK_DEFINITION"

  network_configuration {
    subnets          = var.subnets
    security_groups  = var.security_groups
    assign_public_ip = var.assign_public_ip
  }
  # depends_on      = [aws_iam_role_policy.this]
}
