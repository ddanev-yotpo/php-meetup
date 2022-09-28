### This is demo application, used for the Yotpo SMSBump PHP Meetup  
![xxxx](https://dnuaqhs941n75.cloudfront.net/img/website/smsbump-yotpo-2.svg)
> #### Long-running background services using AWS with the help of Terraform
**You should not use it as is on production.**

---
![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)
![PHP](https://img.shields.io/badge/php-%23777BB4.svg?style=for-the-badge&logo=php&logoColor=white)
![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)

### Folder structure
### `app`  
Here we have the PHP cli application, minimal no frameworks/components used so far, suited for running commands as services.   
It`s example, so feel free to add any composer package needed to simplify your needs or update the Dockerfile for additional extensions.  
Consider adding composer install as part of the build process or maybe even add is part of the Dockerfile.

Example: 
```shell
$ bin/cli leader
$ bin/cli worker arg 1
```
Note:
> `bin/cli` expects to find `php` at `#!/usr/local/bin/php` you can update it or use the correct php binary for your system
```shell
$ /usr/your/special/php bin/cli leader
```
---
### `build_scripts` 
Useful to build and push your Dockerfile to the AWS ECR Registry. You need to update all placeholder values, just search for 
```__CHANGEME__```. In the example below `php-meetup` is the name of the image and ECR repository.
You can update it to support passing tag as additional argument or just map it with the `GITHUB_REF`
> ./build_scripts/build.sh php-meetup

Note:
You might have noticed something interesting `buildx build --platform=linux/amd64`. Useful when building locally for ECS on M1 Mac.
```shell
docker \
    buildx build --platform=linux/amd64 \
    -t ${AWS_ECR_ENDPOINT}/${IMAGE_NAME}:${TAG} \
    -f $DOCKERFILE . && \
    docker push ${AWS_ECR_ENDPOINT}/${IMAGE_NAME}:${TAG}
```

---
### `terraform`
Your root module which creates its own VPC and everything inside it, `task` module and its submodules `autoscaling`, `cronjob`, `service`, `sqs`.
Some security considerations: 
* Add `AWS SecretManager` and used it for the RDS authentication instead of the current env based approach.
* Use private subnets and allow egress internet traffic via NAT Gateway(paid) instead Internet gateway public access (free). 
[Read more about it here](https://aws.amazon.com/premiumsupport/knowledge-center/ecs-pull-container-api-error-ecr/)
* Prefer `local` instead `var`, read more about it [here](https://learn.hashicorp.com/tutorials/terraform/locals)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.31 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.31.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_task_module"></a> [task\_module](#module\_task\_module) | ./modules/task | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_db_instance.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance) | resource |
| [aws_db_subnet_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_ecs_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_ecs_cluster_capacity_providers.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster_capacity_providers) | resource |
| [aws_iam_role.execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.task_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_internet_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_route_table.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.this_a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.this_b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_security_group.allow_rds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.allow_tls](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.this_a](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.this_b](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_ecr_image.php_meetup_image](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ecr_image) | data source |
| [aws_ecr_repository.php_meetup_repository](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ecr_repository) | data source |
| [aws_iam_policy.amazon_ecs_task_execution_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy.amazon_elastic_container_registry_public_read_only_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy.amazon_sqs_full_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy.cloud_watch_logs_full_access_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy.secret_manager_read_write_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy_document.ecs_tasks_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_db_instance_class"></a> [db\_instance\_class](#output\_db\_instance\_class) | The RDS instance class |
| <a name="output_db_instance_db_name"></a> [db\_instance\_db\_name](#output\_db\_instance\_db\_name) | The database username |
| <a name="output_db_instance_endpoint"></a> [db\_instance\_endpoint](#output\_db\_instance\_endpoint) | The database endpoint |
| <a name="output_db_instance_username"></a> [db\_instance\_username](#output\_db\_instance\_username) | The database username |
<!-- END_TF_DOCS -->