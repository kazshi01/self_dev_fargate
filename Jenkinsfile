pipeline {
  environment {
    image_name = "jenkins/practice"
    ecrurl = "https://996109426400.dkr.ecr.ap-northeast-1.amazonaws.com"
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
      steps {
        script {
          dockerImage = docker.build("${image_name}:nginx_0.1.${BUILD_NUMBER}", './sample-python-web-app')
        }
      }
    }
    stage('Tagging') {
      steps {
        script {
          def tagName = "nginx_0.1.${BUILD_NUMBER}"
          sh "git tag ${tagName}"
          sh "git push origin ${tagName}"
        }
      }
    }
    stage('Amend Commit Message') {  // コミットメッセージの修正ステージを追加
      steps {
        script {
          sh '''
            git commit --amend -m "$(git log --format=%B -n 1) [Build ${BUILD_NUMBER}]"
            git push origin +Jenkins
          '''
        }
      }
    }
    stage('Deploy Image') {
      steps {
        script {
          docker.withRegistry(ecrurl, ecrcredentials) {
            dockerImage.push("nginx_0.1.$BUILD_NUMBER")
          }
        }
      }
    }
    stage('Remove Unused docker image') {
      steps {
        sh "docker rmi $image_name:nginx_0.1.$BUILD_NUMBER"
      }
    } // End of remove unused docker image for master
  }
} // end of pipeline
