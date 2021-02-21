# Instalar jenkins (https://www.jenkins.io/doc/book/installing/kubernetes/)
kubectl apply -f jenkins-pvc.yml -f jenkins-deployment.yaml -f jenkins-service.yaml -n devops