#!/bin/bash

echo "[TASK 1] Mise a jour /etc/hosts file"
cat >>/etc/hosts<<EOF
172.42.42.100 master.drlab1 kmaster
172.42.42.101 worker1.drlab1 kworker1
172.42.42.102 worker2.drlab1 kworker2
172.42.42.103 worker3.drlab1 kworker3
EOF

echo "[TASK 2] Installation du runtime docker"
sudo yum install -y -q yum-utils device-mapper-persistent-data lvm2 > /dev/null 2>&1
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo > /dev/null 2>&1
sudo yum install -y -q docker-ce >/dev/null 2>&1

echo "[TASK 3] Activation et démarrage du service docker"
systemctl enable docker >/dev/null 2>&1
systemctl start docker 

echo "[TASK 4] Désactivation de SELinux"
setenforce 0
sed -i --follow-symlinks 's/^SELINUX-enforcing/SELINUX-disabled/' /etc/sysconfig/selinux

echo "[TASK 5] Arret et desactivation du service firewalld"
systemctl disable firewalld >/dev/null 2>&1
systemctl stop firewalld

echo "[TASK 6] Quelques paramètres sysctl"
cat >>/etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system >/dev/null 2>&1

echo "[TASK 7] Desactivation et arret du SWAP"
sed -i '/swap/d' /etc/fstab
swapoff -a

echo "[TASK 8] Ajout du repo yum pour kubernetes"
cat >>/etc/yum.repos.d/kubernetes.repo<<EOF
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF

echo "[TASK 9] Installation de Kubernetes (kubeadm, kubelet and kubectl)"
sudo yum install -y -q kubeadm kubelet kubectl > /dev/null 2>&1

echo "[TASK 10] Activation et demarrage du service kubelet"
systemctl enable kubelet > /dev/null 2>&1
systemctl start kubelet > /dev/null 2>&1


echo "[TASK 11] Activation de l'authentification du ssh password"
sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
systemctl reload sshd

echo "[TASK 12] Mot de passe du root"
echo "root" | passwd --stdin root > /dev/null 2>&1














