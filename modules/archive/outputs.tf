output "output_path" {
  value = data.archive_file.this.output_path
}

output "hash" {
  value = data.archive_file.this.output_base64sha256
}
