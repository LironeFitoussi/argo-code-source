# React App — Docker + Kubernetes

Vite React app, containerized with Docker, deployed on Kubernetes (minikube).

## Prerequisites

- [Node.js](https://nodejs.org/) 20+
- [Docker](https://www.docker.com/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [minikube](https://minikube.sigs.k8s.io/docs/start/)
- Docker Hub account

## Project Structure

```
.
├── app/                  # Vite React app
│   ├── src/
│   │   ├── App.jsx
│   │   └── main.jsx
│   ├── index.html
│   ├── vite.config.js
│   └── package.json
├── k8s/
│   ├── deployment.yaml   # 2 replicas, nginx
│   └── service.yaml      # NodePort on :30080
├── Dockerfile            # Multi-stage build
├── .dockerignore
└── Makefile
```

## Local Dev (no Docker)

```bash
cd app
npm install
npm run dev
# http://localhost:5173
```

## Docker

### Build

```bash
docker build -t lironefitoussi/react-app:latest .
```

### Push to Docker Hub

```bash
docker login -u lironefitoussi
docker push lironefitoussi/react-app:latest
```

### Run locally

```bash
docker run -p 8080:80 lironefitoussi/react-app:latest
# http://localhost:8080
```

## Kubernetes (minikube)

### Start minikube

```bash
minikube start
```

### Deploy

```bash
kubectl apply -f k8s/
```

### Check status

```bash
kubectl get pods,svc -l app=react-app
```

### Get URL

```bash
minikube service react-app --url
# http://192.168.49.2:30080
```

### Tear down

```bash
kubectl delete -f k8s/
```

## Makefile shortcuts

| Command        | Action                          |
|----------------|---------------------------------|
| `make build`   | Build Docker image              |
| `make push`    | Push image to Docker Hub        |
| `make deploy`  | Apply K8s manifests             |
| `make delete`  | Remove K8s deployment + service |
| `make status`  | Show pods and service           |
| `make logs`    | Tail pod logs                   |

## Notes

- `imagePullPolicy: IfNotPresent` — minikube uses local image if present, skips pull.
  Change to `Always` after pushing to Docker Hub for production-style pull.
- NodePort `30080` fixed for consistent local access.
- Image: `lironefitoussi/react-app:latest`
