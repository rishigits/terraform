#!/bin/bash
set -e -o pipefail
read -ra arr <<< "$@"
version=${arr[1]}
trap 0 1 2 ERR
# Ensure sudo is installed along with utilities to build rpm and deb packages
apt-get update && apt-get install sudo ruby ruby-dev rpm -y
bash /tmp/linux-on-ibm-z-scripts/Terraform/${version}/build_terraform.sh -y
zip -j terraform_${version}_linux_s390x.zip bin/terraform src/github.com/hashicorp/terraform/LICENSE
fpm -s zip -t rpm --prefix /usr/bin -n terraform -v 1.12.2 terraform_1.12.2_linux_s390x.zip
fpm -s zip -t deb --prefix /usr/bin -n terraform -v 1.12.2 terraform_1.12.2_linux_s390x.zip
exit 0
