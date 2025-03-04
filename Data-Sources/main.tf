data "aws_instance" "foo" {
  instance_id = "i-0e44bade906a03d07"

    filter {
    name   = "tag:Name"
    values = ["BastionHost-Demo"]
  }
}