module "service_module" {
  source              = "./service"
  count               = local.count_service
  name                = local.service_name
  desired_count       = var.desired_count
  task_definition_arn = aws_ecs_task_definition.this.arn

  tags             = local.tags
  environment      = var.environment
  cluster          = var.cluster
  subnets          = var.subnets
  security_groups  = var.security_groups
  assign_public_ip = true
}
module "sqs_module" {
  source      = "./sqs"
  count       = local.count_sqs
  name        = local.full_queue_name
  tags        = local.tags
  environment = var.environment
  fifo_queue  = local.fifo_queue
}
module "cronjob_module" {
  source              = "./cronjob"
  count               = local.count_cronjob
  schedule_expression = var.schedule_expression
  name                = local.full_name
  container_name      = local.container_name
  command             = var.command
  task_definition_arn = aws_ecs_task_definition.this.arn
  task_count          = 1
  tags                = local.tags
  environment         = var.environment
  cluster             = var.cluster
  subnets             = var.subnets
  security_groups     = var.security_groups
  assign_public_ip    = true
}

module "autoscaling" {
  source                  = "./autoscaling"
  count                   = local.count_autoscaling
  enable_sqs_autoscaling  = var.enable_sqs_autoscaling
  enable_cpu_autoscaling  = var.enable_cpu_autoscaling
  name                    = local.full_name
  tags                    = local.tags
  environment             = var.environment
  desired_count           = var.desired_count
  service                 = module.service_module[count.index]
  queue_name              = local.full_queue_name
  cluster_name            = local.cluster_name
  scale_up_threshold      = var.scale_up_threshold
  scale_down_threshold    = var.scale_down_threshold
  scaling_adjustment_down = var.scaling_adjustment_down
  scaling_adjustment_up   = var.scaling_adjustment_up
  max_capacity            = var.max_capacity
  min_capacity            = var.min_capacity
}

resource "aws_ecs_task_definition" "this" {
  family = "${var.name}-task-definitions"
  cpu    = var.cpu
  memory = var.memory
  tags   = local.tags

  container_definitions = jsonencode([
    {
      name        = local.container_name
      image       = var.image
      cpu         = var.cpu
      memory      = var.memory
      essential   = true
      entryPoint  = var.entrypoint
      command     = var.command
      environment = local.task_environment
      secrets     = var.task_secrets

      logConfiguration = merge(var.logConfiguration, {
        options : local.logConfigurationOptions
      })
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
  task_role_arn            = var.task_role_arn
  execution_role_arn       = var.execution_role_arn
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
}

