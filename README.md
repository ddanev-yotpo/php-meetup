### This is demo application, used for the Yotpo SmsBump PHP Meetup  
> #### Long-running background services using AWS with the help of Terraform
**You should not use it as is on production.**

---

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
