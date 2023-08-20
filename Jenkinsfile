// pipeline {
//   environment {
//     image_name = "jenkins/practice"
//     ecrurl = "https://996109426400.dkr.ecr.ap-northeast-1.amazonaws.com"
//     ecrcredentials = "ecr:ap-northeast-1:AWS_ACCESS_KEY"
//   }
//   agent any
//   stages {
//     stage('Cloning Git') {
//       steps {
//         checkout scm
//       }
//     }
//     stage('Building image') {
//       steps{
//         script {
//           dockerImage = docker.build("${image_name}:${BUILD_NUMBER}", './sample-python-web-app')
//         }
//       }
//     }

//     stage('Deploy github/actions Image') {
//       steps{
//         script {
//           // cleanup current user docker credentials
//           sh 'rm -f ~/.dockercfg ~/.docker/config.json || true'

//           docker.withRegistry(ecrurl, ecrcredentials) {
//             dockerImage.push("$BUILD_NUMBER")
//           }
//         }
//       }
//     }

//     stage('Remove Unused docker image - github/actions') {
//       steps{
//         sh "docker rmi $image_name:$BUILD_NUMBER"
//       }
//     } // End of remove unused docker image for github/actions
//   }
// } //end of pipeline

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
      steps{
        script {
          dockerImage = docker.build("${image_name}:nginx:0.1.${BUILD_NUMBER}", './sample-python-web-app')
        }
      }
    }
   
stage('Deploy Image') {
      steps{
        script {
          docker.withRegistry(ecrurl, ecrcredentials) {     
            dockerImage.push("nginx:0.1.$BUILD_NUMBER")
          }
        }
      }
    }

 
    stage('Remove Unused docker image') {     
      steps{
        sh "docker rmi $image_name:nginx:0.1.$BUILD_NUMBER"
      }
    } // End of remove unused docker image for master
  }  
} //end of pipeline
