pipeline {

    environment {
        IMAGE_NAME = "ic-webapp"
        IMAGE_TAG = "1.0"
        USERNAME = "lianhuahayu"
        CONTAINER_NAME = "test-ic-webapp"
    }

    agent none

    stages{

        stage ('Build image ic-webapp'){
           agent any
           steps {
               script{
                   sh '''
                        docker build -t $USERNAME/$IMAGE_NAME:$IMAGE_TAG .
                   '''
               }
           }
       }

        stage ('Nettoyage et push vers un registre publique') {
           agent any
           environment{
               PASSWORD = credentials('capge_docker_access')
           }
           steps {
               script{
                   sh '''
                       docker login -u $USERNAME -p $PASSWORD
                       docker push $USERNAME/$IMAGE_NAME:$IMAGE_TAG
                       docker stop $CONTAINER_NAME || true
                       docker rm $CONTAINER_NAME || true
                       docker rmi $USERNAME/$IMAGE_NAME:$IMAGE_TAG
                   '''
               }
           }
       }
    }
}
