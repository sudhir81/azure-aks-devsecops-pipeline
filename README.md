
### Outcome

After the fix, the application was deployed successfully and the pods reached the `Running` state across the target environment.
⸻
## 💼 Interview Talking Points

### Explain the project in one line

I built a branch-based Azure AKS DevSecOps pipeline where GitHub Actions builds and pushes Docker images to Azure Container Registry (ACR), then deploys them to dev, preprod, and prod Kubernetes namespaces, with manual approval before production release.

### Key concepts you can discuss confidently

- Terraform module-based design
- AKS and ACR integration
- Docker image tagging with commit SHA
- GitHub Actions workflow logic
- Branch-based deployment strategy
- Namespace isolation
- Liveness and readiness probes
- Approval gate for production
- CrashLoopBackOff troubleshooting

### Real engineering maturity shown

- Separated environments
- Controlled production rollout
- Health-based deployment validation
- Debugging using `kubectl logs` and `kubectl describe`
- Reusable CI/CD design

🎯 Why This Project Stands Out
