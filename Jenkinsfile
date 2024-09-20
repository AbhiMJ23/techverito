pipeline {
    agent any
    
    tools {
       go 'go1.19'
    }
 
    environment {
          SCANNER_HOME = tool  'sonar-scanner'
        }

    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'backend', changelog: false, poll: false, url: 'https://github.com/AbhiMJ23/techverito.git'
            }
        }
        
        stage('Sonarqube Analysis') {
            steps {
                withSonarQubeEnv('sonar-server') {
                    sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=techverito -Dsonar.projectKey=techverito
                               -Dsonar.project.sources=. '''
                }
            }
        }
        
        stage('Trivy File Scan') {
            steps {
                sh 'trivy fs --format table -o trivy-filescanBackend-report.html . '
            }
        }
        
        stage('Go app build') {
            steps {
                script{
                    sh '''cd backend 
                          go mod download
                          go build -o /myapp '''
                }
            }
        }
                 
        stage('Docker Image build and Push') {
            steps {
                withDockerRegistry(credentialsId: 'dockerhub-cred', url: 'https://index.docker.io/v1/') {
                 sh ''' docker build -t abhimj23/techverito-backend:$BUILD_NUMBER .
                        docker push abhimj23/techverito-backend:$BUILD_NUMBER
               }
            }
        }
        
        stage('Trivy Image Scan') {
            steps {
                sh '''trivy image --format table -o trivy-backendimage-scan-report.html abhimj23/techverito-backend:$BUILD_NUMBER '''
            }
        }
        stage('Container Deployment Backend') {
            agent{
                label 'backend'
            }
            steps {
                    withDockerRegistry(credentialsId: 'dockerhub-cred', url: 'https://index.docker.io/v1/') {                       
                       sh 'docker run -d -p 8080:8080 --name backend:$BUILD_NUMBER abhimj23/techverito-backend:$BUILD_NUMBER '
               }
            }
        }       
    }
}
