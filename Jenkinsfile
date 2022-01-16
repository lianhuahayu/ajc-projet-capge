pipeline {

    environment {
        IMAGE_NAME = "ic-webapp"
        IMAGE_TAG = "1.0"
        USERNAME = "lianhuahayu"
        CONTAINER_NAME = "test-ic-webapp"
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')  
    }

    tools {
        terraform 'Terraform'
    }

    agent none
    stages{
        stage ('Test variable') {
           agent any
           steps {
            withCredentials([sshUserPrivateKey(credentialsId: "capge_key_pair", keyFileVariable: 'keyfile', usernameVariable: 'NUSER')]) {
               script{
                    timeout(time: 15, unit: "MINUTES") {
                        input message: "Confirmer le deploiement sur la production de l'image ? [Cette acton supprimera l'environnement de test]", ok: 'Yes'
                    }	
                   sh '''
                    IMAGE="ic-webapp_image=$USERNAME/$IMAGE_NAME:$IMAGE_TAG"
                    echo ${IMAGE}
                    echo "Fin"
                   '''               
                    }
                }
            }
        }
    }
}       
/*       stage ('Build image ic-webapp'){
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
*/
        //stage('Test de vulnerabilites avec SNYK') {	
        //   agent {
        //        docker {
        //            image 'snyk/snyk-cli:python-3'
        //            }
        //    }
        //    environment {
        //        SNYK_TOKEN = credentials('snyk-token')
        //    }	
        //    steps {
        //        sh """
        //            snyk auth ${SNYK_TOKEN}
        //            snyk container test $USERNAME/$IMAGE_NAME:$IMAGE_TAG \
        //                --json \
        //                --severity-threshold=high
        //            """			
         //       }
         //   }                
          
 /*     stage ('Nettoyage local et push vers un registre publique') {
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
                       docker rmi $USERNAME/$IMAGE_NAME:$IMAGE_TAG
            /      '''
                }
             }
        }
*/
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
                    IMAGE = 'ic-webapp_image=$USERNAME/$IMAGE_NAME:$IMAGE_TAG'
                    echo $IMAGE
                    terraform apply -var='key_path=../.aws/capge_projet_kp.pem' -var="ic-webapp_image={USERNAME/$IMAGE_NAME:$IMAGE_TAG" --auto-approve || true
                    '''               
                    }
               }
            }
        }


        stage ('Test de env-test') {
           agent any
           steps {
               script{
                   sh '''
                       echo 'PASSED' || true
                   '''               
                    }
                }
            }

        stage ('Deploiement manuel de env-prod apres validation de env-test') {
           agent any
           steps {
               script{
                   sh '''
                       echo 'PASSED' || true
                   '''               
                    }
                }
            }

        stage ('Test de env-prod') {
           agent any
           steps {
            withCredentials([sshUserPrivateKey(credentialsId: "capge_key_pair", keyFileVariable: 'keyfile', usernameVariable: 'NUSER')]) {
               script{
                    timeout(time: 15, unit: "MINUTES") {
                        input message: "Confirmer le deploiement sur la production de l'image ? [Cette acton supprimera l'environnement de test]", ok: 'Yes'
                    }	
                   sh '''
                       cd ./terraform_env_test/app
                       terraform destroy --auto-approve 
                       echo "Fin"
                   '''               
                    }
                }
            }
        }
    }
}*/