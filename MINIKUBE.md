# Minikube Setup Guide

## Prerequisites

```bash
# verify tools installed
minikube version
kubectl version --client
docker version
```

---

## 1. Start Minikube

```bash
minikube start --driver=docker
minikube status
```

---

## 2. Deploy the App

```bash
make deploy       # kubectl apply -f k8s/
make status       # verify pods + service are running
```

---

## 3. Install ArgoCD (first time only)

```bash
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# wait for ArgoCD pods to be ready
kubectl wait --for=condition=available deployment/argocd-server -n argocd --timeout=120s

# register the app
kubectl apply -f argocd/argocd-app.yaml
```

---

## 4. Get ArgoCD Admin Password

```bash
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 -d && echo
```

Username: `admin`

---

## Port Forwarding

### React App → http://localhost:8080

```bash
kubectl port-forward svc/react-app 8080:80
```

### ArgoCD UI → https://localhost:8443

```bash
kubectl port-forward svc/argocd-server -n argocd 8443:443
```

> Login: `admin` / password from step 4. Accept the self-signed cert warning.

---

## Useful Commands

```bash
make status                          # pods + service
make logs                            # tail pod logs
make delete                          # tear down app
minikube service react-app --url     # NodePort URL (no port-forward needed)
minikube dashboard                   # Kubernetes dashboard
minikube stop                        # stop cluster
```

---

## GitOps Flow (after setup)

```
push code → GitHub Actions: lint → test → docker build/push → update k8s/deployment.yaml
         → ArgoCD detects manifest diff → auto-syncs cluster → rolling update
```
