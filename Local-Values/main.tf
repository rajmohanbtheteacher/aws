resource "aws_security_group" "sg-test-app" {
  name = "Demo-app-Firewall"
  tags = local.default
  vpc_id = var.vpc_id
}
resource "aws_security_group" "sg-test-db" {
  name = "Demo-db-Firewall"
  tags = local.default
  vpc_id = var.vpc_id
}