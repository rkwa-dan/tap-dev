# module "ec2-instance_example_volume-attachment" {
#   source  = "terraform-aws-modules/ec2-instance/aws//examples/volume-attachment"
#   version = "4.3.0"
# }
 
# resource "aws_volume_attachment" "this" {
#     device_name = "/dev/sdd"
#     volume_id = aws_ebs_volume.this.id
#     instance_id = aws.ec2_id
# }

# resource "aws_ebs_volume" "this" {
# availability_zone = "us-west-2"
# encrypted = false
# size              = 100
# type = "gp2"


#     tags = {
#     Name = "ryans-cmc-vol"
#     }
# }
