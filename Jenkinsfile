pipeline {
  environment {
    image_name = "test"
    ecrurl = "https://996109426400.dkr.ecr.ap-northeast-1.amazonaws.com/jenkins/practice"
    ecrcredentials = "ecr:ap-northeast-1:AWS_ACCESS_KEY"
  }
  agent any
  stages {
    stage('Cloning Git') {
      steps {
        checkout scm
      }
    }
    stage('Building image') {
      steps{
        script {
          dockerImage = docker.build("${image_name}:${BUILD_NUMBER}", './sample-python-web-app')
        }
      }
    }

    stage('Deploy github/actions Image') {
      steps{
        script {
          // cleanup current user docker credentials
          sh 'rm -f ~/.dockercfg ~/.docker/config.json || true'

          docker.withRegistry(ecrurl, ecrcredentials) {
            dockerImage.push("$BUILD_NUMBER")
          }
        }
      }
    }

    stage('Remove Unused docker image - github/actions') {
      steps{
        sh "docker rmi $image_name:$BUILD_NUMBER"
      }
    } // End of remove unused docker image for github/actions
  }
} //end of pipeline
