## we have same attribut with different value 
![Alt text](image.png)
## the objective of helm chart 
![Alt text](image-1.png)
![Alt text](image-2.png)
![Alt text](image-3.png)
# there are two methode of useing helm chart that depends on your application 
# this methode is 
![Alt text](image-4.png)
![Alt text](image-5.png)
# in my case i would create 1 shared Helm chart that all MS used
![Alt text](image-6.png)
## between the manifest i tape in terminal 
```bash
helm create microservice
```
## basic structure of helm chart
![Alt text](image-7.png)
![Alt text](image-8.png)
 ![Alt text](image-9.png)
 # => 
 ![Alt text](image-10.png)
 ![Alt text](image-11.png) 
 ![Alt text](image-12.png) 
 ![Alt text](image-13.png)
 # 1.write my own template that's why i delete all files in template i put only service and deployement 
 ![Alt text](image-14.png)
 ![Alt text](image-15.png)
 ![Alt text](image-17.png)
 ![Alt text](image-16.png)
 # dynamique var 
 ![Alt text](image-18.png)
  ![Alt text](image-19.png)
# to check chart => valide k8s yaml file
![Alt text](image-20.png)
```bash
helm template -f servicename-service-values.yaml chartname
```
# validate a chart
![Alt text](image-21.png)
# rplce placehoder values in the template   
# from:
# -values ressources
# or 
# change values 
```bash
helm template -f servicename-service-values.yaml --set appReplicas=3 chartname
```
# helm collect the result of those template and send to k8s when execute helm install command
![Alt text](image-22.png)
# to check validite and erreur in your chart of your yaml files
![Alt text](image-23.png)
```bash
helm lint -f servicename-service-values.yaml chartname
```
## to deploy MS with chart 
![Alt text](image-24.png)
```bash
helm instal -f email-service-values.yaml emailservice microservice
```
# to show service chart 
```bash
helm ls
```
# to show pod that 2 repliccas
```bash
kubectl get pod
``` 
![Alt text](image-25.png)
# you can put it in seperated foldder
### you can use 
```bash
helm instal -f values/email-service-values.yaml emailservice microservice
```
![Alt text](image-26.png)
# i create folder charts inside it microserces 
# redis containers i have to create redis-cart
```bash
helm create redis
```
![Alt text](image-27.png)
```bash
helm install --dry-run -f values/redis-values.yaml redisCart charts/redis
```



  