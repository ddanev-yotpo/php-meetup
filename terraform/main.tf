terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.31"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = local.region
  profile = "dev"
}

resource "aws_vpc" "this" {
  cidr_block           = "10.5.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "PHP-Meetup VPC"
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "PHP-Meetup IGW"
  }
}

resource "aws_route_table" "this" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name = "PHP-Meetup RT"
  }
}

resource "aws_ecs_cluster" "this" {
  name = local.full_name
}

resource "aws_ecs_cluster_capacity_providers" "this" {
  cluster_name = aws_ecs_cluster.this.name

  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

resource "aws_security_group" "allow_rds" {
  name        = "allow_rds"
  description = "Allow RDS ingress traffic"
  vpc_id      = aws_vpc.this.id

  ingress {
    description = "TLS from VPC"
    from_port   = 3305
    to_port     = 3306
    protocol    = "tcp"
    # cidr_blocks = [aws_vpc.this.cidr_block]
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_rds"
  }
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_tls"
  description = "Allow TLS egress traffic"
  vpc_id      = aws_vpc.this.id

  # ingress {
  #   description      = "TLS from VPC"
  #   from_port        = 443
  #   to_port          = 443
  #   protocol         = "tcp"
  #   cidr_blocks      = [aws_vpc.this.cidr_block]
  #   ipv6_cidr_blocks = [aws_vpc.this.ipv6_cidr_block]
  # }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_subnet" "this_a" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.5.0.0/24"
  availability_zone = "${local.region}a"

  tags = {
    Subnet = "public"
  }
}

resource "aws_subnet" "this_b" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.5.1.0/24"
  availability_zone = "${local.region}b"

  tags = {
    Subnet = "public"
  }
}

resource "aws_route_table_association" "this_a" {
  subnet_id      = aws_subnet.this_a.id
  route_table_id = aws_route_table.this.id
}

resource "aws_route_table_association" "this_b" {
  subnet_id      = aws_subnet.this_b.id
  route_table_id = aws_route_table.this.id
}

resource "aws_cloudwatch_log_group" "this" {
  name              = local.logs_group
  retention_in_days = 3

  tags = local.tags
}

module "task_module" {
  for_each = local.tasks

  name = each.key
  # name_prefix   = local.app
  command       = lookup(each.value, "command", [replace(each.key, "-", "_")])
  desired_count = lookup(each.value, "desired_count", 1)
  cpu           = lookup(each.value, "cpu", 256)
  memory        = lookup(each.value, "memory", 512)

  schedule_expression    = lookup(each.value, "schedule_expression", "")
  with_sqs               = lookup(each.value, "with_sqs", false)
  enable_sqs_autoscaling = lookup(each.value, "enable_sqs_autoscaling", false)
  enable_cpu_autoscaling = lookup(each.value, "enable_cpu_autoscaling", false)
  with_service           = lookup(each.value, "with_service", false)

  fifo_queue            = lookup(each.value, "fifo_queue", false)
  scale_up_threshold    = lookup(each.value, "scale_up_threshold", 1000)
  scale_down_threshold  = lookup(each.value, "scale_down_threshold", 0)
  max_capacity          = lookup(each.value, "max_capacity", 6)
  min_capacity          = lookup(each.value, "min_capacity", 1)
  scaling_adjustment_up = lookup(each.value, "scaling_adjustment_up", 1)
  sqs_queue_name        = lookup(each.value, "sqs_queue_name", "")


  autoscaling_queue_name = lookup(each.value, "autoscaling_queue_name", "")

  task_role_arn      = aws_iam_role.task_role.arn
  execution_role_arn = aws_iam_role.execution_role.arn


  environment     = local.environment
  source          = "./modules/task"
  cluster         = aws_ecs_cluster.this
  image           = "${data.aws_ecr_repository.php_meetup_repository.repository_url}@${data.aws_ecr_image.php_meetup_image.image_digest}"
  security_groups = [aws_security_group.allow_tls.id]
  subnets         = [aws_subnet.this_a.id, aws_subnet.this_b.id]
  entrypoint      = ["/app/bin/cli"]
  task_environment = distinct(concat([{
    "name" : "DB_PDO_DSN",
    "value" : "mysql:host=${aws_db_instance.this.endpoint};dbname=${aws_db_instance.this.db_name};user=${local.db_user};password=${local.db_pass}"
    }, {
    "name" : "DB_ADDRESS",
    "value" : "${aws_db_instance.this.address}"
  }], lookup(each.value, "task_enviroment", [])))

  logConfiguration = {
    logDriver = "awslogs"
    options = {
      awslogs-region = local.region
      awslogs-group  = local.logs_group
    }
  }

  tags = {
    Terraform   = "true"
    Environment = local.environment
  }
}