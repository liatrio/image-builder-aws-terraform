FROM ubuntu:22.04

LABEL org.opencontainers.image.source https://github.com/liatrio/builder-images

ARG GO_VERSION=1.18.2
ARG YQ_VERSION=4.5.1
ARG TFLINT_VERSION=v0.39.3
ARG TERRAFORM_VERSION=1.2.8
ARG TERRAGRUNT_VERSION=v0.38.9
ARG AWS_CLI_VERSION=2.11.19

ENV PATH="$PATH:/usr/local/go/bin"

RUN apt-get update && apt-get install -yq \
    apt-transport-https \
    ca-certificates \
    unzip \
    curl \
    git \
    gnupg \
    jq \
    lsb-release \
    wget \
    zip && \
    rm -rf /var/lib/apt/lists/*

# Install yq
RUN cd /tmp && \
    wget https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_amd64 && \
    chmod +x yq_linux_amd64 && \
    mv -vf yq_linux_amd64 /usr/local/bin/yq && \
    yq -V

# Install aws cli
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-${AWS_CLI_VERSION}.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install

# Install go
RUN wget -O /tmp/go.tar.gz https://golang.org/dl/go${GO_VERSION}.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf /tmp/go.tar.gz && \
    rm /tmp/go.tar.gz && \
    go version

# Install tfenv and setup gpg verification
RUN mkdir /opt/tfenv && \
    git clone https://github.com/tfutils/tfenv.git /opt/tfenv/.tfenv && \
    chmod -R ago+w /opt/tfenv/ && \
    echo 'PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/opt/tfenv/.tfenv/bin"' > /etc/environment && \
    touch /opt/tfenv/.tfenv/use-gnupg && \
    curl https://keybase.io/hashicorp/pgp_keys.asc | gpg --import && \
    echo 'curl https://keybase.io/hashicorp/pgp_keys.asc | gpg --import' >> /etc/skel/.profile

ENV PATH $PATH:/usr/local/go/bin:/opt/tfenv/.tfenv/bin

# Install terraform
RUN tfenv install ${TERRAFORM_VERSION} && \
    tfenv use ${TERRAFORM_VERSION} && \
    chmod -R ago+w /opt/tfenv/ && \
    terraform version

# Install terragrunt
RUN wget -O /tmp/terragrunt_linux_amd64 https://github.com/gruntwork-io/terragrunt/releases/download/${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 && \
    mv /tmp/terragrunt_linux_amd64 /usr/bin/terragrunt && \
    chmod +x /usr/bin/terragrunt && \
    terragrunt --version

# Install tflint
RUN mkdir -p /opt/tflint && \
    cd /opt/tflint && \
    wget -O tflint.zip https://github.com/terraform-linters/tflint/releases/download/${TFLINT_VERSION}/tflint_linux_amd64.zip && \
    unzip tflint.zip && \
    chmod +x tflint && \
    mv -vf tflint /usr/local/bin/tflint && \
    rm -rf /opt/tflint && \
    tflint -v
