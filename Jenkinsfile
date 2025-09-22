pipeline {
    agent { label "agent-2" }

    environment {
        DOCKERHUB_REPO = "keanghor31/spring-app01"
        IMAGE_TAG = "${env.BUILD_NUMBER ?: 'latest'}"  // Dynamic tag based on Jenkins build number
        CONTAINER_NAME = "spring-app01-api"            // Your container name
        DOCKER_IMAGE_FULL = "${DOCKERHUB_REPO}:${IMAGE_TAG}"
    }

    stages {

        stage("Build Docker Image") {
            steps {
                echo "🔧 Building Docker image: ${DOCKER_IMAGE_FULL}"
                sh "docker build -t ${DOCKER_IMAGE_FULL} ."
            }
        }

        stage("Push to DockerHub") {
            steps {
                echo "📦 Tagging and pushing Docker image to DockerHub..."
                withCredentials([
                    usernamePassword(
                        credentialsId: 'docker-hub-credentials',
                        usernameVariable: 'DOCKERHUB_USER',
                        passwordVariable: 'DOCKERHUB_PASS'
                    )
                ]) {
                    sh '''
                        echo "$DOCKERHUB_PASS" | docker login -u "$DOCKERHUB_USER" --password-stdin
                        docker push $DOCKER_IMAGE_FULL
                        docker logout
                    '''
                }
            }
        }

        stage("Deploy with Docker Compose") {
            steps {
                echo "🚀 Checking current deployment state..."

                // Use shell script to check running container image and deploy if changed
                sh '''
                    CURRENT_IMAGE=$(docker inspect --format='{{.Config.Image}}' $CONTAINER_NAME 2>/dev/null || true)
                    EXPECTED_IMAGE="$DOCKER_IMAGE_FULL"

                    if [ "$CURRENT_IMAGE" = "$EXPECTED_IMAGE" ]; then
                        echo "✅ Container '$CONTAINER_NAME' is already running with image '$EXPECTED_IMAGE'. Skipping deployment."
                    else
                        echo "📦 Current image: '$CURRENT_IMAGE'"
                        echo "📦 Expected image: '$EXPECTED_IMAGE'"
                        echo "🔄 Deploying container using Docker Compose..."

                        # Stop and remove old container(s) gracefully
                        docker compose down || true

                        # Start new container(s) with updated image
                        docker compose up -d

                        # Optionally, add a health check wait loop here if needed
                    fi
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Successfully built, pushed image, and deployed if needed: ${DOCKER_IMAGE_FULL}"
        }
        failure {
            echo "❌ Pipeline failed."
        }
    }
}
