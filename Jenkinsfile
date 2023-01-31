pipeline {

agent mac

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

                        sh "pwd"
                         }

                      } 

        

            }

    }
