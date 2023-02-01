pipeline {

agent { label 'mac' }
    environment {
        BRANCH = sh(returnStdout: true, script: 'git rev-parse --abbrev-ref HEAD').trim()

    }
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
             sh "docker build -t helloworld-${GIT_BRANCH} ."
             
         }
      }
                         }
   stage('deploy') {

                   steps {
               echo "=================Deploying PHP code in :${GIT_BRANCH} Environment"
                        sh returnStatus: true, returnStdout: true, script: '''docker ps -a
docker images
docker stop helloworld-${GIT_BRANCH} || true && docker rm helloworld-${GIT_BRANCH} || true
docker run -d -p 93:80 --name helloworld-${GIT_BRANCH} helloworld-${GIT_BRANCH}'''
                         }

                      } 

        

            }

    }

