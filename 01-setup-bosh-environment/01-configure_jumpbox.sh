#!/bin/bash
set -e

# update and install apt managed tools
if [ ! -f /.done ]; then
  sudo apt-get update && sudo apt-get install -y \
	  tree netcat-openbsd build-essential zlibc zlib1g-dev \
	  ruby ruby-dev openssl libxslt-dev libxml2-dev \
	  libssl-dev libreadline6 libreadline6-dev libyaml-dev \
	  libsqlite3-dev sqlite3
  sudo touch /.done
fi

# make bin if not there
[ ! -d ~/bin ] && mkdir ~/bin

if [ -z "$(which bbl)" ]; then
  echo
  echo "Installing bbl..."
  wget -O ~/bin/bbl https://github.com/cloudfoundry/bosh-bootloader/releases/download/v6.10.12/bbl-v6.10.12_linux_x86-64
fi

if [ -z "$(which terraform)" ]; then
  echo
  echo "Installing terraform..."
  TERRAFORMVERSION="0.11.8"
  curl -OL https://releases.hashicorp.com/terraform/${TERRAFORMVERSION}/terraform_${TERRAFORMVERSION}_linux_amd64.zip
  unzip terraform_${TERRAFORMVERSION}_linux_amd64.zip && rm *.zip
  mv terraform  ~/bin/terraform
fi

if [ -z "$(which bosh)" ]; then
  echo "Installing bosh CLI..." >&2
  curl -s https://api.github.com/repos/cloudfoundry/bosh-cli/releases/latest \
  | grep browser_download_url \
  | grep linux-amd64 \
  | cut -d '"' -f 4 \
  | wget -qi - -O bosh
  mv bosh ~/bin/bosh
fi

# in .bashrc
[ ! -f ~/.bashrc.bk ] && cp ~/.bashrc ~/.bashrc.bk
grep -q '~/bin:' ~/.bashrc || echo -e 'export PATH=~/bin:$PATH' >> ~/.bashrc
## bbl
echo export BBL_IAAS="gcp" >> ~/.bashrc
echo export BBL_GCP_REGION="europe-west3" >> ~/.bashrc

# make exec
chmod +x ~/bin/*
