# managed-aws-terraform

Terraform infrastructure-as-code for the managed AWS platform — EKS, RDS PostgreSQL, ALB, ECR, VPN, and shared services.

## Structure

```
managed-aws-terraform/
├── bootstrap/                        # Run once — creates S3 state bucket + DynamoDB lock table
├── modules/
│   ├── vpc/                          # VPC, subnets, NAT gateway (EKS-tagged)
│   ├── ec2/                          # Generic EC2 module (Jenkins, devtools)
│   ├── eks/                          # EKS cluster, managed node group, OIDC provider
│   ├── rds/                          # RDS PostgreSQL, subnet group, parameter group
│   ├── alb/                          # Application Load Balancer + listeners
│   ├── ecr/                          # ECR repositories with lifecycle policies
│   ├── jenkins/                      # Jenkins EC2 instance (shared)
│   ├── devtools/                     # Devtools EC2 instance (shared)
│   ├── vpc-peering/                  # VPC peering between shared ↔ dev/prod
│   └── vpn/                          # OpenVPN server
└── environments/
    ├── dev/
    │   ├── vpc/                      # Dev VPC
    │   ├── eks/                      # Dev EKS cluster
    │   └── rds/                      # Dev RDS PostgreSQL
    ├── prod/
    │   ├── vpc/                      # Prod VPC
    │   ├── eks/                      # Prod EKS cluster
    │   ├── rds/                      # Prod RDS PostgreSQL (multi-AZ)
    │   └── alb/                      # Prod ALB
    └── shared/
        ├── ecr/                      # ECR repositories
        ├── jenkins/                  # Jenkins EC2
        ├── devtools/                 # Devtools EC2
        ├── vpc-peering/              # Peering shared ↔ dev + shared ↔ prod
        └── vpn/                      # OpenVPN
```

## First-time setup

```bash
# 1. Bootstrap remote state (run once)
cd bootstrap
terraform init && terraform apply -var-file=terraform.tfvars

# 2. Uncomment the backend block in each environment's main.tf

# 3. Provision in order:
#    shared/ecr → shared/jenkins → shared/devtools → shared/vpn
#    dev/vpc → dev/eks → dev/rds
#    prod/vpc → prod/eks → prod/rds → prod/alb
```

## Deployment order

Resources depend on each other — always provision in this order:

```
shared/ecr
shared/jenkins
shared/devtools
shared/vpn
shared/vpc-peering   ← after dev/vpc and prod/vpc exist

dev/vpc
dev/eks              ← needs dev/vpc outputs
dev/rds              ← needs dev/vpc + dev/eks outputs

prod/vpc
prod/eks             ← needs prod/vpc outputs
prod/rds             ← needs prod/vpc + prod/eks outputs
prod/alb             ← needs prod/vpc outputs
```

## Jenkins pipelines

Terraform apply/destroy pipelines live in **managed-aws-jenkins** and reference this repo via SCM checkout inside `terraformDeploy` / `terraformDestroy` shared library steps.

## Key differences from the self-managed k8s project

| Self-managed | Managed |
|---|---|
| k8s-master + k8s-worker EC2 + kubeadm | EKS managed control plane + node groups |
| Packer AMI builds | Not needed — EKS manages node OS |
| Custom CNI install script | AWS VPC CNI (built-in) |
| NLB module | ALB module (ALB ingress controller on EKS) |
| No database | RDS PostgreSQL |
| modules/k8s-asg-worker | Replaced by EKS node group scaling config |
