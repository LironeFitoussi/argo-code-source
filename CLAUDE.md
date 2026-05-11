# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

### Local dev
```bash
cd app && npm install
npm run dev        # http://localhost:5173
npm run build      # production build to app/dist/
npm run preview    # serve built dist locally
```

### Docker
```bash
docker build -t lironefitoussi/react-app:latest .
docker run -p 8080:80 lironefitoussi/react-app:latest   # http://localhost:8080
docker push lironefitoussi/react-app:latest
```

### Kubernetes (minikube)
```bash
make deploy        # kubectl apply -f k8s/
make status        # pods + service
make logs          # tail pod logs
make delete        # tear down
minikube service react-app --url   # get NodePort URL (~192.168.49.2:30080)
```

## ArgoCD

Install ArgoCD on minikube (once):
```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl apply -f argocd/argocd-app.yaml
```

Access UI:
```bash
kubectl port-forward svc/argocd-server -n argocd 8443:443
# https://localhost:8443   user: admin
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

`argocd/argocd-app.yaml` defines an `Application` CR that watches `k8s/` on `main` branch. Auto-sync + selfHeal: any `git push` to `k8s/` triggers reconciliation.

**GitOps flow:** push image + update `k8s/deployment.yaml` tag → ArgoCD detects diff → syncs cluster.

## Architecture

Multi-stage Docker build: Node 20 builds Vite React app → nginx:alpine serves static dist.

**Deploy pipeline:** edit `app/src/` → `make build` → `make push` → `make deploy`

**K8s setup:** 2-replica Deployment + NodePort Service (port 30080). `imagePullPolicy: IfNotPresent` means minikube uses local image; switch to `Always` for production pulls from Docker Hub.

Image name: `lironefitoussi/react-app:latest` — defined in [Makefile](Makefile) and [k8s/deployment.yaml](k8s/deployment.yaml).

No test framework configured.
