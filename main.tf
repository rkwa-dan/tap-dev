
resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "kp" {
  key_name   = "myKey"       # Create "myKey" to AWS!!
  public_key = tls_private_key.pk.public_key_openssh

provisioner "local-exec" { # Create "myKey.pem" to your computer!!
    command = "echo '${tls_private_key.pk.private_key_pem}' > ./myKey.pem"
  }
}

data "template_file" "user_data" {
  template = file("./bootstrap.yaml")
}
// building dev  vm

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"
// build the requisite number of servers for the partner instances required.
// instance size can be modified per spec.

  for_each = toset(["one"])
  # for more instances you can create additional instances separated by commast
#  , "two", "three"])
  name = "dev-instance-${each.key}"

  ami                    = "ami-0b5e334d61108a1aa"  // amazon linux image arch64
  instance_type          = "t3a.xlarge"
  key_name               = aws_key_pair.kp.key_name
  monitoring             = true
  vpc_security_group_ids = ["${aws_security_group.allow_ssh_anywhere.id}"]
  subnet_id = aws_subnet.dev.id
  // this causes the user data to get converted into  base64 code to be deposited into the ec2 isntance and can then be executed.
  user_data = data.template_file.user_data.rendered
  associate_public_ip_address = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
