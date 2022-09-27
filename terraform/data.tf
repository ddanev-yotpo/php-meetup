
data "aws_ecr_repository" "php_meetup_repository" {
  name = "php-meetup"
}

data "aws_ecr_image" "php_meetup_image" {
  repository_name = "php-meetup"
  image_tag       = "latest"
}

data "aws_iam_policy" "secret_manager_read_write_policy" {
  arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

data "aws_iam_policy" "cloud_watch_logs_full_access_policy" {
  arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

data "aws_iam_policy" "amazon_ecs_task_execution_role_policy" {
  arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy" "amazon_elastic_container_registry_public_read_only_policy" {
  arn = "arn:aws:iam::aws:policy/AmazonElasticContainerRegistryPublicReadOnly"
}

data "aws_iam_policy" "amazon_sqs_full_access" {
  arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
}

data "aws_iam_policy_document" "ecs_tasks_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}