# mynginx_images (from nginx:1.25.2-alpine-slim official image) 

My Nginx Docker images for education and tests (from nginx:1.25.2-alpine-slim official image) 

## Save, load and run Docker image, example (v4): 

Save image: 

```
docker pull kodmandvl/mynginx:latest
docker save -o ./mynginx_v4.tar kodmandvl/mynginx:v4
gzip -c ./mynginx_v4.tar > ./mynginx_v4.tar.gz
rm ./mynginx_v4.tar
```

Load image: 

```
docker rmi kodmandvl/mynginx:v4
docker load ./mynginx_v4.tar.gz
docker images | grep mynginx
```

Check loaded image: 

```
docker run -d -p 8080:8080 --name myngnx -h myngnx kodmandvl/mynginx:v4
curl 127.0.0.1:8080
curl 127.0.0.1:8080/kitty.html
curl 127.0.0.1:8080/basic_status
docker rm -f myngnx 
```

## Run Docker image in Kubernetes, example with MiniKube (v4): 

This is simple example. We run just one pod and service (see also mynginx_image_simple_example_on_minikube.sh script): 

```
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
```

## sha256sum: 

```
sha256sum ./mynginx_v1.tar.gz > ./mynginx_v1.tar.gz.sha256sum
sha256sum ./mynginx_v2.tar.gz > ./mynginx_v2.tar.gz.sha256sum
sha256sum ./mynginx_v3.tar.gz > ./mynginx_v3.tar.gz.sha256sum
sha256sum ./mynginx_v4.tar.gz > ./mynginx_v4.tar.gz.sha256sum
```
