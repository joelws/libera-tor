pipeline {
    agent {
        label 'docker-agent'
    }

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

        stage('Build Docker Image') {
            steps {
                sh "docker version"
                sh "docker build -t ${IMAGE}:${env.BUILD_ID} ."
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'github-token',
                    usernameVariable: 'GHCR_USER',
                    passwordVariable: 'GHCR_TOKEN'
                )]) {
                    sh """
                    echo "${GHCR_TOKEN}" | docker login ${REGISTRY} -u ${GHCR_USER} --password-stdin
                    docker push ${IMAGE}:${env.BUILD_ID}
                    """
                }
            }
        }
    }
}

