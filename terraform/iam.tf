resource "aws_iam_role" "task_role" {
  name               = "${local.name}_iam_task_role"
  assume_role_policy = data.aws_iam_policy_document.ecs_tasks_assume_role_policy.json # (not shown)
  managed_policy_arns = [
    data.aws_iam_policy.secret_manager_read_write_policy.arn,
    data.aws_iam_policy.cloud_watch_logs_full_access_policy.arn,
    data.aws_iam_policy.amazon_sqs_full_access.arn
  ]
}

resource "aws_iam_role" "execution_role" {
  name               = "${local.name}_iam_execution_role"
  assume_role_policy = data.aws_iam_policy_document.ecs_tasks_assume_role_policy.json # (not shown)
  managed_policy_arns = [
    data.aws_iam_policy.amazon_ecs_task_execution_role_policy.arn,
    data.aws_iam_policy.amazon_elastic_container_registry_public_read_only_policy.arn
  ]
}
