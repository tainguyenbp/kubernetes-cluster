kubeadm token create --print-join-command --certificate-key `kubeadm init phase upload-certs --upload-certs | sed -n '3 p'`
