output "Only IP" {
  value       = "${google_compute_instance.gitlab-ci.network_interface.0.access_config.0.nat_ip}"
}
output "HTTP link" {
  value       = "http://${google_compute_instance.gitlab-ci.network_interface.0.access_config.0.nat_ip}"
}
output "SSH link" {
  value       = "ssh -o \"StrictHostKeyChecking=no\" -i ~/.ssh/appuser appuser@${google_compute_instance.gitlab-ci.network_interface.0.access_config.0.nat_ip}"
}
