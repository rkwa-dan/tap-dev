
//resource "aws_instance" "app_server" {
//  ami           = "ami-830c94e3"
//  instance_type = "t2.micro"
//
//  tags = {
//    Name = "ExampleAppServerInstance"
//  }
//}

resource "aws_key_pair" "dan-ssh-key" {
  key_name   = "aws-ec2-ssh-pub-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC9ov6dikJpIFEwKgUoEW8X5NM17Ik/Ow/Jg/K1Qon0DoV1lLK32S27ievK9oS59AmHl/gxDs7KKpCPfZyw+XDVxBYcxLMJMFLJmZgLro2I1jKFKUlm2nHCiHrFiPiM6+FCst/zecSl8Rkb0yyJq4OUlTF8clSn/NLUVQCxa1bQziRLoM3zxoNTwDSiHvTxcbktkrAlZvU+l5EvDe2cpa11GzgjsFGJmlgpqy5En/eUjeCN4sUDLMyvy2zgCxzZV39dOguKCiNcDSYgiSwi08888p3ZAd5ZtwTn4nf6s2fJiaisI9NTSRXn3Yk3Atk5IytW8TDndsciS6TWs8AMVyZ/ daniel@Daniels-MBP-2.lan"
}

#//

// building dev, UAT and Prod vms.

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"
// build the requisite number of servers for the partner instances required.
  // instance size can be modified per spec.

  for_each = toset(["one", "two", "three"])

  name = "dev-instance-${each.key}"

  ami                    = "ami-0b5e334d61108a1aa"  // amazon linux image arch64
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.dan-ssh-key.key_name
  monitoring             = true
  vpc_security_group_ids = ["${aws_security_group.allow_ssh_anywhere.id}"]
  subnet_id = aws_subnet.dev.id

  associate_public_ip_address = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

