
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

data "template_file" "user_data" {
  template = file("./bootstrap.yaml")
}
// building dev, UAT and Prod vms.

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"
// build the requisite number of servers for the partner instances required.
  // instance size can be modified per spec.

  for_each = toset(["one", "two", "three"])

  name = "dev-instance-${each.key}"

#  ami                    = "ami-f976839e"  // amazon linux image arch64
  // running k3s on a t2.micro causes the cpu load to increase to 5.0 -so a larger instance size for cpu is required.
  ami                    = "ami-0b5e334d61108a1aa"  // amazon linux image arch64
  // ami-09c6eba41572dea7f
  instance_type          = "t2.medium"
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
