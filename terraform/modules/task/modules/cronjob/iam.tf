resource "aws_iam_role" "ecs_events_role" {
  name               = "ecs_events_role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "events.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
  managed_policy_arns = [
    data.aws_iam_policy.amazon_ec2_container_service_events_role.arn
  ]
}