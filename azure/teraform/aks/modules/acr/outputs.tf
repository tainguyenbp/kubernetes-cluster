output "acr_resources" {
  description = "ACR resource"
  value       = module.acr.resource
  sensitive   = true
}
