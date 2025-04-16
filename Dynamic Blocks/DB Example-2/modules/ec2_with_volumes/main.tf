resource "aws_instance" "websrv" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.security_group_ids
  associate_public_ip_address = true

  tags = {
    Name = var.name
  }

  dynamic "ebs_block_device" {
    for_each = var.ebs_volumes
    iterator = disk
    content {
      device_name = disk.value.device_name
      volume_size = disk.value.volume_size
      volume_type = disk.value.volume_type
    }
  }
}