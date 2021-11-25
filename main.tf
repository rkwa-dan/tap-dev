
//resource "aws_instance" "app_server" {
//  ami           = "ami-830c94e3"
//  instance_type = "t2.micro"
//
//  tags = {
//    Name = "ExampleAppServerInstance"
//  }
//}
resource "tls_private_key" "aws-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name = "ssh-key"
  public_key = tls_private_key.aws-key.public_key_openssh
}

data "template_file" "user_data" {
  template = file("./bootstrap.yaml")
}
// building dev, UAT and Prod vms.

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"
// build the requisite number of servers for the partner instances required.
  // instance size can be modified per spec.

  for_each = toset(["one"])
#  , "two", "three"])
  name = "dev-instance-${each.key}"

#  ami                    = "ami-f976839e"  // amazon linux image arch64
  // running k3s on a t2.micro causes the cpu load to increase to 5.0 -so a larger instance size for cpu is required.
  ami                    = "ami-0b5e334d61108a1aa"  // amazon linux image arch64
  // ami-09c6eba41572dea7f
  instance_type          = "t3a.xlarge"
  key_name               = aws_key_pair.dan-ssh-key.key_name
  monitoring             = true
  vpc_security_group_ids = ["${aws_security_group.allow_ssh_anywhere.id}"]
  subnet_id = aws_subnet.dev.id
  // this causes the user data ccnverted into  base64 code to be deposited into the ec2 isntance and can then be executed.
  user_data = data.template_file.user_data.rendered
  associate_public_ip_address = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
