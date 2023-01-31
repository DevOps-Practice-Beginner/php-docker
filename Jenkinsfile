pipeline {

agent any

    stages {

         stage('scm') {

                    steps {
                      
                    git branch: 'main', credentialsId: 'rpcyngit', url: 'https://github.com/DevOps-Practice-Beginner/php-docker.git'
                           }
             
                      }

         stage('Build') {

                   steps {
                         sh "docker build -t helloworld-$GIT_BRANCH ."
                         }

                      }

   stage('deploy') {

                   steps {

                        sh returnStatus: true, returnStdout: true, script: '''docker ps -a
docker rm helloworld-$GIT_BRANCH
docker images
docker run -d -p 91:80 --name helloworld-$GIT_BRANCH helloworld-$GIT_BRANCH'''
                         }

                      } 

        

            }

    }
