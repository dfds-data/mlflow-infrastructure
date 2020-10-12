 # Introduction
 The `Dockerfile` in this folder can be used to build an mlflow server which uses a filesystem (such as S3) as its artifact store and a postgresql database as its tracking backend. You can easily test it out by running the following in your terminal and then accessing [this URL](http://localhost:5000) in your browser.
 ```sh
 docker-compose up
 ```
 The goal with this step is to deploy the mlflow container as a pod on kubernetes. We will do this through a pipeline in Azure devops.

 # Instructions