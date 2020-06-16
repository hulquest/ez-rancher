# docker build -t ez-rancher .
# docker run -it --rm -v ${PWD}/terraform.tfvars:/terraform/terraform.tfvars -v ${PWD}/deliverables:/terraform/deliverables ez-rancher apply -state=deliverables/terraform.tfstate
FROM hashicorp/terraform:light

WORKDIR /terraform

COPY main.tf /terraform/main.tf
COPY cloudinit/* /terraform/cloudinit/
COPY variables.tf /terraform/variables.tf

ADD https://storage.googleapis.com/kubernetes-release/release/v1.17.4/bin/linux/amd64/kubectl /usr/local/bin/kubectl
ADD https://github.com/rancher/terraform-provider-rke/releases/download/1.0.0/terraform-provider-rke-linux-amd64.tar.gz /

RUN chmod +x /usr/local/bin/kubectl \
  && tar -xzf /terraform-provider-rke-linux-amd64.tar.gz \
  && mkdir -p /root/.terraform.d/plugins/linux_amd64/ \
  && mv terraform-provider-rke-*/terraform-provider-rke /root/.terraform.d/plugins/linux_amd64/ \
  && rm -rf /terraform-provider-rke-linux-amd64.tar.gz \
  && rm -rf terraform-provider-rke-* \
  && ssh-keygen -q -t rsa -N '' -f ~/.ssh/id_rsa \
  && terraform init
