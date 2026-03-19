Enterprise AKS DevSecOps Platform

A hands-on Azure DevSecOps project that provisions AKS infrastructure with Terraform, builds and pushes container images to Azure Container Registry (ACR), and deploys workloads to Kubernetes using GitHub Actions with branch-based environment promotion.

Project overview

This project demonstrates an end-to-end AKS delivery flow:
	•	Infrastructure as Code with Terraform
	•	Container image build and push to Azure Container Registry
	•	Kubernetes deployments to AKS
	•	Branch-based CI/CD using GitHub Actions
	•	Environment separation for dev, preprod, and prod
	•	Production approval gate using GitHub Environments
	•	Health checks with readiness and liveness probes
	•	Policy as code structure using OPA policies

Architecture

Developer Push
   |
   +--> dev branch ------> GitHub Actions ------> Build Docker image ------> Push to ACR ------> Deploy to dev namespace
   |
   +--> preprod branch --> GitHub Actions ------> Build Docker image ------> Push to ACR ------> Deploy to preprod namespace
   |
   +--> main branch -----> GitHub Actions ------> Build Docker image ------> Push to ACR ------> Approval Gate ------> Deploy to prod namespace

Terraform --> Azure Resource Group / ACR / AKS / Monitoring foundation

Repository structure

.
├── .github/workflows/        # GitHub Actions workflow
├── environments/            # Backend or environment-related configs
├── k8s/                     # Kubernetes manifests by environment
│   ├── deployment-dev.yaml
│   ├── deployment-preprod.yaml
│   └── deployment-prod.yaml
├── modules/                 # Terraform modules
│   ├── acr/
│   ├── aks/
│   └── monitoring/
├── policies/opa/            # OPA policy files
├── sample-app/              # Containerized sample application
├── backend.tf               # Terraform backend config
├── main.tf                  # Root Terraform configuration
└── variables.tf             # Terraform variables

CI/CD workflow

The GitHub Actions pipeline is branch-aware:

Branch	Target environment	Kubernetes namespace	Approval required
dev	Dev	dev	No
preprod	Preprod	preprod	No
main	Prod	prod	Yes

Pipeline flow
	1.	Checkout repository
	2.	Detect branch and set deployment variables
	3.	Login to Azure
	4.	Login to ACR
	5.	Build Docker image
	6.	Push image to ACR
	7.	Get AKS credentials
	8.	Update Kubernetes manifest with the new image tag
	9.	Deploy to the matching namespace
	10.	For main, wait for manual approval before production deployment

Kubernetes deployment design

Each environment has a dedicated manifest under k8s/.

The deployment includes:
	•	environment-specific namespace targeting
	•	container image from ACR
	•	readiness probe
	•	liveness probe
	•	service exposure for testing

Typical deployment characteristics:
	•	Dev: fast testing and validation
	•	Preprod: staging-style validation before release
	•	Prod: controlled deployment with approval gate

Health checks

The application uses Kubernetes probes to improve stability.

Readiness probe

Determines when the pod is ready to receive traffic.

Liveness probe

Determines when the container should be restarted if it becomes unhealthy.

Example pattern used:

readinessProbe:
  httpGet:
    path: /
    port: 80
  initialDelaySeconds: 5
  periodSeconds: 5

livenessProbe:
  httpGet:
    path: /
    port: 80
  initialDelaySeconds: 15
  periodSeconds: 10

Terraform modules

This project is structured using reusable Terraform modules.

Included modules
	•	ACR module: creates Azure Container Registry
	•	AKS module: creates Azure Kubernetes Service cluster
	•	Monitoring module: foundation for observability integration

Prerequisites

Before using this project, make sure you have:
	•	Azure subscription
	•	Azure CLI installed
	•	Terraform installed
	•	Kubectl installed
	•	Docker installed
	•	GitHub repository with Actions enabled
	•	Azure service principal with required permissions
	•	GitHub secret named AZURE_CREDENTIALS

GitHub secret format

Add the Azure credentials JSON to:
	•	Settings → Secrets and variables → Actions → New repository secret
	•	Secret name: AZURE_CREDENTIALS

GitHub Environment setup

Create these environments in GitHub:
	•	dev
	•	preprod
	•	prod

For prod, enable:
	•	Required reviewers
	•	optional admin bypass, based on your preference

This makes production deployment pause until approval is granted.

Setup commands

Terraform initialization

terraform init
terraform plan
terraform apply

Create namespaces

kubectl create namespace dev
kubectl create namespace preprod
kubectl create namespace prod

Apply manifests manually

kubectl apply -f k8s/deployment-dev.yaml
kubectl apply -f k8s/deployment-preprod.yaml
kubectl apply -f k8s/deployment-prod.yaml

Verify deployments

kubectl get pods -n dev
kubectl get pods -n preprod
kubectl get pods -n prod

kubectl get svc -n dev
kubectl get svc -n preprod
kubectl get svc -n prod

Troubleshooting commands

kubectl describe pod -n dev <pod-name>
kubectl logs -n dev <pod-name>

kubectl describe pod -n preprod <pod-name>
kubectl logs -n preprod <pod-name>

kubectl describe pod -n prod <pod-name>
kubectl logs -n prod <pod-name>

Example workflow file behavior

The GitHub Actions workflow maps branches to environments:
	•	dev → k8s/deployment-dev.yaml
	•	preprod → k8s/deployment-preprod.yaml
	•	main → k8s/deployment-prod.yaml

It tags images using the Git commit SHA and deploys the exact built image.

Screenshots to add

Recommended screenshots for this README:
	1.	GitHub Actions successful run
	2.	Dev deployment running in AKS
	3.	Preprod deployment running in AKS
	4.	Prod deployment waiting for approval
	5.	Prod deployment successful after approval
	6.	GitHub Environments protection rules
	7.	Kubernetes pods and services output
	8.	Azure portal view of AKS and ACR

You can place them under a folder such as:

screenshots/

And reference them like:

![GitHub Actions Success](screenshots/github-actions-success.png)

Interview talking points

This project is useful for interviews because it demonstrates:
	•	Terraform-based AKS provisioning
	•	modular Infrastructure as Code design
	•	branch-based deployment strategy
	•	GitHub Actions CI/CD implementation
	•	Azure authentication using service principal
	•	ACR image lifecycle handling
	•	Kubernetes readiness and liveness probes
	•	namespace-based environment separation
	•	production approval gates
	•	troubleshooting CrashLoopBackOff and deployment issues
	•	practical DevSecOps structure with OPA policy folders

How to explain this project in an interview

I built an Azure DevSecOps platform project where infrastructure is provisioned with Terraform, container images are built and pushed to Azure Container Registry through GitHub Actions, and deployments are promoted by branch into AKS namespaces for dev, preprod, and prod. I added readiness and liveness probes for reliability and used a GitHub Environment approval gate to protect production deployments.

Key lessons learned
	•	Do not commit .terraform/ provider binaries to Git
	•	Ensure Docker build context path is correct, such as ./sample-app
	•	Namespace-specific deployments must match the intended manifest and namespace
	•	CrashLoopBackOff often comes from image or startup-command mismatch
	•	Health probes help validate real application readiness
	•	Production deployments should have manual approval controls

Future improvements
	•	Ingress controller and custom domain
	•	TLS with cert-manager
	•	Helm or Kustomize for better manifest management
	•	Prometheus and Grafana integration
	•	Azure Monitor and Log Analytics dashboards
	•	OPA or Gatekeeper policy enforcement in deployment stage
	•	Separate Terraform state/workspaces per environment
	•	Autoscaling with HPA
	•	Key Vault integration for secret management

Final status

Current implementation includes:
	•	AKS deployment pipeline working from GitHub Actions
	•	dev, preprod, and prod namespaces
	•	branch-based deployment logic
	•	production approval gate support
	•	readiness and liveness probes
	•	environment-specific Kubernetes manifests

⸻

Author notes

This project is designed as a practical portfolio-ready DevSecOps implementation for Azure and Kubernetes learning, demos, and interviews.
