data "template_file" "appspec" {
  template = file("./specfile/appspec.yml.tmpl")

  vars = {
    task_definition_arn = local.service_task_definition_arn
    container_name      = local.container_name
    container_port      = local.container_port
  }
}

resource "aws_s3_object" "appspec" {
  bucket  = var.bucket_name
  key     = "fargate_pipeline/appspec.yml"
  content = data.template_file.appspec.rendered
}
