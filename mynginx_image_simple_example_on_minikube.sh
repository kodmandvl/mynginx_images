#!/bin/sh
# Delete namespace (if needed):
# kubectl delete ns myns
# Create namespace:
kubectl create ns myns
# Run My Nginx:
kubectl run myngnx --image=docker.io/kodmandvl/mynginx:v4 --port=8080 -n myns
echo waiting...
sleep 14
kubectl get po -n myns
nohup kubectl port-forward myngnx 8080:8080 -n myns &
echo waiting...
sleep 2
echo '===================================================================================================='
curl 127.0.0.1:8080
echo '===================================================================================================='
curl 127.0.0.1:8080/basic_status
echo '===================================================================================================='
echo waiting...
sleep 2
# Create service for My Nginx:
kubectl expose -n myns pod/myngnx --port=8080 --type=NodePort --overrides '{ "spec":{"ports": 
[{"port":8080,"protocol":"TCP","targetPort":8080,"nodePort":30080}]}}'
echo '===================================================================================================='
kubectl get -n myns svc -o yaml
echo '===================================================================================================='
kubectl get -n myns svc -o wide
echo waiting...
sleep 2
echo '===================================================================================================='
echo "curl `minikube ip`:30080 ; exit" | minikube ssh
echo '===================================================================================================='
echo "curl `minikube ip`:30080/basic_status ; exit" | minikube ssh
echo '===================================================================================================='
echo
echo "DONE."