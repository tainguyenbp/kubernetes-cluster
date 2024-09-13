# This Repository contains the yaml files used for creation of ScyllaDB cluster on GKE using Helm Charts.
```
eksctl create cluster -f cluster-config.yaml

kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.15.3/cert-manager.crds.yaml

helm upgrade --install cert-manager jetstack/cert-manager \
 --namespace cert-manager \
 --create-namespace \
 --version v1.15.3 \
 --set installCRDs=true

kubectl apply -f ./nodeconfig-alpha.yaml

kubectl apply -f ./local-volume-provisioner/local-csi-driver/

helm upgrade --install scylla-operator scylla/scylla-operator \
 --create-namespace --namespace scylla-operator \
 --values ./values.scylla-operator.yaml

helm upgrade --install scylla-manager scylla/scylla-manager \
 --create-namespace --namespace scylla-manager \
 --values ./values.scylla-manager.yaml

helm upgrade --install scylla scylla/scylla \
 --create-namespace --namespace scylla \
 --values ./values.scylla.yaml

kubectl get scyllacluster/scylla service/scylladb-cluster-client -n scylla

kubectl get service/scylladb-cluster-client -o='jsonpath={.spec.clusterIP}' -n scylla

kubectl patch service/scylladb-cluster-client -n scylla -p '{"metadata": {"annotations": {"service.beta.kubernetes.io/aws-load-balancer-scheme": "internal", "service.beta.kubernetes.io/aws-load-balancer-backend-protocol": "tcp", "service.beta.kubernetes.io/aws-load-balancer-internal": "true"}}, "spec": {"type": "LoadBalancer"}}'

kubectl wait --for=jsonpath='{.status.loadBalancer.ingress}' service/scylladb-cluster-client

kubectl get service/scylladb-cluster-client -o='jsonpath={.status.loadBalancer.ingress[0].hostname}'


CREATE KEYSPACE tainn_sre WITH replication = {
  'class': 'SimpleStrategy',
  'replication_factor': 1
};

USE t2jnndb;


CREATE TABLE users (
  user_id UUID PRIMARY KEY,
  first_name TEXT,
  last_name TEXT,
  email TEXT
);

INSERT INTO users (user_id, first_name, last_name, email)
VALUES (uuid(), 'tai', 'nguyen', 'nguyenngoctaibp@gmail.com');

SELECT * FROM users;

```
