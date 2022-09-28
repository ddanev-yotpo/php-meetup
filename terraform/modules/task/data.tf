data "aws_sqs_queue" "this" {
  name = local.full_queue_name
  depends_on = [module.sqs_module.SQS_QUEUE_NAME]
}