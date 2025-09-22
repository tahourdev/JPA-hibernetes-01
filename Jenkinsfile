pipeline {
    agent { label "agent-1" }

    environment {
        DOCKERHUB_REPO = "keanghor31/spring-app01"
        IMAGE_NAME = "spring-app01-agent-1-demo-api"
        IMAGE_TAG = "1.0.1"
        CONTAINER_NAME = "hw-2-api"  // Your app container name
    }

    stages {
        stage("Clone Code") {
            steps {
                echo "Cloning the repository"
                git url: "https://github.com/tahourdev/JPA-hibernetes-01.git", branch: "main"
            }
        }

        stage("Push to DockerHub") {
            steps {
                echo "Tagging and pushing Docker image"
                withCredentials([
                    usernamePassword(
                        credentialsId: 'docker-hub-credentials',
                        usernameVariable: 'DOCKERHUB_USER',
                        passwordVariable: 'DOCKERHUB_PASS'
                    )
                ]) {
                    sh """
                        echo "$DOCKERHUB_PASS" | docker login -u "$DOCKERHUB_USER" --password-stdin
                        docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${DOCKERHUB_REPO}:${IMAGE_TAG}
                        docker push ${DOCKERHUB_REPO}:${IMAGE_TAG}
                        docker logout
                    """
                }
            }
        }

        stage("Build") {
            steps {
                echo "Skipping build step because image already exists."
            }
        }

        stage("Deploy with Docker Compose") {
            steps {
                echo "Checking if container is already running..."
                sh """
                    #!/bin/bash

                    if docker ps --format '{{.Names}}' | grep -wq "${CONTAINER_NAME}"; then
                        echo "✅ Container '${CONTAINER_NAME}' is already running. Skipping deploy."
                    else
                        echo "🚀 Container '${CONTAINER_NAME}' not running. Deploying with docker compose..."
                        docker compose up -d
                    fi
                """
            }
        }
    }

    post {
        success {
            echo "✅ Pipeline completed successfully."
        }
        failure {
            echo "❌ Pipeline failed."
        }
    }
}
