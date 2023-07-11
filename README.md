## What is the image for?
This image is intended to be a base for GHA. This image will allow GHA to more easily execute Terraform scripts to deploy to an aws environment.

## What is installed on this image?
- The [AWS CLI](https://awscli.amazonaws.com/awscli-exe-linux-x86_64-2.11.19.zip)
- Version [1.18.2](https://dl.google.com/go/go1.18.2.src.tar.gz) of the Go programming language
- Version [4.5.1](https://github.com/mikefarah/yq/releases/download/v4.5.1/yq_linux_amd64) of yq, a command-line YAML, JSON and XML processor
- Version [0.36.2](https://github.com/terraform-linters/tflint/releases/download/v0.36.2/tflint_linux_amd64.zip) of Terraform linter TFLint
- Version [1.2.5](https://releases.hashicorp.com/terraform/1.2.5/) of infrastructure as code tool Terraform
- Version [0.38.4](https://github.com/gruntwork-io/terragrunt/releases/download/v0.37.1/terragrunt_linux_amd64) of Terraform wrapper Terragrunt
