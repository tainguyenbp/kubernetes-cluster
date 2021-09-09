# Install helm unitest
helm plugin install https://github.com/quintush/helm-unittest

git clone https://github.com/kremers/charts-vmware-exporter.git

helm install --set name=default default ./charts-vmware-exporter/
