pipeline {

agent { label 'mac' }

    stages {

         stage('scm') {

                    steps {
                    echo "======== Cloning the source code ==============="
                    git branch: 'release', credentialsId: 'rajendranelakurthi', url: 'https://github.com/DevOps-Practice-Beginner/php-docker.git'
                    echo "BRANCH: ${GIT_BRANCH}"
                           }
             
                      }

         stage('Build') {

                   steps {
                    script {
             echo "=================Building Docker image for ${GIT_BRANCH} branch========================"
             sh "docker build -t helloworld-production ."
             
         }
      }
                         }
   stage('deploy') {

                   steps {
               echo "=================Deploying PHP code in :${GIT_BRANCH} Environment"
                        sh returnStatus: true, returnStdout: true, script: '''docker ps -a
docker images
docker stop helloworld-production || true && docker rm helloworld-production || true
docker run -d -p 93:80 --name helloworld-production helloworld-production'''
                         }

                      } 

        

            }

    }

