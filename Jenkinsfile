pipeline {

  options {
    ansiColor('xterm')
  }

  agent {
    kubernetes {
      yamlFile 'builder.yaml'
    }
  }

  stages {

    stage('Build and Push Image') {
      steps {
        container('kaniko') {
          script {
            sh '''
            /kaniko/executor --dockerfile `pwd`/Dockerfile \
                             --context `pwd` \
                             --destination=santospv08/app-apache-docker:${BUILD_NUMBER}
            '''
          }
        }
      }
    }

    stage('Deploy App to Kubernetes') {     
      steps {
        container('gcloud-kubectl') {
         
            withCredentials([file(credentialsId: 'mykubeconfig', variable: 'GC_KEY')]) {

              sh 'gcloud auth activate-service-account --key-file=${GC_KEY}'
              sh 'gcloud container clusters get-credentials pvs-devops-iac-gke --zone us-south1-c --project pvs-devops-iac'
              sh 'kubectl get nodes'
              sh 'sed -i "s/<TAG>/${BUILD_NUMBER}/" app/pvsapp.yaml'
              sh 'kubectl apply -f app/pvsapp.yaml'
              
            }
        }
      }
    }
  
  }
}