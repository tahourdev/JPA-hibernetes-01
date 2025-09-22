pipeline {
    agent { label "agent-2" }

    environment {
        DOCKERHUB_REPO = "keanghor31/spring-app01"
        IMAGE_NAME = "spring-app01"
        IMAGE_TAG = "1.0.2"
        CONTAINER_NAME = "spring-app01-api" // 👈 define your actual container name here
    }

    stages {

        stage("Build Docker Image") {
            steps {
                echo "🔧 Building Docker image: ${IMAGE_NAME}:${IMAGE_TAG}"
                sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
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
                        docker tag $IMAGE_NAME:$IMAGE_TAG $DOCKERHUB_REPO:$IMAGE_TAG
                        docker push $DOCKERHUB_REPO:$IMAGE_TAG
                        docker logout
                    '''
                }
            }
        }

        stage("Deploy with Docker Compose") {
            steps {
                echo "🚀 Checking current deployment state..."
                sh '''
                    CURRENT_IMAGE=$(docker inspect --format='{{.Config.Image}}' $CONTAINER_NAME 2>/dev/null || true)
                    EXPECTED_IMAGE="$DOCKERHUB_REPO:$IMAGE_TAG"
        
                    if [ "$CURRENT_IMAGE" = "$EXPECTED_IMAGE" ]; then
                        echo "✅ Container '$CONTAINER_NAME' is already running with image '$EXPECTED_IMAGE'. Skipping deployment."
                    else
                        echo "📦 Current image: '$CURRENT_IMAGE'"
                        echo "📦 Expected image: '$EXPECTED_IMAGE'"
                        echo "🔄 Deploying container using Docker Compose..."
                        
                        # Optionally stop and remove existing container before re-deploying
                        docker compose down || true
                        docker compose up -d
                    fi
                '''
            }
        }
    }

    post {
        success {
            echo "✅ Successfully built and pushed image: ${DOCKERHUB_REPO}:${IMAGE_TAG}"
        }
        failure {
            echo "❌ Pipeline failed."
        }
    }
}
