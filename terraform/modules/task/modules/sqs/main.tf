resource "aws_sqs_queue" "this" {
  name = local.queue_name

  tags = merge(var.tags, {
    Name = local.queue_name
  })

  message_retention_seconds   = var.message_retention_seconds
  visibility_timeout_seconds  = var.visibility_timeout_seconds
  fifo_queue                  = var.fifo_queue
  content_based_deduplication = var.fifo_queue ? true : false
  deduplication_scope         = var.high_throughput_fifo ? "messageGroup" : null
  fifo_throughput_limit       = var.high_throughput_fifo ? "perMessageGroupId" : null
  delay_seconds               = var.delay_seconds
  sqs_managed_sse_enabled     = false
}