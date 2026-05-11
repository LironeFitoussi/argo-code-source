IMAGE = lironefitoussi/react-app:latest

build:
	docker build -t $(IMAGE) .

push:
	docker push $(IMAGE)

deploy:
	kubectl apply -f k8s/

delete:
	kubectl delete -f k8s/

logs:
	kubectl logs -l app=react-app --tail=50

status:
	kubectl get pods,svc -l app=react-app
