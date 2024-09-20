pipeline {
    agent any
    
    tools {
       nodejs 'node14.17'
    }
 
    environment {
          SCANNER_HOME = tool  'sonar-scanner'
        }

    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'frontend', changelog: false, poll: false, url: 'https://github.com/AbhiMJ23/techverito.git'
            }
        }
        
        stage('Sonarqube Analysis') {
            steps {
                withSonarQubeEnv {
                    sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=techveritoFrontend -Dsonar.projectKey=techveritoFrontend
                               -Dsonar.project.sources=. '''
                }
            }
        }
        
        stage('Trivy File Scan') {
            steps {
                sh 'trivy fs --format table -o trivy-filescanFrontend-report.html . '
            }
        }
        
        stage('NPM Package install') {
            steps {
               sh '''cd frontend
                     npm install'''
            }
        }
                 
        stage('Docker Image build and Push') {
            steps {
                withDockerRegistry(credentialsId: 'dockerhub-cred', url: 'https://index.docker.io/v1/') {
                 sh ''' docker build -t abhimj23/techverito-frontend:$BUILD_NUMBER .
                        docker push abhimj23/techverito-frontend:$BUILD_NUMBER
               }
            }
        }
        
        stage('Trivy Image Scan') {
            steps {
                sh 'trivy image --format table -o trivy-frontendimage-scan-report$BUILD_NUMBER.html abhimj23/techverito-frontend:$BUILD_NUMBER'
            }
        }
       
        stage('Container Deployment Frontend') {
            agent{
                label 'backend'
            }
            steps {
                    withDockerRegistry(credentialsId: 'dockerhub-cred', url: 'https://index.docker.io/v1/') {                     
                       sh 'docker run -d -p 3000:3000 --name frontend$BUILD_NUMBER abhimj23/techverito-frontend:$BUILD_NUMBER '
               }
            }
        }
        
    }
}
