#!/bin/bash

echo "[TASK 1] Initialisation du Cluster Kubernetes"
kubeadm init --apiserver-advertise-address=172.42.42.100 --pod-network-cidr=192.168.0.0/16

echo "[TASK 2] Copie du fichier config pour l'admin kubernetes"
mkdir /root/.kube
cp /etc/kubernetes/admin.conf /root/.kube/config

echo "[TASK 3] Deploiement de la solution réseau Calico"
kubectl create -f https://docs.projectcalico.org/v3.11/manifests/calico.yaml

echo "[TASK 4] Generation du token pour joindre le cluster"
kubeadm token create --print-join-command > root/.kube/joincluster.sh
