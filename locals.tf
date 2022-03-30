locals {
  user_data = <<EOF
#!/bin/bash

 curl -sL https://raw.githubusercontent.com/andreazorzetto/aqua-training-userscript/master/k8s-setup.sh | bash -

EOF
}