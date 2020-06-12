FROM ubuntu:latest
MAINTAINER "John Griffith <john.griffith8@gmail.com>"

# TODO
# Add a wrapper script and an entrypoint 
# Figure out strategy for parsing out input variables (env, pass in tfvars file etc)
# Persistence

RUN apt update -y \
  && apt -y install \
  curl \
  wget \
  unzip \
  && rm -rf /var/lib/apt/lists/*

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl \
  && chmod +x ./kubectl\
  && mv ./kubectl /usr/local/bin/

RUN wget https://get.helm.sh/helm-v3.2.3-linux-amd64.tar.gz\
  && tar xzf helm-v3.2.3-linux-amd64.tar.gz\
  && cp linux-amd64/helm /usr/local/bin/\
  && rm helm-v3.2.3-linux-amd64.tar.gz

RUN helm repo add rancher-stable https://releases.rancher.com/server-charts/stable\
  && helm repo add jetstack https://charts.jetstack.io\
  && helm repo update

RUN wget https://releases.hashicorp.com/terraform/0.12.26/terraform_0.12.26_linux_amd64.zip\
  && unzip terraform_0.12.26_linux_amd64.zip\
  && mv ./terraform /usr/local/bin/\
  && rm terraform_0.12.26_linux_amd64.zip

RUN wget https://github.com/rancher/terraform-provider-rke/releases/download/1.0.0/terraform-provider-rke-linux-amd64.tar.gz\
  && tar -xzf terraform-provider-rke-linux-amd64.tar.gz\
  && mkdir -p /root/.terraform.d/plugins\
  && mv ./terraform-provider-rke-9c95410/ /root/.terraform.d/plugins

RUN mkdir ez-rancher

COPY  terraform-plugins /root/.terraform.d
COPY terraform /ez-rancher

# TODO
# Add a wrapper script and an entrypoint 
