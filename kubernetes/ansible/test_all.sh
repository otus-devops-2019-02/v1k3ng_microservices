#!/bin/bash
echo ""
gcloud compute addresses list --filter="name=('kubernetes-the-hard-way')"
echo ""
gcloud compute ssh controller-0 --command "sudo ETCDCTL_API=3 etcdctl member list \
  --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/etcd/ca.pem \
  --cert=/etc/etcd/kubernetes.pem \
  --key=/etc/etcd/kubernetes-key.pem"
echo ""
KUBERNETES_PUBLIC_ADDRESS=$(gcloud compute addresses describe kubernetes-the-hard-way \
--region $(gcloud config get-value compute/region) \
--format 'value(address)')
curl --cacert certificates/ca.pem https://${KUBERNETES_PUBLIC_ADDRESS}:6443/version
echo ""
gcloud compute ssh controller-0 \
--command "kubectl get nodes --kubeconfig admin.kubeconfig"
echo ""
kubectl get componentstatuses
echo ""
kubectl get nodes
echo ""
kubectl run busybox --image=busybox:1.28 --command -- sleep 3600
kubectl get pods -l run=busybox
POD_NAME=$(kubectl get pods -l run=busybox -o jsonpath="{.items[0].metadata.name}")
kubectl exec -ti $POD_NAME -- nslookup kubernetes
