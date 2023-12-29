# Serverless Data Lake

## Root Documentation

The project root module structure is as below:

```
serverless_data_lake 
├── .github
│   └── workflows
│       └── install_cli_tools
├── bin
│   ├── batch_ingestion
│   ├── install_aws_cli
│   ├── install_terraform_cli
│   └── set_tf_alias
├── cfn
│   ├── scripts
│   │   ├── delete_cfn_stack
│   │   ├── deploy_iam_roles
│   │   └── deploy_kdg
│   └── templates
│       ├── serverlessDataLake.json
│       └── kdg-cognito-setup.json
├── journal
│   ├── documentation.md
│   └── prerequisite.md
├── py_scripts
│   ├── advanced_transformation.py
│   └── transformation_generator.py
├── src
│   ├── main.tf
│   ├── outputs.tf
│   ├── resource_firehose.tf
│   ├── resource_glue.tf
│   ├── resource_storage.tf
│   ├── terraform.tfvars
│   └── variables.tf
├── .gitignore
├── LICENSE
└── README.md
```

## Terraform and Input Variables

### Terraform Cloud Variables

Terraform has two types of variables:

- Environment Variables - these can be set in bash terminal e.g AWS credentials
- Terraform Variables - these are set in the tfvars file

Terraform Cloud variables can be set as sensitive to avoid visibility of credentials in UI.

### Loading Terraform Input Variables

Visit this link [Terraform Input Variables](https://developer.hashicorp.com/terraform/language/values/variables) to learn more about environment variables in terraform.

#### var flag

Append the `-var` flag to set an input variable or override a variable in the tfvars file e.g `terraform -var user_id="my-user-id"`

#### var-file flag

To set lots of variables, it is more convenient to specify their values in a variable definitions file (with a filename ending in either .tfvars or .tfvars.json) and then specify that file on the command line with -var-file e.g `terraform apply -var-file="testing.tfvars"`

## Dealing With Configuration Drift

In the case of lost statefile, tear down all your cloud infrastructure manually.

`Terraform port` is an option but doesn't apply for all cloud resources, instead check the terraform providers documentation for which resources support import.

### Fix Manual Configurarion

If a resource is deleted or modified manually, try running `Terraform plan` to put the infrastructure back into the expected state fixing the configuration drift.

### Fix using Terraform Refresh

```sh
terraform apply -refresh-only -auto-approve
```

## Terraform Provisioners

Provisioners allow execution of commands on compute instances e.g AWS CLI command.

Though not recommended for use by hashicorp because Configuration management tools like Ansible are a better fit, the functionality exists.

[Learn about provisioners](https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax)
