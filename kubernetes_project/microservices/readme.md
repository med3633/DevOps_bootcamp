## kubernets emerged as a Plateform for Microservices Application
## from Monolith to Microservices can be developed , deployed and managed independently.
# for exple linkidin => (App1) for user services , (App2) for Messenger service ,(App3) for jobs services and (App4) for blogs service => each business functionality is encapsulated into own Microservice 'MS', Smaller independent application

# less interconnected logic
## how MS communicate => ser-to-serv API calls or through third party message broker 
![Alt text](image.png)
## less code complexisity inside MS
## some messenger broker are redis or rabbitmq

# service Mesh achitecture => one centeral big message broker that handle al communication . Each MS has its own helper application (is a SideCar Container in kubernetes) that handle communication for that specifique MS t another MS
![Alt text](image-1.png)
![Alt text](image-2.png)
## one the popular services Mesh is Istio 
## you as a devops enginner your task is to deploy existing MS applications in a k8s cluster
![Alt text](image-3.png)

## What information do you need from developers to be able MS to deploy in k8s cluster
![Alt text](image-4.png)
## in order msg broker or service mesh which app are using .
![Alt text](image-5.png)
## based to these information 
![Alt text](image-6.png)
## we decide  each MS run in which ns 
![Alt text](image-7.png)
![Alt text](image-8.png)
## App => https://github.com/med363/microservices-demo
![Alt text](image-9.png)
![Alt text](image-10.png)
# Wich the entrypoint service get request from the browser 
![Alt text](image-11.png)
![Alt text](image-12.png)
## for testing MS 
![Alt text](image-13.png)
![Alt text](image-14.png)
## in the second stage we need also to know 
![Alt text](image-15.png)
![Alt text](image-16.png)
## on wich port 
![Alt text](image-17.png)
## because u have to define that in the configuration files for deployement but also for the services to be able to connect application inside the pod.
![Alt text](image-18.png)

###### volume 
![Alt text](image-19.png)
![Alt text](image-20.png)

## in config-v1.yaml
![Alt text](image-21.png)
## best practice in config-v2.yaml
![Alt text](image-22.png)
## => u should put a specific version of image
![Alt text](image-23.png)
![Alt text](image-24.png)
![Alt text](image-25.png)
## => u should configure a liveness probe on each container
![Alt text](image-26.png)
![Alt text](image-27.png)
![Alt text](image-28.png)
![ ](image-29.png)
## liveness Probe is a script or a tiny prog that pings app entypoint every 5s or 10s to check the app response so it running succesfully 
![Alt text](image-30.png)
## => u should configure a readiness probe on each container
![Alt text](image-31.png)
![Alt text](image-32.png)
![Alt text](image-33.png)
![Alt text](image-34.png)
prb
![Alt text](image-35.png)
 ## => u should configure a resource requests for each container
 ![Alt text](image-36.png)
 ## some app need more cpu and memory 
 ![Alt text](image-37.png)
![Alt text](image-38.png)
 ![Alt text](image-39.png)
 ![Alt text](image-40.png)
 ![Alt text](image-41.png)
 ![Alt text](image-42.png)
 ![Alt text](image-43.png)
##  Don't expose a Node Port!
![Alt text](image-44.png)
![Alt text](image-45.png)
## the best practice 
![Alt text](image-46.png)
![Alt text](image-47.png)
![Alt text](image-48.png)
## u should configure more than 1 Replica for Deployement
![Alt text](image-49.png)
![Alt text](image-50.png)
![Alt text](image-51.png)
![Alt text](image-52.png)
## u should configure more than 1 worker for the cluster
![Alt text](image-53.png)
![Alt text](image-54.png)
![Alt text](image-55.png)
# u should using labels 
![Alt text](image-56.png)
![Alt text](image-57.png)
![Alt text](image-58.png)
# u shoould using ns
![Alt text](image-59.png)
![Alt text](image-60.png)
# make manage cluster more easier compare to 
![Alt text](image-61.png)
## Also by difine different privelege
![Alt text](image-63.png)
![Alt text](image-64.png)
![Alt text](image-65.png)
# use should use security 
![Alt text](image-66.png)
![Alt text](image-67.png)
![Alt text](image-68.png)
![Alt text](image-69.png)
![Alt text](image-70.png)
![Alt text](image-71.png)