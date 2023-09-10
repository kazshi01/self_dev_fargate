pipeline {
  environment {
    image_name = "jenkins/practice"
    ecrurl = "https://996109426400.dkr.ecr.ap-northeast-1.amazonaws.com"
    ecrcredentials = "ecr:ap-northeast-1:AWS_ACCESS_KEY"
    task_definition_family = "dev-marukome-service"
    task_definition = "dev-marukome-service"
    cluster_name = "dev-marukome-cluster"
    service_name = "dev-marukome-service"
    output_path = "./my-task-definition.json"
    modify_path = "./my-fixed-task-definition.json"
    default_region = "ap-northeast-1"
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
    stage('Push to ECR') {
      steps {
        script {
          docker.withRegistry(ecrurl, ecrcredentials) {
            dockerImage.push("nginx_0.1.$BUILD_NUMBER")
          }
        }
      }
    }
    stage('Pull from ECR') {
      steps {
        script {
          docker.withRegistry(ecrurl, ecrcredentials) {
            docker.image("${image_name}:nginx_0.1.$BUILD_NUMBER").pull()
          }
        }
      }
    }
    stage('Export Task Definition to JSON') {
      steps {
        script {
          sh '''
          aws ecs describe-task-definition --task-definition ${task_definition_family} \
          --region ${default_region} > ${output_path}
          '''
          sh "ls -l ${output_path}"
          sh "cat ${output_path}"
        }
      }
    }
    stage('Modify JSON') {
      steps {
        script {
          // Pythonスクリプトを使ってJSONを修正
          sh '''
          python3 filter_task_definition.py "${output_path}" "${modify_path}"
          '''
        }
      }
    }
    stage('Deploy to Fargate') {
      steps {
        script {
          // 修正されたJSONを使用してタスク定義を登録
          sh '''
          aws ecs register-task-definition \
            --cli-input-json file://${modify_path} \
            --region ${default_region}
          '''
          sh '''
          aws ecs update-service --cluster ${cluster_name} \
            --service ${service_name} --task-definition ${task_definition} \
            --region ${default_region}
          '''
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
