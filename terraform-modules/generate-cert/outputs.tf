output "ca_public_key" {
  value = tls_self_signed_cert.ca.cert_pem
}

output "client_cert" {
  value = tls_locally_signed_cert.cert.cert_pem
}

output "client_private_key" {
  value = tls_private_key.cert.private_key_pem
}
