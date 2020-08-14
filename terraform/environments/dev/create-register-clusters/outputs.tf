output workers_asg_arns {
  value       = element(module.my-cluster.workers_asg_arns,0)
  sensitive   = false
  description = "description"
  depends_on  = []
}
