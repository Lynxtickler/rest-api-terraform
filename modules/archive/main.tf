locals {
  source_files = ["${var.source_dir}/${var.main_file}.py", "${var.source_dir}/${var.import_file}.py"]
}

data "template_file" "this" {
  count = length(local.source_files)

  template = file(element(local.source_files, count.index))
}

data "archive_file" "this" {
  type        = "zip"
  output_path = "${var.source_dir}/${var.name}.zip"

  source {
    filename = basename(local.source_files[0])
    content  = data.template_file.this[0].rendered
  }

  source {
    filename = basename(local.source_files[1])
    content  = data.template_file.this[1].rendered
  }
}
