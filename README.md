# Infrastructure as Code with Terraform

This repository contains Terraform configurations to provision and manage cloud infrastructure on **Amazon Web Services (AWS)**. 
It utilizes Infrastructure as Code (IaC) principles to ensure consistent and repeatable deployments.

## Features

- **AWS Infrastructure Provisioning**: Automates the creation of AWS resources such as VPCs, subnets, EC2 instances, security groups, and more.
- **SSH Key Management**: Generates and manages SSH key pairs for secure access to EC2 instances.
- **GitHub Integration**: Manages GitHub repository secrets using the Terraform GitHub provider.
- **CI/CD Automation**: Integrates with GitHub Actions for automated Terraform workflows.

## 📁 Repository Structure
.
├── .github/
│   └── workflows/        # GitHub Actions workflows
├── main.tf               # Main Terraform configuration
├── variables.tf          # Input variable definitions
├── outputs.tf            # Output variable definitions
├── terraform.tfvars      # Variable values
└── README.md             # Project documentation

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) v1.0 or higher
- AWS account with appropriate IAM permissions
- [GitHub Personal Access Token](https://github.com/settings/tokens) with `repo` and `admin:repo_hook` scopes

## Usage

1. **Clone the repository**:

   ```bash
   git clone https://github.com/AdmineLaura/infrastructure.git
   cd infrastructure


 Initialize Terraform:
 ```terraform init```

 Review the execution plan:
 ```terraform plan```

 
