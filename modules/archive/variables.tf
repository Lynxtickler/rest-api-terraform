variable "source_dir" {
  description = "Source directory."
  type        = string
}

variable "main_file" {
  description = "Main source file name without extension."
  type        = string
}

variable "import_file" {
  description = "Import file name without extension."
}

variable "name" {
  description = "Output file name without extension."
  type        = string
}
