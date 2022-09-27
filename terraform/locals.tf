locals {
  region      = "us-east-1"
  app         = "meetup"
  name        = "phptasks"
  environment = "development"
  full_name   = "${local.environment}-${local.app}-${local.name}"

  db_instance_name = "${local.app}-instance"
  db_name          = "${local.app}db"
  db_user          = "__CHANGEME__"
  db_pass          = "__CHANGEME__"

  tags = {
    Name        = local.name
    Application = local.app
    Environment = local.environment
    Terraform   = "true"
  }

  logs_group = local.full_name

  tasks = {
    leader = {
      cpu    = 256
      memory = 512

      with_service   = true,
      with_sqs       = true
      sqs_queue_name = "leader"

      desired_count          = 1
      max_capacity           = 3
      enable_cpu_autoscaling = true
    },
    worker = {
      cpu    = 256
      memory = 512

      with_service   = true
      sqs_queue_name = "leader"

      enable_sqs_autoscaling     = true
      sqs_autoscaling_queue_name = "leader"
      desired_count              = 2
      scale_up_threshold         = 50
      max_capacity               = 100
      scaling_adjustment_up      = 10
    }
  }
}
