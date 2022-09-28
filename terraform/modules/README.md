<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_autoscaling"></a> [autoscaling](#module\_autoscaling) | ./modules/autoscaling | n/a |
| <a name="module_cronjob_module"></a> [cronjob\_module](#module\_cronjob\_module) | ./modules/cronjob | n/a |
| <a name="module_service_module"></a> [service\_module](#module\_service\_module) | ./modules/service | n/a |
| <a name="module_sqs_module"></a> [sqs\_module](#module\_sqs\_module) | ./modules/sqs | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_ecs_task_definition.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_sqs_queue.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/sqs_queue) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_autoscaling_queue_name"></a> [autoscaling\_queue\_name](#input\_autoscaling\_queue\_name) | n/a | `string` | `""` | no |
| <a name="input_cluster"></a> [cluster](#input\_cluster) | n/a | `any` | n/a | yes |
| <a name="input_command"></a> [command](#input\_command) | n/a | `list(string)` | n/a | yes |
| <a name="input_cpu"></a> [cpu](#input\_cpu) | n/a | `any` | n/a | yes |
| <a name="input_desired_count"></a> [desired\_count](#input\_desired\_count) | n/a | `number` | n/a | yes |
| <a name="input_enable_cpu_autoscaling"></a> [enable\_cpu\_autoscaling](#input\_enable\_cpu\_autoscaling) | n/a | `bool` | `false` | no |
| <a name="input_enable_sqs_autoscaling"></a> [enable\_sqs\_autoscaling](#input\_enable\_sqs\_autoscaling) | n/a | `bool` | `false` | no |
| <a name="input_entrypoint"></a> [entrypoint](#input\_entrypoint) | n/a | `list(string)` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `string` | n/a | yes |
| <a name="input_execution_role_arn"></a> [execution\_role\_arn](#input\_execution\_role\_arn) | n/a | `string` | `""` | no |
| <a name="input_fifo_queue"></a> [fifo\_queue](#input\_fifo\_queue) | n/a | `bool` | `false` | no |
| <a name="input_image"></a> [image](#input\_image) | n/a | `any` | n/a | yes |
| <a name="input_logConfiguration"></a> [logConfiguration](#input\_logConfiguration) | n/a | `any` | n/a | yes |
| <a name="input_max_capacity"></a> [max\_capacity](#input\_max\_capacity) | n/a | `number` | `6` | no |
| <a name="input_memory"></a> [memory](#input\_memory) | n/a | `any` | n/a | yes |
| <a name="input_min_capacity"></a> [min\_capacity](#input\_min\_capacity) | n/a | `number` | `1` | no |
| <a name="input_name"></a> [name](#input\_name) | n/a | `string` | n/a | yes |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | n/a | `string` | `""` | no |
| <a name="input_scale_down_threshold"></a> [scale\_down\_threshold](#input\_scale\_down\_threshold) | n/a | `number` | `0` | no |
| <a name="input_scale_up_threshold"></a> [scale\_up\_threshold](#input\_scale\_up\_threshold) | n/a | `number` | `1000` | no |
| <a name="input_scaling_adjustment_down"></a> [scaling\_adjustment\_down](#input\_scaling\_adjustment\_down) | n/a | `number` | `-1` | no |
| <a name="input_scaling_adjustment_up"></a> [scaling\_adjustment\_up](#input\_scaling\_adjustment\_up) | n/a | `number` | `1` | no |
| <a name="input_schedule_expression"></a> [schedule\_expression](#input\_schedule\_expression) | n/a | `string` | `""` | no |
| <a name="input_security_groups"></a> [security\_groups](#input\_security\_groups) | n/a | `list` | `[]` | no |
| <a name="input_sqs_queue_name"></a> [sqs\_queue\_name](#input\_sqs\_queue\_name) | n/a | `string` | `""` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | n/a | `list(any)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `any` | n/a | yes |
| <a name="input_task_environment"></a> [task\_environment](#input\_task\_environment) | n/a | `list(any)` | n/a | yes |
| <a name="input_task_role_arn"></a> [task\_role\_arn](#input\_task\_role\_arn) | n/a | `string` | `""` | no |
| <a name="input_task_secrets"></a> [task\_secrets](#input\_task\_secrets) | n/a | `list(any)` | `[]` | no |
| <a name="input_with_cronjob"></a> [with\_cronjob](#input\_with\_cronjob) | n/a | `bool` | `false` | no |
| <a name="input_with_service"></a> [with\_service](#input\_with\_service) | n/a | `bool` | `false` | no |
| <a name="input_with_sqs"></a> [with\_sqs](#input\_with\_sqs) | n/a | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_service_name"></a> [service\_name](#output\_service\_name) | n/a |
<!-- END_TF_DOCS -->