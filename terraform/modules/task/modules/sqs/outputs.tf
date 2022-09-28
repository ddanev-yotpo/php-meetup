output "SQS_ID" {
  value = aws_sqs_queue.this.id
}

output "SQS_QUEUE_NAME" {
  value = aws_sqs_queue.this.name
}