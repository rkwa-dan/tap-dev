
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
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDM2Co+7OgMbukt1MCFYiPTwVcrQ2TYrYa4PQtAxAC2lalQsoyiDhuCut3BWqyUPZrPIbsBluhIe7WAEOvdN/Hg4gI9kgcXAkTACkfH/oiJeBQW4Mq4qs1DxDiyyyD/dt1nFw8btkuv+HtFjYIoCslApeeswjQCOT9nM1f9icGiwXhLjXf/bu6MDCrcc7iPTHRiJAwiXRWWPi1XBdBjcB+v4RLHMnc8UydFaSmT0PQ32XBtcX2ouEgJI9Eyig5fKgPd5REZQmv5PG0tWOBKtSzlOdKcKKtzCKDIi4d/HvZJmeiMkL9xddeHwIi+F8NCiudHgUsGih6IpO2XCq9HqQIxbbEX3LVuAevu7LhxqmA1cVyX6yE5B5sp3+Q92Hi/3/637Q81Yu3+DH4uD/pqv8eTTx8YiV52SrhXqdCtUvZbeBZT+SNkWDJm+Yp68Ch7PA0T7qS690THEywt7ZxKjAhorr9MrlYQY60p3y+UbbeoQPFTnnxhiuh4attTLMiHy40= daniel@Daniels-MBP-2.lan"
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

#  ami                    = "ami-f976839e"  // amazon linux image arch64
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

