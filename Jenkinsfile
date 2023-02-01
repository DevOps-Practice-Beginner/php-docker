pipeline {

agent { label 'mac' }

    stages {

         stage('scm') {

                    steps {
                    echo "======== Cloning the source code ==============="
                    git branch: 'development', credentialsId: 'rajendranelakurthi', url: 'https://github.com/DevOps-Practice-Beginner/php-docker.git'
                    echo "GIT_BRANCH: ${GIT_BRANCH}"
                           }
             
                      }

         stage('Build') {

                   steps {
                    script {
             echo "=================Building Docker image for ${GIT_BRANCH} GIT_BRANCH========================"
             sh "docker build -t helloworld-development ."
             
         }
      }
                         }
   stage('deploy') {

                   steps {
               echo "=================Deploying PHP code in :${GIT_BRANCH} Environment"
                        sh returnStatus: true, returnStdout: true, script: '''docker ps -a
docker images
docker stop helloworld-development || true && docker rm helloworld-development || true
docker run -d -p 91:80 --name helloworld-development helloworld-development'''
                         }

                      } 

        

            }

    }

