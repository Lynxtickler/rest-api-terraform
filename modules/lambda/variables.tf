variable "name" {
  description = "Lambda name."
  type        = string
}

variable "source_path" {
  description = "Source code directory."
  type        = string
}

variable "filename" {
  description = "Name of the source code file."
  type        = string
}

variable "import_file" {
  description = "Name of generic source code file."
  type        = string
}

variable "bucket_id" {
  description = "ID of the bucket to upload code to."
  type        = string
}

variable "execution_role_arn" {
  description = "ARN of the role that Lambda assumes upon ivocation."
  type        = string
}

variable "api_execution_arns" {
  description = "ARNs of the API Gateways that should be able to invoke this lambda, if any."
  type        = list(string)
}
