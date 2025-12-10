pipeline {
    agent any
    tools{
        maven 'maven3'
    }
    environment{
        SCANNER_HOME = tool 'sonar-scanner'
}
    stages {
        stage('git checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/ChinthalpelliSreyaReddy/docker-helm-jenkins-springboot.git'
            }
        }
        stage('build stage') {
            steps {
                sh 'mvn clean install'
            }
        }
        stage('sonarqube analysis') {
            steps {
                 withSonarQubeEnv('sonar-server') {
                sh '''
                ${SCANNER_HOME}/bin/sonar-scanner \
                -Dsonar.projectName=sreya \
                -Dsonar.projectKey=sreya  \
                -Dsonar.java.binaries=target/classes
                '''
            }
        }
       
       }
       stage('docker build &tag') {
            steps {
                script{
                    withDockerRegistry(credentialsId: 'docker_cred') {

                    sh ' docker build -t sreyaapp .'
                    sh ' docker tag sreyaapp chinthalpellisreya/sreyaapp:latest'
                }
                
                }
            }
            }
            
            stage('docker push') {
            steps {
                script{
                    withDockerRegistry(credentialsId: 'docker_cred') {
                    sh 'docker push chinthalpellisreya/sreyaapp:latest'
                }
                
               }
            }
           }
           stage('trivy scan') {
            steps {
                sh 'trivy fs . > trivyreport.txt'
            }
        }
             stage('docker run') {
            steps {
                script{
                   
                    sh 'docker run -d -p 9090:8080 chinthalpellisreya/sreyaapp:latest'
                    
                }
                
                }
            }
        }
    
    post{
        always{
            cleanWs()
        }
    }
}
