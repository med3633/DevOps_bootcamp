![alt text](image.png)
# we can use pretty dashboard like grafana
![alt text](image-1.png)
# 1st methode
![alt text](image-2.png)
# and execute them in the right order
![alt text](image-3.png)
# 2nd methode using an operator that manager of all Prometheus components
![alt text](image-5.png)
# 3th methode using Helm
![alt text](image-6.png)
# in this repo 
```bash
https://github.com/helm/charts/tree/master/stable/prometheus-operator
```
# we can give a name for charts 
```bash
helm install prometheus stable/prometheus-operator
```
# show all in cluster 
```bash
kubectl get all
```
![alt text](image-4.png)
![alt text](image-7.png)
![alt text](image-8.png)
# => kube-state-metrics keep k8s infrastructure monitoring 
![alt text](image-9.png)
![alt text](image-10.png)
![alt text](image-11.png)
![alt text](image-12.png)
# and pods coming from deployments and StatefulSets
![alt text](image-13.png)
![alt text](image-14.png)
![alt text](image-15.png)
# k8s components like pods , deployement , replicas and statefulSet.
![alt text](image-16.png)
![alt text](image-17.png)
![alt text](image-18.png)
![alt text](image-19.png)
![alt text](image-20.png)
![alt text](image-21.png)
# monted into Prometheus Pod
![alt text](image-22.png)
![alt text](image-23.png)
![alt text](image-24.png)
# => responsible for reloading , when configuration files changes
![alt text](image-25.png)
![alt text](image-26.png)
# for show port of grafana 
```bash
kubectl get pod
```
# if there are multiple container on that pod 
```bash
kubectl logs <pod> -c <container>
```
![alt text](image-27.png)
![alt text](image-29.png)
![alt text](image-28.png)

![alt text](image-30.png)
![alt text](image-31.png)

