![alt text](image-1.png)
![alt text](image-2.png)
![alt text](image-3.png)
# go to this url
```bash
https://github.com/oliver006/redis_exporter
```
![alt text](image-4.png)
![alt text](image-5.png)
# here all helm-charts exporter
```bash
https://github.com/prometheus-community/helm-charts
```
# go to charts and search for redis
![alt text](image-6.png)
# u can see on prometheus 
![alt text](image-7.png)
# alert
![alt text](image-8.png)
# or too many connection at once
# let's create redis-rules
#######
# we can go on => 
```bash
awesome-prometheus-alerts.grep.to
```
![alt text](image-9.png)
![alt text](image-10.png)
![alt text](image-11.png)
![alt text](image-13.png)
![alt text](image-14.png) 
# rq: when install prometheus stack we get some alet 
![alt text](image-15.png)
![alt text](image-16.png)
![alt text](image-17.png)
![alt text](image-18.png)
# u can go to alert k8s => 
```bash
https://github.com/kubernetes-monitoring/kubernetes-mixin/blob/master/runbook.md#alert-name-alertmanagerfailedreload
```
# now we can create a new alert rules
![alt text](image-19.png) 
# in alert-rules
# to prometheus consider that rule 
![alt text](image-20.png)
# this file have all rules
![alt text](image-21.png)
![alt text](image-22.png)
![alt text](image-23.png)
![alt text](image-25.png)
# => we defined apiVersion in alert-rules we go to docs 
```bash
https://docs.openshift.com/container-platform/4.14/rest_api/monitoring_apis/prometheus-monitoring-coreos-com-v1.html
```
# => send alert 
![alt text](image-27.png)
![alt text](image-28.png)
# => to go throught alertmanger
```bash
kubectl port-forward svc/monitoring-kube-prometheus-alertmanager -n monitoring 9093:9093 &
```
![alt text](image-29.png)
![alt text](image-30.png)
![alt text](image-31.png)
![alt text](image-32.png)
![alt text](image-33.png)
# to show the alert manager
```bash
kubectl get secret alertmanager-monitoring-kube-prometheus-alertmanager-generated -n monitoring -o yaml | less
```
# to decode secret
```bash
echo ................ | base64 -D | less 
```
 ![alt text](image-34.png)
# we see configuration of notify email in alert-manager-configuration.yaml
![alt text](image-35.png)
![alt text](image-37.png)
# if is match