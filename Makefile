IMAGE_BASE = lironefitoussi/react-app
IMAGE = $(IMAGE_BASE):latest
SHA = $(shell git rev-parse --short HEAD)

build:
	docker build -t $(IMAGE) .

push:
	docker push $(IMAGE)

release:
	docker build -t $(IMAGE_BASE):$(SHA) -t $(IMAGE) .
	docker push $(IMAGE_BASE):$(SHA)
	docker push $(IMAGE)
	sed -i "s|image: $(IMAGE_BASE):.*|image: $(IMAGE_BASE):$(SHA)|" k8s/deployment.yaml
	git add k8s/deployment.yaml
	git commit -m "ci: deploy image $(SHA)"
	git push

deploy:
	kubectl apply -f k8s/

delete:
	kubectl delete -f k8s/

logs:
	kubectl logs -l app=react-app --tail=50

status:
	kubectl get pods,svc -l app=react-app

argocd-install:
	kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
	kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

argocd-app:
	kubectl apply -f argocd/argocd-app.yaml

argocd-password:
	kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo

argocd-ui:
	kubectl port-forward svc/argocd-server -n argocd 8443:443
