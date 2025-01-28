pipeline {
    agent {
        
    }
    environment {
        DOCKER_IMAGE = 'laxmidhakal/python-app' 
    }
    stages {

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
                docker compose up -d
                '''
            }
        }
    }

    post { 
          always { 
            mail to: 'laxmidhakal159@gmail.com',
            subject: "Job '${JOB_NAME}' (${BUILD_NUMBER}) is waiting for input",
            body: "Please go to this ${BUILD_URL} and verify the build"
          }

        success {
            mail bcc: '', body: """Hello Team,

            Build #$BUILD_NUMBER is successful, please go through this url

             $BUILD_URL

            and verify the details.

            Regards,
            TechAxis DevOps Team""", cc: '', from: '', replyTo: '', subject: 'BUILD SUCCESS NOTIFICATION', to: 'laxmidhakal159@gmail.com'
        }
        failure {
            mail bcc: '', body: """Hello Team,
            
          Build #$BUILD_NUMBER is unsuccessful, please go through this url

          $BUILD_URL

          and verify the details.

          Regards,
          Techaxis DevOps Team""", cc: '', from: '', replyTo: '', subject: 'BUILD FAILED NOTIFICATION', to: 'laxmidhakal159@gmail.com'
        }
    }
}
