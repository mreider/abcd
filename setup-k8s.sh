colima delete
colima start --kubernetes --arch aarch64 --runtime containerd
read -p "Enter your Dynatrace token: " DT_TOKEN
# Containerize using Docker
echo "Building"
nerdctl image prune --all --force
nerdctl build -t servicea:v1.0 ./A
nerdctl build -t serviceb:v1.0 ./B
nerdctl build -t servicec:v1.0 ./C
nerdctl build -t serviced:v1.0 ./D
nerdctl -n default save -o servicea-v1.0.tar servicea:v1.0
nerdctl -n default save -o serviceb-v1.0.tar serviceb:v1.0
nerdctl -n default save -o servicec-v1.0.tar servicec:v1.0
nerdctl -n default save -o serviced-v1.0.tar serviced:v1.0
nerdctl -n k8s.io load -i servicea-v1.0.tar
nerdctl -n k8s.io load -i serviceb-v1.0.tar
nerdctl -n k8s.io load -i servicec-v1.0.tar
nerdctl -n k8s.io load -i serviced-v1.0.tar
# Deploy
echo "Deploying"
kubectl create namespace abcd
kubectl delete secret dynatrace-secret -n abcd
kubectl create secret generic dynatrace-secret -n abcd --from-literal=DT_API_TOKEN="$DT_TOKEN"
kubectl  apply -f A/servicea-deployment.yaml
kubectl  apply -f B/serviceb-deployment.yaml
kubectl  apply -f C/servicec-deployment.yaml
kubectl  apply -f D/serviced-deployment.yaml
kubectl  set env deployment/servicea -n abcd UPDATE_TIME="$(date)"
kubectl  set env deployment/serviceb -n abcd UPDATE_TIME="$(date)"
kubectl  set env deployment/servicec -n abcd UPDATE_TIME="$(date)"
kubectl  set env deployment/serviced -n abcd UPDATE_TIME="$(date)"
rm -f *.tar
echo "Setup complete."
