pipeline {

agent any
    environment {
        BRANCH = sh(returnStdout: true, script: 'git rev-parse --abbrev-ref HEAD').trim()
        #BRANCH_ENV = "${env.GIT_BRANCH}"
        #TAG = "${env.BRANCH}.${env.COMMIT_HASH}.${env.BUILD_NUMBER}".drop(15)
        #DEV_TAG = "${env.BRANCH}.${env.COMMIT_HASH}.${env.BUILD_NUMBER}".drop(7)
        #VERSION = "${env.TAG}"
    }
    stages {

         stage('scm') {

                    steps {
                    echo "======== Cloning the source code ==============="
                    git branch: '${BRANCH}', credentialsId: 'rpcyngit', url: 'https://github.com/DevOps-Practice-Beginner/php-docker.git'
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

