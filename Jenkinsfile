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
       
       /*stage ('Build image ic-webapp'){
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
       }*/

        stage('Scan avec SNYK de l\'image') {
            agent any	
            environment{
                SNYK_TOKEN = credentials('snyk-api-token')
            }
            steps {
                script{
                    sh '''
                    docker scan --login --token $SNYK_TOKEN --accept-license
                    docker scan --json --file Dockerfile $USERNAME/$IMAGE_NAME:$IMAGE_TAG > resultat.json
                    grep 'message' resultat.json`
                    OK=`grep 'ok' resultat.json` 
                    if [ ${OK} = '"ok": true,' ]; then true; else false; fi
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
        }*/
    }
}