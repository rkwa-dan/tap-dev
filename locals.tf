locals {
  user_data = <<EOF
# #!/bin/bash
# use later if reqd.
EOF

  gse_ps_dev_sandbox_vpc_id = "vpc-05930d73c114c8abd"
  gse_ps_dev_sandbox_subnet_id = "subnet-0434ecc5686eeccff"
  region = "us-west-2"
  availability_zone = "${local.region}b"
}