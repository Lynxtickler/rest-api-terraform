variable "source_path" {
  description = "Relative path to function sources."
  type = string
  default = "functions"
}

variable "lambdas" {
  description = "Various properties for lambda functions."
  type = list(map(string))
  default = [
    {
      name = "root"
      filename = "root"
    }
  ]
}