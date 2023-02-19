pipeline {

agent { label 'mac' }
    /*environment {
        BRANCH = sh(returnStdout: true, script: 'git rev-parse --abbrev-ref HEAD').trim()
    }*/
    stages {

         stage('scm') {

                    steps {
                    echo "======== Cloning the source code ==============="
                    git branch: 'main', credentialsId: 'rajendranelakurthi', url: 'https://github.com/DevOps-Practice-Beginner/php-docker.git'
                    echo "GIT_BRANCH: ${GIT_BRANCH}"
                           }
             
                      }

         stage('Build') {

                   steps {
                    script {
             echo "=================Building Docker image for ${GIT_BRANCH} GIT_BRANCH========================"
             sh "docker build -t helloworld-main ."
             
         }
      }
                         }
   stage('deploy') {

                   steps {
               echo "=================Deploying PHP code in :${GIT_BRANCH} Environment"
                        sh returnStatus: true, returnStdout: true, script: '''docker ps -a
docker images
docker stop helloworld-main || true && docker rm helloworld-main || true
docker run -d -p 92:80 --name helloworld-main helloworld-main'''
                         }

                      } 

        

            }

    }

