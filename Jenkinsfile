pipeline {
    agent {
        label 'ubuntu-node'
    }
    environment {
        DOCKER_IMAGE = 'laxmidhakal/python-app' // Replace with your Docker Hub repository
    }
    stages {
        stage('Build Application') {
            steps {
                echo "No specific build step required for Python. Proceeding to Docker image creation..."
            }
        }

        stage('Create Docker Image') {
            steps {
                echo "Building Docker image for Python application..."
                sh '''
                docker build -t localpythonimage:$BUILD_NUMBER .
                '''
            }
        }

        stage('Push to Docker Hub') {
            steps {
                echo "Logging into Docker Hub..."
                withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                    sh '''
                    echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                    docker images
                    '''
                }
                echo "Pushing Docker image to Docker Hub..."
                sh '''
                docker tag localpythonimage:$BUILD_NUMBER ${DOCKER_IMAGE}:$BUILD_NUMBER
                docker push ${DOCKER_IMAGE}:$BUILD_NUMBER
                '''
            }
        }

        stage('Run Docker Compose') {
            steps {
                echo "Starting containers with Docker Compose..."
                sh '''
                sed -i 's|${BUILD_NUMBER}|'$BUILD_NUMBER'|g' compose.yaml
                docker compose up -d
                '''
            }
        }
    }

    post {
        success {
            echo "Build and deployment successful!"
        }
        failure {
            echo "Build or deployment failed. Please check logs."
        }
    }
}
