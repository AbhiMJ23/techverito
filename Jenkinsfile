pipeline {
    agent any
    
    tools {
       go 'go:1.19'
       nodejs 'node:14.17'
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
                withSonarQubeEnv {
                    sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=techverito -Dsonar.projectKey=techverito
                               -Dsonar.project.sources=. '''
                }
            }
        }
        
        stage('Trivy File Scan') {
            steps {
                sh 'trivy fs --format table -o trivy-filescan-report.html . '
            }
        }
        
        stage('Go app build') {
            steps {
                script{
                    sh ''' go mod download
                           go build -o /myapp '''
                }
            }
        }
        
        stage('NPM Package install') {
            steps {
               sh 'npm install'
            }
        }
                 
        stage('Docker Image build and Push') {
            steps {
                withDockerRegistry(credentialsId: 'dockerhub-cred') {
                 sh ''' docker build -t abhimj23/techverito-backend:01 -f Dockerfile-Backend .
                        docker push abhimj23/techverito-backend:01
                       
                        docker build -t abhimj23/techverito-frontend:01 -f Dockerfile-Frontend .
                        docker push abhimj23/techverito-frontend:01  '''
               }
            }
        }
        
        stage('Trivy Image Scan') {
            steps {
                sh '''trivy image --format table -o trivy-backendimage-scan-report.html abhimj23/techverito-backend:01
                      trivy image --format table -o trivy-frontendimage-scan-report.html abhimj23/techverito-frontend:01 '''
            }
        }
        stage('Container Deployment Backend') {
            agent{
                label 'backend'
            }
            steps {
                    withDockerRegistry(credentialsId: 'dockerhub-cred') {                       
                       sh 'docker run -d -p 8080:8080 --name backend abhimj23/techverito-backend:01 '
               }
            }
        }
        
        stage('Container Deployment Frontend') {
            agent{
                label 'backend'
            }
            steps {
                    withDockerRegistry(credentialsId: 'dockerhub-cred') {                     
                       sh 'docker run -d -p 3000:3000 --name frontend abhimj23/techverito-frontend:01 '
               }
            }
        }
        
    }
}
