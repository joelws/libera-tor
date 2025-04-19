pipeline {
    agent any

    environment {
        REGISTRY = 'ghcr.io'
        GIT_USER = 'joelws'
        REPOSITORY = 'libera-tor'
        GHCR_CREDS = credentials('github-token')
        IMAGE = "${REGISTRY}/${GIT_USER}/${REPOSITORY}"
      }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
              }
          }
        stage('Retrieve Git Commit and Hash') {
            steps {
                script {
                    env.GIT_COMMIT_HASH = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
                    echo "Github Commit Hash: ${env.GIT_COMMIT_HASH}"
                  }
              }
          }
        stage('Build') {
            steps {
                script {
                    def image = "${env.IMAGE}:${env.GIT_COMMIT_HASH}"
                    def imageLatest = "${env.IMAGE}:latest"
                    sh """
                      echo ${env.GHCR_CREDS_PSW} | docker login ${env.REGISTRY} -u ${env.GHCR_CREDS_USR} --password-stdin 
                      docker build \
                        -t ${image} \
                        -t ${imageLatest} \
                        .
                      docker push ${image}
                      docker push ${imageLatest}
                    """
                  }
              }
          }
  }
}
