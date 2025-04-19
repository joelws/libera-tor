pipeline {
    agent any

    environment {
        REGISTRY = 'ghcr.io'
        GIT_USER = 'joelws'
        REPOSITORY = 'libera-tor'
        IMAGE = "${REGISTRY}/${GIT_USER}/${REPOSITORY}"
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Get Commit SHA') {
            steps {
                script {
                    env.GIT_COMMIT_HASH = sh(script: "git rev-parse --short HEAD", returnStdout: true).trim()
                    echo "Git Commit Hash: ${env.GIT_COMMIT_HASH}"
                }
            }
        }

        stage('Build & Push Docker Image') {
            agent {
                docker {
                    image 'docker:20.10-cli'
                    args '-v /var/run/docker.sock:/var/run/docker.sock'
                    reuseNode true
                }
            }
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'github-token',
                    usernameVariable: 'GHCR_USER',
                    passwordVariable: 'GHCR_TOKEN'
                )]) {
                    script {
                        def tag = "${env.IMAGE}:${env.GIT_COMMIT_HASH}"
                        def latest = "${env.IMAGE}:latest"

                        sh """#!/bin/sh
                        echo "$GHCR_TOKEN" | docker login ${REGISTRY} -u "$GHCR_USER" --password-stdin
                        docker build -t ${tag} -t ${latest} .
                        docker push ${tag}
                        docker push ${latest}
                        """
                    }
                }
            }
        }
    }
}

