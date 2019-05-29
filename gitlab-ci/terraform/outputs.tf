output "Gitlab-CI Only IP" {
  value       = "${google_compute_instance.gitlab-ci.network_interface.0.access_config.0.nat_ip}"
}
output "Gitlab-CI HTTP link" {
  value       = "http://${google_compute_instance.gitlab-ci.network_interface.0.access_config.0.nat_ip}"
}
output "Gitlab-CI SSH link" {
  value       = "ssh -o \"StrictHostKeyChecking=no\" -i ~/.ssh/appuser appuser@${google_compute_instance.gitlab-ci.network_interface.0.access_config.0.nat_ip}"
}
output "Gitlab-main-runner Only IP" {
  value       = "${google_compute_instance.gitlab-main-runner.network_interface.0.access_config.0.nat_ip}"
}
output "Gitlab-main-runner HTTP link" {
  value       = "http://${google_compute_instance.gitlab-main-runner.network_interface.0.access_config.0.nat_ip}"
}
output "Gitlab-main-runner SSH link" {
  value       = "ssh -o \"StrictHostKeyChecking=no\" -i ~/.ssh/appuser appuser@${google_compute_instance.gitlab-main-runner.network_interface.0.access_config.0.nat_ip}"
}
