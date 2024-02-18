![Alt text](image.png)
![Alt text](image-1.png)
# app use externel config file or app communicate with 10 externel services that communicate wich all secure ; app needclientt certificat to communicate with internel secure service 
![Alt text](image-2.png)
![Alt text](image-3.png)
# files can be mond in the container and pod => the application in that container can access it ; demo folder
![Alt text](image-4.png)
![Alt text](image-5.png)
# => this run on minikube 
# aplly mosquitto pod
```bash
kubectl apply -f mosquitto-without-volumes.yaml
```
# enter in the pod configuration
```bash
kubectl get pod 
```
```bash
kubectl exec -it mosquitto-  -- /bin/sh 
```
# do ls
# i sea mosquitto per configure 
# i enter in mosquitto and i do ls 
# i show files exist per default  in image( config data log)
# i go to config and i do ls i sea a mosquitto.conf 
# i gonna delete i use 
```bash
kubectl delete -f mosquitto-without-volumes.yaml
```
![Alt text](image-6.png)
# with configMap
![Alt text](image-7.png)
# let'zs apply thes two 
```bash
kubectl apply -f config-file.yaml
```
```bash
kubectl apply -f secret-file.yaml
```
# check 
```bash
kubectl get secret
```
```bash
kubectl get configmap
```
# now
![Alt text](image-8.png)
# we create mosquitto.yaml
![Alt text](image-9.png)
![Alt text](image-10.png)
# => becauce app running in the container
![Alt text](image-11.png)
![Alt text](image-13.png)
## review
![Alt text](image-12.png)
![Alt text](image-14.png)