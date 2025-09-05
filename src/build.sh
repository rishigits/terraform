#!/bin/bash
set -e -o pipefail
read -ra arr <<< "$@"
version=${arr[1]}
trap 0 1 2 ERR
# Ensure sudo is installed along with utilities to build rpm and deb packages
apt-get update && apt-get install sudo ruby ruby-dev rpm -y
sudo gem install fpm
bash /tmp/linux-on-ibm-z-scripts/Terraform/${version}/build_terraform.sh -y
tar cvfz terraform-${version}-linux-s390x.tar.gz -C $PWD/bin terraform -C $PWD/src/github.com/hashicorp/terraform LICENSE
fpm -s tar -t rpm --prefix /usr/bin -n terraform -v ${version} terraform-${version}-linux-s390x.tar.gz
fpm -s tar -t deb --prefix /usr/bin -n terraform -v ${version} terraform-${version}-linux-s390x.tar.gz
#zip -j terraform_${version}_linux_s390x.zip bin/terraform src/github.com/hashicorp/terraform/LICENSE
#fpm -s zip -t rpm --prefix /usr/bin -n terraform -v ${version} terraform_${version}_linux_s390x.zip
#fpm -s zip -t deb --prefix /usr/bin -n terraform -v ${version} terraform_${version}_linux_s390x.zip
exit 0
