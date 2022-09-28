resource "aws_cloudwatch_event_rule" "this" {
  name                = local.name
  schedule_expression = var.schedule_expression
  tags                = local.tags
}

resource "aws_cloudwatch_event_target" "this" {
  target_id = "${local.name}_target_id"
  arn       = var.cluster.arn
  rule      = aws_cloudwatch_event_rule.this.name
  role_arn  = aws_iam_role.ecs_events_role.arn

  ecs_target {
    launch_type         = "FARGATE"
    task_count          = var.task_count
    task_definition_arn = var.task_definition_arn

    network_configuration {
      subnets          = var.subnets
      security_groups  = var.security_groups
      assign_public_ip = var.assign_public_ip
    }
  }


  input = <<DOC
{
  "containerOverrides": [
    {
      "name": "${var.container_name}",
      "command": ["${join(" ", var.command)}"]
    }
  ]
}
DOC
}