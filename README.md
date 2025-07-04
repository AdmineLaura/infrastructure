# Infrastructure as Code with Terraform

This repository contains Terraform configurations to provision and manage cloud infrastructure on **Amazon Web Services (AWS)**. 
It utilizes Infrastructure as Code (IaC) principles to ensure consistent and repeatable deployments.

## Features

- **AWS Infrastructure Provisioning**: Automates the creation of AWS resources such as VPCs, subnets, EC2 instances, security groups, and more.
- **SSH Key Management**: Generates and manages SSH key pairs for secure access to EC2 instances.
- **GitHub Integration**: Manages GitHub repository secrets using the Terraform GitHub provider.
- **CI/CD Automation**: Integrates with GitHub Actions for automated Terraform workflows.

## 📁 Repository Structure
<pre>
.
├── .github/
│   └── workflows/        # GitHub Actions workflows
├── main.tf               # Main Terraform configuration
├── variables.tf          # Input variable definitions
├── outputs.tf            # Output variable definitions
├── terraform.tfvars      # Variable values (excluded from version control)
└── README.md             # Project documentation
</pre>

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) v1.0 or higher
- AWS account with appropriate IAM permissions
- [GitHub Personal Access Token](https://github.com/settings/tokens) with `repo` and `admin:repo_hook` scopes

## Usage

Clone the repository:

   ```git clone https://github.com/AdmineLaura/infrastructure.git```
   
   ```cd infrastructure```
<br>
<br>

 Initialize Terraform:
 ```terraform init```

 Review the execution plan:
 ```terraform plan```

 Apply the configuration:
 ```terraform apply```

Confirm the action when prompted.

<br>

## Security Considerations
- Sensitive Data: Do not commit sensitive information (e.g., AWS credentials, private keys) to version control. Use environment variables or secret management tools.
- State Management: Consider using remote state backends (e.g., AWS S3 with DynamoDB locking) for collaborative environments.
