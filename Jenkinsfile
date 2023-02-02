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

    stage('Update GIT') {
      steps {
        container('pvsbuilder') {
          script {
            catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
              withCredentials([usernamePassword(credentialsId: 'github', passwordVariable: 'GIT_PASSWORD', usernameVariable: 'GIT_USERNAME')]) {
                def encodedPassword = URLEncoder.encode("$GIT_PASSWORD",'UTF-8')
                  sh "git config user.email paulovitor8@gmail.com"
                  sh "git config user.name santospv"
                  sh "cd k8s && kustomize edit set image pvsapp='santospv08/app-apache-docker:${BUILD_NUMBER}'"
                  sh "cat k8s/kustomization.yaml"
                  sh "cat k8s/app/pvsapp.yaml"
                  sh "git add ."
                  sh "git commit -m 'Atualizando Versao no Manifesto k8s: ${env.BUILD_NUMBER}'"
                  sh "git push https://${GIT_USERNAME}:${encodedPassword}@github.com/${GIT_USERNAME}/argocd-gke-ci.git HEAD:main"
              }
            }
          }
        }
      }
    }
  }
}