resource "aws_secretsmanager_secret" "docker_secret" {
  name = "docker_credentials"
}

resource "aws_secretsmanager_secret_version" "docker_secret_value" {
  secret_id     = aws_secretsmanager_secret.docker_secret.id
  secret_string = jsonencode({
    username = var.dockerhub_username
    password = var.dockerhub_password
  })
}