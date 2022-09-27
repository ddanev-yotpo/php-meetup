data "aws_sqs_queue" "this" {
  name = local.full_queue_name
}