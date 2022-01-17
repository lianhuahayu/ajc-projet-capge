pipeline {

    environment {
        IMAGE_NAME = "ic-webapp"
        IMAGE_TAG = "1.0"
        USERNAME = "lianhuahayu"
        CONTAINER_NAME = "test-ic-webapp"
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY') 
        EC2_PROD = "ec2-54-235-230-173.compute-1.amazonaws.com" 
    }

    tools {
        terraform 'Terraform'

    }

    agent none
    stages{
       
       stage ('Build image ic-webapp'){
           agent any
           steps {
               script{
                   sh '''
                       docker stop $CONTAINER_NAME || true
                       docker rm $CONTAINER_NAME || true
                       docker rmi $USERNAME/$IMAGE_NAME:$IMAGE_TAG || true
                       docker build -t $USERNAME/$IMAGE_NAME:$IMAGE_TAG .
                  '''
               }
           }
       }

        stage('Scan avec SNYK de l\'image') {
            agent any	
            environment{
                SNYK_TOKEN = credentials('snyk-api-token')
            }
            steps {
                script{
                    sh '''#!/bin/bash
                    echo "Scan de l'image en cours ..."
                    docker scan --login --token $SNYK_TOKEN --accept-license
                    docker scan --json --file Dockerfile $USERNAME/$IMAGE_NAME:$IMAGE_TAG > resultats.json
                    echo `grep 'message' resultats.json`
                    OK=`grep 'ok' resultats.json`
                    if [ "${OK}" = '  "ok": true,' ]; then true; else echo false; fi
                    echo "Fin du scan de l'image"
                    
                    echo "Test des variables d'environnements de l'image en cours ..."
                    
                    docker run -d --name $CONTAINER_NAME -p:8090:8080 $USERNAME/$IMAGE_NAME:$IMAGE_TAG
                    
                    test1=`head -n 1 <(curl -Is http://localhost:8090)`
                    test1=`sed 's/\r$//' <(echo $test1)`
                    if [ "${test1}" = 'HTTP/1.0 200 OK' ]; then echo "pass test1"; else echo "false test1 ${test1}"; fi
                    
                    test2=`grep '<a href="https://www.odoo.com/' <(curl -s http://localhost:8090)`
                    test2=`cut -d'"' -f2 <(echo $test2)`
                    if [ "${test2}" = 'https://www.odoo.com/' ]; then echo "pass test2"; else echo "false test2 ${test2}"; fi
                    
                    test3=`grep '<a href="https://www.pgadmin.org/' <(curl -s http://localhost:8090)`
                    test3=`cut -d'"' -f2 <(echo $test3)`
                    if [ "${test3}" = 'https://www.pgadmin.org/' ]; then echo "pass test3"; else echo "false test3 ${test3}"; fi
                    
                    exit 0
                    '''
                }
            }
        }

      /*stage ('Push vers un registre publique') {
           agent any
           environment{
               PASSWORD = credentials('token_dockerhub')
           }
           steps {
               script{
                   sh '''
                       docker login -u $USERNAME -p $PASSWORD
                       docker push $USERNAME/$IMAGE_NAME:$IMAGE_TAG
                       docker stop $CONTAINER_NAME || true
                       docker rm $CONTAINER_NAME || true
                   '''
                }
             }
        }*/

        /*stage ('Deploiement automatique de env-test via terraform') {
           agent any
           steps {
            withCredentials([sshUserPrivateKey(credentialsId: "capge_key_pair", keyFileVariable: 'keyfile', usernameVariable: 'NUSER')]) {
               script{
                    sh '''
                    rm -Rf ./terraform_env_test || true
                    mkdir ./terraform_env_test
                    git clone https://github.com/omarpiotr/terraform-ic-webapp.git ./terraform_env_test
                    cd ./terraform_env_test
                    cp $keyfile .aws/capge_projet_kp.pem
                    sed 's/"YOUR_KEY_ID"/$AWS_ACCESS_KEY_ID/g' .aws/credentials
                    sed 's/"YOUR_ACCESS_KEY"/$AWS_SECRET_ACCESS_KEY/g' .aws/credentials
                    cd ./app
                    terraform init
                    terraform plan
                    IMAGE="ic-webapp_image=$USERNAME/$IMAGE_NAME:$IMAGE_TAG"
                    terraform apply -var='key_path=../.aws/capge_projet_kp.pem' -var=${IMAGE} --auto-approve
                    '''               
                    }
               }
            }
        }
*/

        /*stage ('Test de env-test') {
           agent any
           steps {
               script{
                   sh '''
                       echo 'PASSED' || true
                   '''               
                    }
                }
            }

        stage ('Deploiement de prod env') {
           agent any
           steps {
            withCredentials([sshUserPrivateKey(credentialsId: "capge_key_pair", keyFileVariable: 'keyfile', usernameVariable: 'NUSER')]) {
               script{
                    timeout(time: 15, unit: "MINUTES") {
                        input message: "Confirmer le deploiement sur la production de l'image ? [Cette acton supprimera l'environnement de test]", ok: 'Yes'
                    }	
                   sh '''
                       cd ./terraform_env_test/app
                       terraform destroy --auto-approve || true
                       docker tag $USERNAME/$IMAGE_NAME:$IMAGE_TAG $USERNAME/$IMAGE_NAME:latest
                       docker push $USERNAME/$IMAGE_NAME:latest
                       docker rmi $USERNAME/$IMAGE_NAME:$IMAGE_TAG
                       docker rmi $USERNAME/$IMAGE_NAME:latest
                       echo "Fin"
                   '''               
                    }
                }
            }
        }

        stage ('Test de prod env') {
           agent any
           steps {
               script{
                   sh '''
                       echo 'PASSED' || true
                   '''               
                    }
                }
        }/* */
    }
}