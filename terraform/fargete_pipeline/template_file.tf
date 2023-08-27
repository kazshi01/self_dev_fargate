data "template_file" "appspec" {
  template = file("../../specfile/appspec.yml.tmpl")

  vars = {
    task_definition_arn = aws_ecs_task_definition.my_task.arn
    container_name      = local.container_name
    container_port      = local.container_port
  }
}

resource "aws_s3_bucket_object" "appspec" {
  bucket  = var.bucket_name
  key     = "appspec.yml"
  content = data.template_file.appspec.rendered
}
