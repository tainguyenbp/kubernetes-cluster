output "cluster_id" {
  value       = module.aks.aks_id
  description = "Cluster ID"
}

output "cluster_name" {
  value       = module.aks.aks_name
  description = "Cluster Name"
}

output "cluster_fqdn" {
  value       = module.aks.cluster_fqdn
  description = "Cluster FQDN"
}
