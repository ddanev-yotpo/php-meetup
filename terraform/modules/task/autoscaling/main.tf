resource "aws_appautoscaling_target" "cpu" {
  count              = var.enable_cpu_autoscaling ? 1 : 0
  max_capacity       = local.max_capacity
  min_capacity       = local.min_capacity
  resource_id        = local.service_resource_id
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}
resource "aws_appautoscaling_policy" "cpu" {
  count              = var.enable_cpu_autoscaling ? 1 : 0
  name               = "cpu"
  policy_type        = "TargetTrackingScaling"
  resource_id        = join("", aws_appautoscaling_target.cpu.*.resource_id)
  scalable_dimension = join("", aws_appautoscaling_target.cpu.*.scalable_dimension)
  service_namespace  = join("", aws_appautoscaling_target.cpu.*.service_namespace)

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value       = 30
    scale_in_cooldown  = 60
    scale_out_cooldown = 60
  }
}
resource "aws_appautoscaling_target" "sqs" {
  count              = var.enable_sqs_autoscaling ? 1 : 0
  max_capacity       = local.max_capacity
  min_capacity       = local.min_capacity
  resource_id        = local.service_resource_id
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}
resource "aws_appautoscaling_policy" "up" {
  count              = var.enable_sqs_autoscaling ? 1 : 0
  name               = "scale-up"
  policy_type        = "StepScaling"
  resource_id        = join("", aws_appautoscaling_target.sqs.*.resource_id)
  scalable_dimension = join("", aws_appautoscaling_target.sqs.*.scalable_dimension)
  service_namespace  = join("", aws_appautoscaling_target.sqs.*.service_namespace)


  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_lower_bound = 1
      scaling_adjustment          = var.scaling_adjustment_up
    }
  }
}
resource "aws_cloudwatch_metric_alarm" "up" {
  count               = var.enable_sqs_autoscaling ? 1 : 0
  alarm_name          = "${local.name}-up"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "3"
  metric_name         = "ApproximateNumberOfMessagesVisible"
  namespace           = "AWS/SQS"
  period              = "10"
  statistic           = "Average"

  dimensions = {
    QueueName = local.queue_name
  }

  threshold     = var.scale_up_threshold
  alarm_actions = [join("", aws_appautoscaling_policy.up.*.arn)]
}

resource "aws_appautoscaling_policy" "down" {
  count              = var.enable_sqs_autoscaling ? 1 : 0
  name               = "scale-down"
  policy_type        = "StepScaling"
  resource_id        = join("", aws_appautoscaling_target.sqs.*.resource_id)
  scalable_dimension = join("", aws_appautoscaling_target.sqs.*.scalable_dimension)
  service_namespace  = join("", aws_appautoscaling_target.sqs.*.service_namespace)

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = var.scaling_adjustment_down
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "down" {
  count               = var.enable_sqs_autoscaling ? 1 : 0
  alarm_name          = "${local.name}-down"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "15"
  metric_name         = "ApproximateNumberOfMessagesVisible"
  namespace           = "AWS/SQS"
  period              = "10"
  statistic           = "Average"

  dimensions = {
    QueueName = local.queue_name
  }

  threshold     = var.scale_down_threshold
  alarm_actions = [join("", aws_appautoscaling_policy.down.*.arn)]
}
