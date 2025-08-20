variable "source_path" {
  description = "Relative path to function sources."
  type        = string
  default     = "functions"
}

variable "lambdas" {
  description = "Various properties for lambda functions."
  type        = list(map(string))
  default = [
    {
      name     = "default",
      filename = "default",
    },
    {
      name     = "root-get",
      filename = "root-get"
    },
    {
      name     = "root-post",
      filename = "root-post"
    },
    {
      name     = "quote-get",
      filename = "quote-get"
    },
    {
      name     = "quote-put",
      filename = "quote-put"
    },
    {
      name     = "quote-delete",
      filename = "quote-delete"
    }
  ]
}

variable "import_file" {
  description = "Import file with generic code."
  type        = string
  default     = "shared"
}

variable "deploy_api" {
  description = "Whether to create REST API deployment or not"
  type        = bool
  default     = true
}

variable "api_key_ssm_parameter" {
  description = "API key SSM parameter name."
  type        = string
  default     = "/quotes-api/api-key"
}
