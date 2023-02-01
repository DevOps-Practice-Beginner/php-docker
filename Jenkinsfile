pipeline {

agent { label 'mac' }
    environment {
        BRANCH = sh(returnStdout: true, script: 'git rev-parse --abbrev-ref HEAD').trim()
    }
    stages {

         stage('scm') {

                    steps {
                    echo "======== Cloning the source code ==============="
                    git branch: 'main', credentialsId: 'rajendranelakurthi', url: 'https://github.com/DevOps-Practice-Beginner/php-docker.git'
                    echo "BRANCH: ${BRANCH}"
                           }
             
                      }

         stage('Build') {

                   steps {
                    script {
             echo "=================Building Docker image for ${BRANCH} branch========================"
             sh "docker build -t helloworld-${BRANCH} ."
             
         }
      }
                         }
   stage('deploy') {

                   steps {
               echo "=================Deploying PHP code in :${BRANCH} Environment"
                        sh returnStatus: true, returnStdout: true, script: '''docker ps -a
docker images
docker stop helloworld-${BRANCH} || true && docker rm helloworld-${BRANCH} || true
docker run -d -p 92:80 --name helloworld-${BRANCH} helloworld-${BRANCH}'''
                         }

                      } 

        

            }

    }

