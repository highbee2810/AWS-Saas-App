## Scalable SaaS Web Application Deployment with AWS CI/CD and Monitoring
Modern companies struggle to deploy and maintain scalable, secure, and continuously updated web apps. This project solves that by providing a template architecture for automated, secure, and monitored app delivery.
## Project Goal
Build and deploy a 3-tier web application (Frontend + Backend + Database) on AWS with a fully automated CI/CD pipeline and monitoring setup.
## Architecture diagram
![AWS Architecture](./docs/AWS-Saas-App-diagram.png)


---

## 🧱 Infrastructure Setup (Terraform)

All Terraform files are located in the `infrastructure/` directory.

### ✅ What It Creates

- **VPC**
  - 2 Public Subnets
  - 2 Private Subnets

- **Networking**
  - Internet Gateway
  - NAT Gateway

- **Security Groups**
  - SSH (port 22)
  - HTTP (port 80)
  - HTTPS (port 443)

- **IAM Roles & Policies**
  - EC2 instance role
  - CodeBuild role with GitHub access

---

## 📦 Terraform Files

| File          | Purpose                                      |
|---------------|----------------------------------------------|
| `main.tf`     | Core resources and module definitions        |
| `variables.tf`| Input variables for customization            |
| `outputs.tf`  | Key outputs like VPC ID, subnet IDs, etc.    |

---

