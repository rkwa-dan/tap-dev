resource "aws_volume_attachment" "this" {
    device_name = "/dev/sdd"
    volume_id = aws_ebs_volume.this.id
    instance_id = module.ec2_instance.id
}

resource "aws_ebs_volume" "this" {
  availability_zone = local.availability_zone
    encrypted = false
    size              = 100
    type = "gp2"


    tags = {
    Name = "ryans-cmc-vol"
    }
}

