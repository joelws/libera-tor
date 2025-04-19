pipeline {
    agent any

    environment {
        REGISTRY   = 'ghcr.io'
        GIT_USER   = 'joelws'
        REPOSITORY = 'libera-tor'
        IMAGE      = "${REGISTRY}/${GIT_USER}/${REPOSITORY}"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build and Push Docker Image') {
            steps {
                script {
                    docker.withRegistry('https://index.docker.io/v1', 'docker-hub-credentials') {
                        def app = docker.build("${IMAGE}:${env.BUILD_ID}")

                        docker.withRegistry('https://ghcr.io', 'github-token') {
                            app.push()
                            app.push('latest')
                          }
                    }
                }
            }
        }
    }
}
