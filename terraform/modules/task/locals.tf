locals {
  name = var.name_prefix != "" ? "${var.name_prefix}-${var.name}" : var.name
  # full_name = "${var.environment}-${local.name}"
  full_name = local.name
  base_tags = {
    Name   = local.name
    Family = local.full_name
  }
  default_tags = {
    Name        = local.name
    Family      = local.full_name
    Environment = var.environment
    Terraform   = "true"
  }

  tags = length(var.tags) > 0 ? merge(local.base_tags, var.tags) : local.default_tags

  count_sqs         = var.with_sqs ? 1 : 0
  count_cronjob     = var.schedule_expression != "" ? 1 : 0
  count_service     = var.with_service ? 1 : 0
  count_autoscaling = var.with_service && (var.enable_sqs_autoscaling || var.enable_cpu_autoscaling) ? 1 : 0

  container_name = "main"
  cluster_name   = split("/", var.cluster.id)[1]
  task_type = concat(
    local.count_autoscaling > 0 ? ["autoscaling"] : [],
    local.count_sqs > 0 ? ["sqs"] : [],
    local.count_cronjob > 0 ? ["cronjob"] : [],
    local.count_service > 0 ? ["service"] : []
  )

  service_name = "${local.full_name}-${join("-", local.task_type)}"

  prefix = length(local.task_type) == 0 ? "/" : "/${join("-", local.task_type)}"
  logConfigurationOptions = merge(var.logConfiguration.options, {
    awslogs-stream-prefix : "/${local.service_name}"
  })
  queue_name = coalesce(var.autoscaling_queue_name, var.sqs_queue_name)

  fifo_queue      = var.fifo_queue
  queue_suffix    = local.fifo_queue ? "queue.fifo" : "queue"
  full_queue_name = local.queue_name != "" ? "${var.environment}-${local.queue_name}-${local.queue_suffix}" : ""


  task_environment = local.full_queue_name != "" ? concat(var.task_environment, [
    {
      "name" : "SQS_URL"
      "value" : data.aws_sqs_queue.this.url
    }
  ]) : var.task_environment
}