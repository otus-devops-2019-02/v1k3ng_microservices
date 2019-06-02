// output "app_external_ip" {
//   value = "${google_compute_instance.app0.network_interface.0.access_config.0.nat_ip}"
// }
// output "apps_external_ip" {
//   value = "${google_compute_instance.app.*.network_interface.0.access_config.0.nat_ip}"
// }
// output "target_pool_ip" {
//   value = "${google_compute_forwarding_rule.default.ip_address}"
// }

// output "apps_external_ip" {
//   value = "http://${google_compute_instance.docker-app.*.network_interface.0.access_config.0.nat_ip}:9292"
// }

// output "app_external_ip" {
//   value       = "http://${module.app.app_external_ip}:9292"
//   description = "The URI of the created resource."
// }

// output "app_internal_ip" {
//   value = "${module.app.app_internal_ip}"
// }


// output "db_internal_ip" {
//   value = "${module.db.db_internal_ip}"
// }


// output "self_link" {
//   value       = "${join("", google_storage_bucket.default.*.self_link)}"
//   description = "The URI of the created resource."
// }


// output "url" {
//   value       = "${join("", google_storage_bucket.default.*.url)}"
//   description = "The base URL of the bucket, in the format gs://<bucket-name>."
// }


// output "name" {
//   value       = "${join("", google_storage_bucket.default.*.name)}"
//   description = "The name of bucket."
// }
