#!/bin/bash

# The cfssl and cfssljson command line utilities will be used to provision
# a PKI Infrastructure and generate TLS certificates.
wget -q --show-progress --https-only --timestamping \
  https://pkg.cfssl.org/R1.2/cfssl_linux-amd64 \
  https://pkg.cfssl.org/R1.2/cfssljson_linux-amd64
chmod +x cfssl_linux-amd64 cfssljson_linux-amd64
sudo mv cfssl_linux-amd64 /usr/local/bin/cfssl
sudo mv cfssljson_linux-amd64 /usr/local/bin/cfssljson
cfssl version

# The kubectl command line utility is used to interact with the Kubernetes API Server
wget https://storage.googleapis.com/kubernetes-release/release/v1.12.0/bin/linux/amd64/kubectl
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
kubectl version --client

echo ""
echo ""
echo ""

# Create the kubernetes-the-hard-way custom VPC network:
gcloud compute networks create kubernetes-the-hard-way --subnet-mode custom

echo ""
echo ""
echo ""

# Create the kubernetes subnet in the kubernetes-the-hard-way VPC network:
gcloud compute networks subnets create kubernetes \
  --network kubernetes-the-hard-way \
  --range 10.240.0.0/24

echo ""
echo ""
echo ""

# Create a firewall rule that allows internal communication across all protocols:
gcloud compute firewall-rules create kubernetes-the-hard-way-allow-internal \
  --allow tcp,udp,icmp \
  --network kubernetes-the-hard-way \
  --source-ranges 10.240.0.0/24,10.200.0.0/16

echo ""
echo ""
echo ""

# Create a firewall rule that allows external SSH, ICMP, and HTTPS:
gcloud compute firewall-rules create kubernetes-the-hard-way-allow-external \
  --allow tcp:22,tcp:6443,icmp \
  --network kubernetes-the-hard-way \
  --source-ranges 0.0.0.0/0

echo ""
echo ""
echo ""

# Allocate a static IP address that will be attached to the external
# load balancer fronting the Kubernetes API Servers:
gcloud compute addresses create kubernetes-the-hard-way \
  --region $(gcloud config get-value compute/region)

echo ""
echo ""
echo ""

# Create three compute instances which will host the Kubernetes control plane:
for i in 0 1 2
do
  gcloud compute instances create controller-${i} \
    --async \
    --boot-disk-size 200GB \
    --can-ip-forward \
    --image-family ubuntu-1804-lts \
    --image-project ubuntu-os-cloud \
    --machine-type n1-standard-1 \
    --private-network-ip 10.240.0.1${i} \
    --scopes compute-rw,storage-ro,service-management,service-control,logging-write,monitoring \
    --subnet kubernetes \
    --tags kubernetes-the-hard-way,controller
done

echo ""
echo ""
echo ""

# Create three compute instances which will host the Kubernetes worker nodes:
for i in 0 1 2
do
  gcloud compute instances create worker-${i} \
    --async \
    --boot-disk-size 200GB \
    --can-ip-forward \
    --image-family ubuntu-1804-lts \
    --image-project ubuntu-os-cloud \
    --machine-type n1-standard-1 \
    --metadata pod-cidr=10.200.${i}.0/24 \
    --private-network-ip 10.240.0.2${i} \
    --scopes compute-rw,storage-ro,service-management,service-control,logging-write,monitoring \
    --subnet kubernetes \
    --tags kubernetes-the-hard-way,worker
done

echo ""
echo ""
echo ""

# List the compute instances:
sleep 30
gcloud compute instances list


echo ""
echo ""
echo ""


mkdir certificates
cd certificates

# Certificate Authority
cat > ca-config.json <<EOF
{
  "signing": {
    "default": {
      "expiry": "8760h"
    },
    "profiles": {
      "kubernetes": {
        "usages": ["signing", "key encipherment", "server auth", "client auth"],
        "expiry": "8760h"
      }
    }
  }
}
EOF

cat > ca-csr.json <<EOF
{
  "CN": "Kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Portland",
      "O": "Kubernetes",
      "OU": "CA",
      "ST": "Oregon"
    }
  ]
}
EOF

cfssl gencert -initca ca-csr.json | cfssljson -bare ca
# ca-key.pem
# ca.pem

echo ""
echo ""
echo ""

# Client and Server Certificates
## The Admin Client Certificate
cat > admin-csr.json <<EOF
{
  "CN": "admin",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Portland",
      "O": "system:masters",
      "OU": "Kubernetes The Hard Way",
      "ST": "Oregon"
    }
  ]
}
EOF

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  admin-csr.json | cfssljson -bare admin
# admin-key.pem
# admin.pem

echo ""
echo ""
echo ""

## The Kubelet Client Certificates
for instance in worker-0 worker-1 worker-2
do
cat > ${instance}-csr.json <<EOF
{
  "CN": "system:node:${instance}",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Portland",
      "O": "system:nodes",
      "OU": "Kubernetes The Hard Way",
      "ST": "Oregon"
    }
  ]
}
EOF

EXTERNAL_IP=$(gcloud compute instances describe ${instance} \
  --format 'value(networkInterfaces[0].accessConfigs[0].natIP)')

INTERNAL_IP=$(gcloud compute instances describe ${instance} \
  --format 'value(networkInterfaces[0].networkIP)')

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -hostname=${instance},${EXTERNAL_IP},${INTERNAL_IP} \
  -profile=kubernetes \
  ${instance}-csr.json | cfssljson -bare ${instance}
done
# worker-0-key.pem
# worker-0.pem
# worker-1-key.pem
# worker-1.pem
# worker-2-key.pem
# worker-2.pem

echo ""
echo ""
echo ""

## The Controller Manager Client Certificate
cat > kube-controller-manager-csr.json <<EOF
{
  "CN": "system:kube-controller-manager",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Portland",
      "O": "system:kube-controller-manager",
      "OU": "Kubernetes The Hard Way",
      "ST": "Oregon"
    }
  ]
}
EOF

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  kube-controller-manager-csr.json | cfssljson -bare kube-controller-manager
# kube-controller-manager-key.pem
# kube-controller-manager.pem

echo ""
echo ""
echo ""

## The Kube Proxy Client Certificate
cat > kube-proxy-csr.json <<EOF
{
  "CN": "system:kube-proxy",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Portland",
      "O": "system:node-proxier",
      "OU": "Kubernetes The Hard Way",
      "ST": "Oregon"
    }
  ]
}
EOF

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  kube-proxy-csr.json | cfssljson -bare kube-proxy
# kube-proxy-key.pem
# kube-proxy.pem

echo ""
echo ""
echo ""

## The Scheduler Client Certificate
cat > kube-scheduler-csr.json <<EOF
{
  "CN": "system:kube-scheduler",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Portland",
      "O": "system:kube-scheduler",
      "OU": "Kubernetes The Hard Way",
      "ST": "Oregon"
    }
  ]
}
EOF

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  kube-scheduler-csr.json | cfssljson -bare kube-scheduler
# kube-scheduler-key.pem
# kube-scheduler.pem

echo ""
echo ""
echo ""

## The Kubernetes API Server Certificate
KUBERNETES_PUBLIC_ADDRESS=$(gcloud compute addresses describe kubernetes-the-hard-way \
  --region $(gcloud config get-value compute/region) \
  --format 'value(address)')

cat > kubernetes-csr.json <<EOF
{
  "CN": "kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Portland",
      "O": "Kubernetes",
      "OU": "Kubernetes The Hard Way",
      "ST": "Oregon"
    }
  ]
}
EOF

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -hostname=10.32.0.1,10.240.0.10,10.240.0.11,10.240.0.12,${KUBERNETES_PUBLIC_ADDRESS},127.0.0.1,kubernetes.default \
  -profile=kubernetes \
  kubernetes-csr.json | cfssljson -bare kubernetes
# kubernetes-key.pem
# kubernetes.pem

echo ""
echo ""
echo ""

## The Service Account Key Pair
cat > service-account-csr.json <<EOF
{
  "CN": "service-accounts",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Portland",
      "O": "Kubernetes",
      "OU": "Kubernetes The Hard Way",
      "ST": "Oregon"
    }
  ]
}
EOF

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -profile=kubernetes \
  service-account-csr.json | cfssljson -bare service-account
# service-account-key.pem
# service-account.pem

echo ""
echo ""
echo ""

cat > ../inventory <<EOF
all:
  hosts:
    controller-[0:2]:
    worker-[0:2]:
  children:
    controllers:
      hosts:
        controller-0:
          ansible_host: `echo $(gcloud compute instances describe controller-0 --format 'value(networkInterfaces[0].accessConfigs[0].natIP)')`
          int_ip: 10.240.0.10
          ext_ip: `echo $(gcloud compute instances describe controller-0 --format 'value(networkInterfaces[0].accessConfigs[0].natIP)')`
          ansible_python_interpreter: "/usr/bin/python3"
        controller-1:
          ansible_host: `echo $(gcloud compute instances describe controller-1 --format 'value(networkInterfaces[0].accessConfigs[0].natIP)')`
          int_ip: 10.240.0.11
          ext_ip: `echo $(gcloud compute instances describe controller-1 --format 'value(networkInterfaces[0].accessConfigs[0].natIP)')`
          ansible_python_interpreter: "/usr/bin/python3"
        controller-2:
          ansible_host: `echo $(gcloud compute instances describe controller-2 --format 'value(networkInterfaces[0].accessConfigs[0].natIP)')`
          int_ip: 10.240.0.12
          ext_ip: `echo $(gcloud compute instances describe controller-2 --format 'value(networkInterfaces[0].accessConfigs[0].natIP)')`
          ansible_python_interpreter: "/usr/bin/python3"
    workers:
      hosts:
        worker-0:
          ansible_host: `echo $(gcloud compute instances describe worker-0 --format 'value(networkInterfaces[0].accessConfigs[0].natIP)')`
          int_ip: 10.240.0.20
          ext_ip: `echo $(gcloud compute instances describe worker-0 --format 'value(networkInterfaces[0].accessConfigs[0].natIP)')`
          ansible_python_interpreter: "/usr/bin/python3"
          pod_cidr: "10.200.0.0/24"
        worker-1:
          ansible_host: `echo $(gcloud compute instances describe worker-1 --format 'value(networkInterfaces[0].accessConfigs[0].natIP)')`
          int_ip: 10.240.0.21
          ext_ip: `echo $(gcloud compute instances describe worker-1 --format 'value(networkInterfaces[0].accessConfigs[0].natIP)')`
          ansible_python_interpreter: "/usr/bin/python3"
          pod_cidr: "10.200.1.0/24"
        worker-2:
          ansible_host: `echo $(gcloud compute instances describe worker-2 --format 'value(networkInterfaces[0].accessConfigs[0].natIP)')`
          int_ip: 10.240.0.22
          ext_ip: `echo $(gcloud compute instances describe worker-2 --format 'value(networkInterfaces[0].accessConfigs[0].natIP)')`
          ansible_python_interpreter: "/usr/bin/python3"
          pod_cidr: "10.200.2.0/24"
EOF

# Distribute the Client and Server Certificates
# for instance in worker-0 worker-1 worker-2
# do
#   gcloud compute scp -q ca.pem ${instance}-key.pem ${instance}.pem ${instance}:~/
# done
# for instance in controller-0 controller-1 controller-2
# do
#   gcloud compute scp -q ca.pem ca-key.pem kubernetes-key.pem kubernetes.pem \
#     service-account-key.pem service-account.pem ${instance}:~/
# done

mkdir ../configs


# KUBERNETES_PUBLIC_ADDRESS=$(gcloud compute addresses describe kubernetes-the-hard-way \
#   --region $(gcloud config get-value compute/region) \
#   --format 'value(address)')

# The kubelet Kubernetes Configuration File
for instance in worker-0 worker-1 worker-2; do
  kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=ca.pem \
    --embed-certs=true \
    --server=https://${KUBERNETES_PUBLIC_ADDRESS}:6443 \
    --kubeconfig=${instance}.kubeconfig
  kubectl config set-credentials system:node:${instance} \
    --client-certificate=${instance}.pem \
    --client-key=${instance}-key.pem \
    --embed-certs=true \
    --kubeconfig=${instance}.kubeconfig
  kubectl config set-context default \
    --cluster=kubernetes-the-hard-way \
    --user=system:node:${instance} \
    --kubeconfig=${instance}.kubeconfig
  kubectl config use-context default --kubeconfig=${instance}.kubeconfig

echo ""
echo ""
echo ""

done
# worker-0.kubeconfig
# worker-1.kubeconfig
# worker-2.kubeconfig
mv worker-0.kubeconfig worker-1.kubeconfig worker-2.kubeconfig ../configs/


# The kube-proxy Kubernetes Configuration File
kubectl config set-cluster kubernetes-the-hard-way \
    --certificate-authority=ca.pem \
    --embed-certs=true \
    --server=https://${KUBERNETES_PUBLIC_ADDRESS}:6443 \
    --kubeconfig=kube-proxy.kubeconfig
kubectl config set-credentials system:kube-proxy \
  --client-certificate=kube-proxy.pem \
  --client-key=kube-proxy-key.pem \
  --embed-certs=true \
  --kubeconfig=kube-proxy.kubeconfig
kubectl config set-context default \
  --cluster=kubernetes-the-hard-way \
  --user=system:kube-proxy \
  --kubeconfig=kube-proxy.kubeconfig
kubectl config use-context default --kubeconfig=kube-proxy.kubeconfig

echo ""
echo ""
echo ""

# kube-proxy.kubeconfig
mv kube-proxy.kubeconfig ../configs/

# The kube-controller-manager Kubernetes Configuration File
kubectl config set-cluster kubernetes-the-hard-way \
  --certificate-authority=ca.pem \
  --embed-certs=true \
  --server=https://127.0.0.1:6443 \
  --kubeconfig=kube-controller-manager.kubeconfig
kubectl config set-credentials system:kube-controller-manager \
  --client-certificate=kube-controller-manager.pem \
  --client-key=kube-controller-manager-key.pem \
  --embed-certs=true \
  --kubeconfig=kube-controller-manager.kubeconfig
kubectl config set-context default \
  --cluster=kubernetes-the-hard-way \
  --user=system:kube-controller-manager \
  --kubeconfig=kube-controller-manager.kubeconfig
kubectl config use-context default --kubeconfig=kube-controller-manager.kubeconfig

echo ""
echo ""
echo ""

# kube-controller-manager.kubeconfig
mv kube-controller-manager.kubeconfig ../configs/

# The kube-scheduler Kubernetes Configuration File
kubectl config set-cluster kubernetes-the-hard-way \
  --certificate-authority=ca.pem \
  --embed-certs=true \
  --server=https://127.0.0.1:6443 \
  --kubeconfig=kube-scheduler.kubeconfig
kubectl config set-credentials system:kube-scheduler \
  --client-certificate=kube-scheduler.pem \
  --client-key=kube-scheduler-key.pem \
  --embed-certs=true \
  --kubeconfig=kube-scheduler.kubeconfig
kubectl config set-context default \
  --cluster=kubernetes-the-hard-way \
  --user=system:kube-scheduler \
  --kubeconfig=kube-scheduler.kubeconfig
kubectl config use-context default --kubeconfig=kube-scheduler.kubeconfig

echo ""
echo ""
echo ""

# kube-scheduler.kubeconfig
mv kube-scheduler.kubeconfig ../configs/

# The admin Kubernetes Configuration File
kubectl config set-cluster kubernetes-the-hard-way \
  --certificate-authority=ca.pem \
  --embed-certs=true \
  --server=https://127.0.0.1:6443 \
  --kubeconfig=admin.kubeconfig
kubectl config set-credentials admin \
  --client-certificate=admin.pem \
  --client-key=admin-key.pem \
  --embed-certs=true \
  --kubeconfig=admin.kubeconfig
kubectl config set-context default \
  --cluster=kubernetes-the-hard-way \
  --user=admin \
  --kubeconfig=admin.kubeconfig
kubectl config use-context default --kubeconfig=admin.kubeconfig

echo ""
echo ""
echo ""

# admin.kubeconfig
mv admin.kubeconfig ../configs

# Distribute the Kubernetes Configuration Files
# for instance in worker-0 worker-1 worker-2; do
#   gcloud compute scp ${instance}.kubeconfig kube-proxy.kubeconfig ${instance}:~/
# done
# for instance in controller-0 controller-1 controller-2; do
#   gcloud compute scp admin.kubeconfig kube-controller-manager.kubeconfig kube-scheduler.kubeconfig ${instance}:~/
# done

# The Encryption Key
ENCRYPTION_KEY=$(head -c 32 /dev/urandom | base64)
cat > encryption-config.yaml <<EOF
kind: EncryptionConfig
apiVersion: v1
resources:
  - resources:
      - secrets
    providers:
      - aescbc:
          keys:
            - name: key1
              secret: ${ENCRYPTION_KEY}
      - identity: {}
EOF
mv encryption-config.yaml ../configs
# for instance in controller-0 controller-1 controller-2; do
#   gcloud compute scp encryption-config.yaml ${instance}:~/
# done



# Create the external load balancer network resources:
gcloud compute http-health-checks create kubernetes \
    --description "Kubernetes Health Check" \
    --host "kubernetes.default.svc.cluster.local" \
    --request-path "/healthz"

echo ""
echo ""
echo ""

gcloud compute firewall-rules create kubernetes-the-hard-way-allow-health-check \
  --network kubernetes-the-hard-way \
  --source-ranges 209.85.152.0/22,209.85.204.0/22,35.191.0.0/16 \
  --allow tcp

echo ""
echo ""
echo ""

gcloud compute target-pools create kubernetes-target-pool \
  --http-health-check kubernetes

echo ""
echo ""
echo ""

gcloud compute target-pools add-instances kubernetes-target-pool \
  --instances controller-0,controller-1,controller-2

echo ""
echo ""
echo ""

gcloud compute forwarding-rules create kubernetes-forwarding-rule \
  --address ${KUBERNETES_PUBLIC_ADDRESS} \
  --ports 6443 \
  --region $(gcloud config get-value compute/region) \
  --target-pool kubernetes-target-pool

echo ""
echo ""
echo ""

# The Admin Kubernetes Configuration File
kubectl config set-cluster kubernetes-the-hard-way \
  --certificate-authority=ca.pem \
  --embed-certs=true \
  --server=https://${KUBERNETES_PUBLIC_ADDRESS}:6443
kubectl config set-credentials admin \
  --client-certificate=admin.pem \
  --client-key=admin-key.pem
kubectl config set-context kubernetes-the-hard-way \
  --cluster=kubernetes-the-hard-way \
  --user=admin
kubectl config use-context kubernetes-the-hard-way

echo ""
echo ""
echo ""

# kubectl get componentstatuses
# kubectl get nodes

# Routes
for i in 0 1 2; do
  gcloud compute routes create kubernetes-route-10-200-${i}-0-24 \
    --network kubernetes-the-hard-way \
    --next-hop-address 10.240.0.2${i} \
    --destination-range 10.200.${i}.0/24
done

echo ""
echo ""
echo ""

cd ../
ansible-playbook deploy-worker.yml
ansible-playbook deploy-controller.yml

# Deploying the DNS Cluster Add-on
kubectl apply -f https://storage.googleapis.com/kubernetes-the-hard-way/coredns.yaml
