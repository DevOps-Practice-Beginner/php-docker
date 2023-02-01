pipeline {

agent { label 'mac' }

    stages {

         stage('scm') {

                    steps {
                    echo "======== Cloning the source code ==============="
                    git branch: 'stage', credentialsId: 'rajendranelakurthi', url: 'https://github.com/DevOps-Practice-Beginner/php-docker.git'
                    echo "BRANCH: ${GIT_BRANCH}"
                           }
             
                      }

         stage('Build') {

                   steps {
                    script {
             echo "=================Building Docker image for ${GIT_BRANCH} branch========================"
             sh "docker build -t helloworld-stage ."
             
         }
      }
                         }
   stage('deploy') {

                   steps {
               echo "=================Deploying PHP code in :${GIT_BRANCH} Environment"
                        sh returnStatus: true, returnStdout: true, script: '''docker ps -a
docker images
docker stop helloworld-stage || true && docker rm helloworld-stage || true
docker run -d -p 92:80 --name helloworld-stage helloworld-stage'''
                         }

                      } 

        

            }

    }

