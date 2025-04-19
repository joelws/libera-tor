pipeline {
    agent {
        docker {
            image 'docker:20.10-cli'
            args '-v /var/run/docker.sock:/var/run/docker.sock'
        }
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

        stage('Get Commit SHA') {
            steps {
                script {
                    env.GIT_COMMIT_HASH = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${IMAGE}:${GIT_COMMIT_HASH} ."
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'github-token',
                    usernameVariable: 'GHCR_USER',
                    passwordVariable: 'GHCR_TOKEN'
                )]) {
                    script {
                        sh """
                        echo "${GHCR_TOKEN}" | docker login ${REGISTRY} -u ${GHCR_USER} --password-stdin
                        docker push ${IMAGE}:${GIT_COMMIT_HASH}
                        """
                    }
                }
            }
        }
    }
}

