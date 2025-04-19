pipeline {
    def app
    environment {
        REGISTRY = 'ghcr.io'
        GIT_USER = 'joelws'
        REPOSITORY = 'libera-tor'
        IMAGE = "${REGISTRY}/${GIT_USER}/${REPOSITORY}"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Push Docker Image') {
          docker.withRegistry('https://ghcr.io', 'github-token') {
              docker.build("${IMAGE}:${env.BUILD_ID}").push()
            }
            }
        }
    }
}

