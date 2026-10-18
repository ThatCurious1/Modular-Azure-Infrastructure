::: {align="center"}
# ☁️🚀 Azure Terraform Landing Zone

### 🏗️ Modular Infrastructure • 🔐 Key Vault • 🌐 Secure Networking • ⚙️ Dev/Prod

![Terraform](https://img.shields.io/badge/Terraform-IaC-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![Microsoft
Azure](https://img.shields.io/badge/Microsoft_Azure-Cloud-0078D4?style=for-the-badge&logo=microsoftazure&logoColor=white)
![DevOps](https://img.shields.io/badge/DevOps-Automation-00A4EF?style=for-the-badge&logo=azuredevops&logoColor=white)
![Security](https://img.shields.io/badge/Key_Vault-Secrets-2E7D32?style=for-the-badge&logo=microsoftazure&logoColor=white)

**A reusable Terraform project for deploying a modular Azure
landing-zone foundation.**

[✨ Features](#-project-highlights) • [🧱 Architecture](#-architecture)
• [🚀 Quick Start](#-quick-start) • [🔐 Security](#-security-first)
:::

------------------------------------------------------------------------


## 🌟 Project Highlights

### 🧩 Reusable Terraform Modules
Organized, reusable Terraform modules for consistent infrastructure deployment and easier maintenance.

### 🌍 Environment Separation
Separate `dev/` and `prod/` folders for environment-specific configuration and resource management.

### 🔐 Azure Key Vault Integration
Retrieves VM administrator credentials from Azure Key Vault instead of hardcoding secrets in Terraform files.

### 🛡️ Secure VM Access
Uses Azure Bastion for VM access, with a Public IP configured for Bastion rather than directly on the VM.

### 📈 Infrastructure as Code
Terraform enables infrastructure changes to be reviewed with `terraform plan` before deployment.

### 🌐 Azure Networking
Includes Virtual Networks, subnets, network interfaces, Public IP, and NSG-related configuration for network connectivity and access control.

---

## 🧱 Architecture

``` mermaid
flowchart TD
    A[🧑‍💻 Engineer] --> B[⚙️ Terraform]
    B --> C[📁 Environment: dev / prod]
    C --> D[🧩 Reusable Modules]
    D --> E[📦 Resource Group]
    D --> F[🌐 VNet & Subnets]
    D --> G[🌉 Azure Bastion]
    D --> H[🖥️ Linux VM + NIC]
    G --> I[🌍 Public IP]
    J[🔐 Azure Key Vault] -->|Username & Password secrets| H
    F --> H
    K[🛡️ NSG rules / network controls] -. configured as applicable .-> F
```

> 💡 **Architecture note:** A Network Interface (NIC) and a Network
> Security Group (NSG) are separate Azure resources. Confirm that the
> NSG is created and associated with the NIC or subnet in the actual
> implementation.

## 🧰 Azure Resources

  -----------------------------------------------------------------------
  Resource                            Purpose
  ----------------------------------- -----------------------------------
  📦 Resource Group                   Groups and manages environment
                                      resources

  🌐 Virtual Network (VNet)           Provides the private network
                                      boundary

  🧭 Subnets                          Segments network workloads;
                                      includes `AzureBastionSubnet`

  🖧 Network Interface (NIC)           Connects the Linux VM to a subnet

  🛡️ Network Security Group (NSG)     Defines allowed and denied network
                                      traffic when associated

  🌍 Public IP                        Provides public connectivity for
                                      the Bastion host

  🌉 Azure Bastion                    Managed access to VMs without a
                                      VM-level public IP

  🐧 Linux Virtual Machine            Compute workload in the virtual
                                      network

  🔐 Azure Key Vault                  Stores VM admin credentials as
                                      secrets

  🧩 Terraform Modules                Reusable definitions for
                                      infrastructure components
  -----------------------------------------------------------------------

## 📂 Repository Structure

``` text
📦 Azure-Terraform-Landing-Zone
├── 📁 Environment
│   ├── 📁 dev
│   └── 📁 prod
└── 📁 Module
    ├── 📁 Azurerm_Bastion
    ├── 📁 Azurerm_Resource_Group
    ├── 📁 Azurerm_SubNet
    ├── 📁 Azurerm_Virtual_Machine
    ├── 📁 Azurerm_Virtual_Network
    └── 📁 (additional modules, if configured)
```

## ⚡ Tech Stack

-   ☁️ **Cloud:** Microsoft Azure
-   🏗️ **Infrastructure as Code:** Terraform
-   🔐 **Secrets Management:** Azure Key Vault
-   🌐 **Networking:** VNet, Subnets, NIC, NSG, Public IP
-   🖥️ **Compute:** Azure Linux Virtual Machine
-   🌉 **Secure Access:** Azure Bastion
-   🔁 **Workflow:** `terraform init` → `validate` → `plan` → `apply`

## 🚀 Quick Start

### 1️⃣ Prerequisites

-   An Azure subscription with permissions to create the required
    resources.
-   Terraform CLI and Azure CLI installed.
-   Authentication configured using `az login` or an approved service
    principal.
-   Permission to read the required secrets from the existing Key Vault.
-   A VM size and Ubuntu image compatible with each other and available
    in the target region.

### 2️⃣ Sign in to Azure

``` bash
az login
az account show
```

### 3️⃣ Initialize the environment

Run from the environment directory, for example:

``` bash
cd Environment/dev
terraform init
```

### 4️⃣ Format and validate

``` bash
terraform fmt -recursive
terraform validate
```

### 5️⃣ Preview infrastructure changes

``` bash
terraform plan
```

### 6️⃣ Deploy after reviewing the plan

``` bash
terraform apply
```

> 🚦 Review the plan before applying. Check resource names, region, VM
> image generation, VM size availability, subnet names and network
> rules.

## 🔐 Security First

-   ✅ Store secrets in Azure Key Vault; never hardcode passwords in
    Terraform files.
-   🔒 Restrict Key Vault permissions using least privilege.
-   🗃️ Protect Terraform state: secret values read by data sources may
    be stored in state.
-   ☁️ Use a secure remote backend with encryption, restricted access
    and state locking for shared workflows.
-   🚫 Do not commit `.tfstate`, secret-containing `.tfvars`,
    credentials, or generated plan files containing sensitive data.
-   🛡️ Apply NSG rules deliberately and expose only the ports required.
-   🌉 Prefer Bastion access rather than assigning a public IP directly
    to the VM where appropriate.

## 🧹 Clean Up

To inspect what would be removed:

``` bash
terraform plan -destroy
```

If the plan is correct and you have approval:

``` bash
terraform destroy
```

> ⚠️ `terraform destroy` deletes resources managed by the selected
> state. Never run it against shared or production infrastructure
> without authorization.

## 🧪 Deployment Checklist

-   [ ] Azure login and subscription verified
-   [ ] Resource Group and region names match
-   [ ] VNet and subnet names match exactly
-   [ ] `AzureBastionSubnet` meets Azure Bastion requirements
-   [ ] VM image generation matches the selected VM size
-   [ ] Key Vault secrets exist and access permissions are correct
-   [ ] NIC and NSG are configured and associated as intended
-   [ ] `terraform validate` and `terraform plan` reviewed
-   [ ] Terraform state storage is protected

## 🎯 Learning Outcomes

Through this project, the key areas demonstrated are:

-   🧩 Modular Terraform design and `for_each`
-   🌐 Azure networking and subnet planning
-   🔐 Key Vault-based secret retrieval
-   🖥️ Linux VM provisioning
-   🌉 Bastion-based VM access
-   🔎 Terraform validation and plan-based change review
-   🛡️ State security and infrastructure deployment practices

------------------------------------------------------------------------

::: {align="center"}
### 💙 Built with Terraform + Microsoft Azure

**Infrastructure as Code • Reusable Modules • Secure by Design**
:::
