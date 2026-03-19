# 🚀 Azure AKS DevSecOps Pipeline

<h3 align="center">⚡ Enterprise-Style Branch-Based CI/CD on Azure with Terraform, ACR, AKS, GitHub Actions, and Production Approval Gates</h3>

<p align="center">
<img src="https://img.shields.io/badge/Azure-Cloud-blue?style=for-the-badge&logo=microsoftazure&logoColor=white" />
<img src="https://img.shields.io/badge/AKS-Kubernetes-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white" />
<img src="https://img.shields.io/badge/ACR-Docker%20Registry-2496ED?style=for-the-badge&logo=docker&logoColor=white" />
<img src="https://img.shields.io/badge/GitHub-Actions-2088FF?style=for-the-badge&logo=githubactions&logoColor=white" />
<img src="https://img.shields.io/badge/Terraform-IaC-7B42BC?style=for-the-badge&logo=terraform&logoColor=white" />
<img src="https://img.shields.io/badge/DevSecOps-Enterprise-success?style=for-the-badge" />
<img src="https://img.shields.io/badge/Production-Approval%20Gate-critical?style=for-the-badge" />
</p>

---

## 🌌 Overview

This project showcases a **branch-based Azure AKS DevSecOps pipeline** built with an enterprise mindset.

It includes:

- 🏗️ **Terraform** for infrastructure provisioning
- 🐳 **Docker** for containerization
- 📦 **Azure Container Registry (ACR)** for image storage
- ☸️ **Azure Kubernetes Service (AKS)** for orchestration
- 🔄 **GitHub Actions** for CI/CD automation
- 🧪 **Environment-based deployments** using namespaces
- 🔐 **Manual approval gate for production**
- ❤️ **Readiness and liveness probes** for application health

The goal of this project is to simulate how modern organizations deploy applications safely across **dev**, **preprod**, and **prod**.

---Important:
if GitHub breaks because of nested triple backticks while you paste into chat or editor, use this exact version in the file:

```md
## 🧭 Architecture Flow

Developer Push
   │
   ├── dev branch
   │   └── Deploy to dev namespace
   │
   ├── preprod branch
   │   └── Deploy to preprod namespace
   │
   └── main branch
       └── Manual approval required
           └── Deploy to prod namespace
```
## ⚙️ Tech Stack

| Layer | Technology |
|---|---|
| Cloud | Microsoft Azure |
| IaC | Terraform |
| Containerization | Docker |
| Registry | Azure Container Registry (ACR) |
| Orchestration | Azure Kubernetes Service (AKS) |
| CI/CD | GitHub Actions |
| Deployment Strategy | Branch-based deployment |
| Environments | dev, preprod, prod |
| Health Checks | Liveness Probe, Readiness Probe |
| Security Control | GitHub Environment Approval Gate |

## 🌍 Environment Mapping

| Git Branch | Kubernetes Namespace | Deployment Target |
|---|---|---|
| `dev` | `dev` | Development |
| `preprod` | `preprod` | Pre-Production |
| `main` | `prod` | Production |

## 🔄 CI/CD Workflow Logic

### ✅ Build Stage

When code is pushed to `dev`, `preprod`, or `main`:

- Source code is checked out
- Azure login is performed
- Docker image is built
- Image is tagged with the Git commit SHA
- Image is pushed to ACR

### ✅ Deploy Stage

Based on the branch:

- `dev` → deploys to `dev` namespace
- `preprod` → deploys to `preprod` namespace
- `main` → deploys to `prod` namespace only after manual approval
## 🔐 Production Approval Gate

Production deployment is protected using **GitHub Environments**.

Before deployment to `prod`:

- The workflow waits for manual approval
- An authorized reviewer approves the deployment
- Only then the workflow continues to the `prod` namespace

This simulates a real enterprise release control process and adds an important safety layer before production changes go live.

## 📁 Project Structure

```text
azure-aks-devsecops-pipeline/
├── .github/
│   └── workflows/
│       └── deploy.yml
├── k8s/
│   ├── deployment-dev.yaml
│   ├── deployment-preprod.yaml
│   └── deployment-prod.yaml
├── modules/
│   ├── acr/
│   ├── aks/
│   └── monitoring/
├── policies/
│   └── opa/
├── sample-app/
├── environments/
├── backend.tf
├── main.tf
├── variables.tf
└── README.md
```

## ☸️ Kubernetes Highlights

This project uses separate Kubernetes manifests for each environment.

### Key features included

- Namespace-based environment isolation
- Service exposure using Kubernetes Services
- Liveness probe for container health validation
- Readiness probe for traffic readiness
- Branch-specific deployment manifests


## ❤️ Health Checks Implemented

Health checks are a critical part of Kubernetes reliability and a very common interview topic.

### Liveness Probe

Checks whether the container is still alive.  
If it fails repeatedly, Kubernetes restarts the container.

### Readiness Probe

Checks whether the container is ready to receive traffic.  
If it fails, Kubernetes stops sending traffic to that pod.

### Why this matters

- Improves application reliability
- Prevents broken pods from receiving traffic
- Helps with safer deployments
- Supports automatic recovery
- Makes the setup more production-ready
________________________________________________________________________

## 🛠️ Example Deployment Commands

```bash
kubectl get namespaces

kubectl get pods -n dev
kubectl get pods -n preprod
kubectl get pods -n prod

kubectl get svc -n dev
kubectl get svc -n preprod
kubectl get svc -n prod

kubectl describe pod <pod-name> -n dev
kubectl describe pod <pod-name> -n preprod
kubectl describe pod <pod-name> -n prod

kubectl logs <pod-name> -n dev
kubectl logs <pod-name> -n preprod
kubectl logs <pod-name> -n prod

kubectl rollout status deployment/myisoapp -n dev
kubectl rollout status deployment/myisoapp -n preprod
kubectl rollout status deployment/myisoapp -n prod
```

## 🧪 What Was Validated in This Project

- Docker image build and push to ACR
- AKS deployment from GitHub Actions
- Branch-based namespace deployment model
- Dev deployment success
- Preprod deployment success
- Prod deployment success
- Production approval gate behavior
- Readiness and liveness probes working
- CrashLoopBackOff troubleshooting and fix
⸻

## 🐞 Real Issue Solved During Implementation

During implementation, one of the main issues encountered was:

- `CrashLoopBackOff` in AKS pods

### Root cause

The issue was caused by using an incorrect container startup configuration and an image/runtime mismatch during earlier deployment attempts.

### How it was fixed

- Rebuilt the Docker image correctly
- Updated the deployment to use the correct working application image
- Verified logs using `kubectl logs`
- Verified pod details using `kubectl describe pod`
- Redeployed and confirmed pod health

### Outcome

After the fix, the application was deployed successfully and the pods reached the `Running` state across the target environment.
⸻

## 🚀 Future Enhancements

This project can be extended further with:

- Helm charts
- Ingress Controller
- TLS / HTTPS
- Azure Monitor integration
- Prometheus + Grafana
- Horizontal Pod Autoscaler
- OPA / Gatekeeper policy enforcement
- ArgoCD / GitOps
- Separate Terraform state per environment
- Blue/Green or Canary deployments
---

## 👨‍💻 Author

**Sudhir Dalvi**

Built as a hands-on Azure DevSecOps project to demonstrate practical skills in:

- Terraform
- Azure AKS
- Azure Container Registry (ACR)
- GitHub Actions
- Kubernetes
- Multi-environment deployment design

---

## ⭐ If You Like This Project

Give it a star and use it as a reference for:

- DevOps portfolio
- Interview discussions
- AKS learning
- GitHub Actions practice
- Enterprise CI/CD design
