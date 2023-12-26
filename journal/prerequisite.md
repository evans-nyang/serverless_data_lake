# Project Prerequisite

- [Semantic Versioning](#semantic-versioning)
- [Install the Terraform CLI](#install-the-terraform-cli)
  - [Considerations with Terraform CLI changes](#considerations-with-terraform-cli-changes)
  - [Consideration for Linux Distribution](#consideration-for-linux-distribution)
  - [Refactoring into Bash Scripts](#refactoring-into-bash-scripts)
    - [Shebang](#shebang)
    - [Execution Considerations](#execution-considerations)
    - [Linux Permissions Consideration](#linux-permissions-consideration)
- [Working Env Vars](#working-env-vars)
  - [env command](#env-command)
  - [Setting and unsetting environment variable](#setting-and-unsetting-environment-variables)
  - [Printing Vars](#printing-vars)
  - [Scoping Env Vars](#scoping-env-vars)
- [AWS CLI Installation](#aws-cli-installation)
- [Terraform Basics](#terraform-basics)
  - [Terraform Registry](#terraform-registry)
  - [Terraform Console](#terraform-console)
    - [Terraform Init](#terraform-init)
    - [Terraform Plan](#terraform-plan)
    - [Terraform Apply](#terraform-apply)
    - [Terraform Destroy](#terraform-destroy)
  - [Terraform Lock File](#terraform-lock-file)
  - [Terraform State File](#terraform-state-file)
  - [Terraform Directory](#terraform-directory)
- [Issues](#issues)
  - [AWS credentials authentication in Terraform Cloud](#aws-credentials-authentication-in-terraform-cloud)

## Semantic Versioning

This project is going to utilize semantic versioning for its tagging
[semver.org](https://semver.org/)

Given a version number **MAJOR.MINOR.PATCH** e.g v1.0.1, increment the:

- **MAJOR** version when you make incompatible API changes
- **MINOR** version when you add functionality in a backward compatible manner
- **PATCH** version when you make the backward compatible bug fixes

## Install the Terraform CLI

### Considerations with Terraform CLI changes

Introduction of GPG keyring changes has affected Terraform CLI installation. There is need to refer to the latest CLI installation instructions via the Terraform documentation.

[Install Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

### Consideration for Linux Distribution

This project is built against Ubuntu.
Please consider checking your linux distribution and change accordingly.

[How To Check OS Version in Linux](https://www.cyberciti.biz/faq/how-to-check-os-version-in-linux-command-line/)

Example of checking OS version:

```
$ cat /etc/os-release

PRETTY_NAME="Ubuntu 22.04.3 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.3 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy
```

### Refactoring into Bash Scripts

While fixing the Terraform CLI gpg depracation issue we notice that bash scripts steps were a considerable amount of code. So we create a bash script to perform the installation.

This bash script is located here: [./bin/install_terraform_cli](./bin/install_terraform_cli)

- This allows easier debugging and manual Terraform CLI installation.
- This allows better portablity for other projects needing Terraform installation.

#### Shebang

A Shebang informs the bash script what program will interpret it e.g `#!/bin/bash`

This is the recommended format for bash: `#!/usr/bin/env bash`

- for portability across different distributions
- It will search the user's path for the bash executable

[Learn more about Shebang](https://en.wikipedia.org/wiki/Shebang_(Unix))

#### Execution Considerations

When executing the bash script we can use the `./` shorthand notation.

e.g `./bin/install_terraform_cli`

If using a script in .gitpod.yml, we'll need to point the script to a program that will interpret it.

e.g `source ./bin/install/terraform_cli`

#### Linux Permissions Consideration

In order to make the bash scripts executable, we need to change the linux permission for the fix to be executable at the user mode.

```sh
chmod u+x ./bin/install_terraform_cli
```

alternatively

```sh
chmod 744 ./bin/install_terraform_cli
```

[Learn more about permissions](https://en.wikipedia.org/wiki/Chmod)

## Working Env Vars

#### env command

We can list out all Environment Variables (Env Vars) using the `env` command.

We can filter specific environment variables using grep command e.g `env | grep AWS_`

#### Setting and unsetting environment variables

In the terminal we can set env vars like `export MYVAR='myvariable'`

In the terminal we can unset env vars like `unset MYVAR`

Env vars can be set temporarily when running a command

```sh
MYVAR='myvariable' ./bin/print_message
```

Set env within bash script without writing export

```sh
#!/usr/bin/env bash

MYVAR='myvariable'

echo $MYVAR
```

#### Printing Vars

Print Env Vars using the `echo` command, e.g `echo $MYVAR`

#### Scoping Env Vars

New terminal window in VSCode will not be aware of Env Vars set in another window.
Set env vars in bash profile to ensure persistence in all open bash terminals.

## AWS CLI Installation

Install aws cli via the bash script [../bin/install_aws_cli](../bin/install_aws_cli)

[Getting Started Installation (AWS CLI)](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

[AWS Env Vars](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-envvars.html)

Check for correct AWS credentials configuration by running the command below:

```sh
aws sts get-caller-identity
```

The result below is displayed if command request was successful:

```sh
{
    "UserId": "AKYA12ING4MAN",
    "Account": "123456789012",
    "Arn": "arn:aws:iam::1234566789012:user/terraform-beginner-bootcamp"
}
```

New AWS users might need to create IAM roles for CLI access.

## Terraform Basics

### Terraform Registry

Terraform sources their providers and modules from the Terraform registry located at [registry.terraform.io](https://registry.terraform.io/)

- **Providers** is an interface to api's that allow creation of resources in terraform
- **Modules** allow refactoring and modularization of Terraform code ensuring portability and sharing.

[Random Terraform Provider](https://registry.terraform.io/providers/hashicorp/random/)

### Terraform Console

View a list of all available Terraform commands by typing `terraform`

#### Terraform Init

Run `terraform init` at the start of a new project to download binaries for all terraform providers.

#### Terraform Plan

To generate a changeset, about the state of infrastructure and what will change, run `terraform plan`.

To output the changeset i.e plan to be passed to an apply, append `-o` e,g `terraform plan -o`

#### Terraform Apply

This command i.e `terraform apply`, will run a plan and pass the changeset for execution by terraform.

Provide an auto approve flag to automatically approve an apply command e.g `terraform apply --auto-approve`

#### Terraform Destroy

Use the command `terraform destroy` to delete and get rid of provisioned cloud service resources.

Append the auto approve flag to accept deletion when prompted e.g `terraform apply --auto-approve`

### Terraform Lock File

`terraform.lock.hcl` contains the locked versioning for the providers or modules used within the project.

The Terraform Lock File should be committed to Version Control System e.g GitHub.

### Terraform State File

`terraform.tfstate` contains information about the current state of the infrastructure.

The Terraform State File **SHOULD NOT** be committed to Version Control System, it can contain sensitive information.

Loss of this file leads to loss of knowledge about the terraform state.

`terraform.tfstate.backup` is the previous state file.

### Terraform Directory

`.terraform` directory contains binaries of terraform providers.

## Issues

### AWS credentials authentication in Terraform Cloud

When trying `terraform plan` there might arise an issue with credential sources when trying to authenticate with AWS.

To resolve this issue, you should configure AWS credentials in Terraform Cloud as shown in the steps below:

- In Terraform Cloud:
  - Go to your Terraform Cloud organization.
  - Navigate to the workspace where you are running this configuration (terra-house-1).
  - Click on "Settings" in the workspace menu.
  - Under the "General" tab, find the "Environment Variables" section.
  - Add AWS Credentials:
- Add two environment variables:
  - AWS_ACCESS_KEY_ID: Set this to your AWS access key.
  - AWS_SECRET_ACCESS_KEY: Set this to your AWS secret key.
- Save Changes:
  - Save the changes.
