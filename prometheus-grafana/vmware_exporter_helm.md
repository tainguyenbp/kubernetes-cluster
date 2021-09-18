# Install helm unitest
```
helm plugin install https://github.com/quintush/helm-unittest

git clone https://github.com/kremers/charts-vmware-exporter.git

helm install --set name=default default ./charts-vmware-exporter/ -n monitoring

helm install --set name=default default ./charts-vmware-exporter/ -n monitoring

helm install vmware-exporter ./vmware-exporter-2.2.0.tgz -n monitoring

helm uninstall vmware-exporter -n monitoring

helm uninstall default -n monitoring

helm uninstall --set name=default default ./charts-vmware-exporter/ -n monitoring

By chart reference: helm install mymaria example/mariadb
By path to a packaged chart: helm install mynginx ./nginx-1.2.3.tgz
By path to an unpacked chart directory: helm install mynginx ./nginx
By absolute URL: helm install mynginx https://example.com/charts/nginx-1.2.3.tgz
By chart reference and repo url: helm install --repo https://example.com/charts/ mynginx nginx
```
