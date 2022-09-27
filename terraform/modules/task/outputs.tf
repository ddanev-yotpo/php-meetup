output "service_name" {
  value = join("", module.service_module[*].name)
}
