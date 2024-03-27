pipeline {
    agent any
    
    tools {
        jdk 'jdk17'
        maven 'maven3'
    }
    
    environment {
        SCANNER_HOME = 'sonar-scanner'
        AWS_CRED = credentials('oguzbeliren1')
        APP_NAME = "gamestop"
        AWS_REGION = "us-east-1"
        ANS_KEYPAIR = "${APP_NAME}-dev-${BUILD_NUMBER}.key"
    }
    stages {
        stage('Gir Checkout') {
            steps {
                git branch: 'main', credentialsId: 'github-access', url: 'https://github.com/markquest/gamestop.git'
            }
        }
        
        stage('Compile') {
            steps {
                sh "mvn compile"
            }
        }

        stage('Test') {
            steps {
                sh "mvn test"
            }
        }
    
        stage('File System Scan') {
            steps {
                sh "trivy fs --format table -o trivy-fs-report.html ."
            }
        }
        
        stage('Sonarqube Analysis') {
            steps {
                withSonarQubeEnv('sonar') {
                    sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=BoardGame -Dsonar.projectKey=BoardGame \
                            -Dsonar.java.binaries=. '''
                }
            }
        }
        
        stage('Quality Gate') {
            steps {
                script {
                    waitForQualityGate abortPipeline: false, credentialsId: 'sonar-access'
                }
            }
        }
        
        stage('Build') {
            steps {
                sh "mvn package"
            }
        }

        stage('Publish to nexus') {
            steps {
                withMaven(globalMavenSettingsConfig: 'global-settings', jdk: 'jdk17', maven: 'maven3', mavenSettingsConfig: '', traceability: true) {
                     sh "mvn deploy"
                }
            }
        }
        
        stage('Build And Tag Docker Image') {
            steps {
               script {
                   // Build the Docker image using the Dockerfile in the cloned repository
                   withDockerRegistry(credentialsId: 'dockerhub-access', toolName: 'docker') {
                       sh "docker build -t markquest/gamestop:latest ."
                    }
                }
            }
        }
        
        stage('Image Scan') {
            steps {
                sh "trivy image --format table -o trivy-fs-report.html markquest/gamestop:latest"
            }
        }
        
        stage('Push Docker Image To Docker Hub') {
            steps {
                script {
                    // This step should not normally be used in your script. Consult the inline help for details.
                    withDockerRegistry(credentialsId: 'dockerhub-access', toolName: 'docker') {
                        sh "docker push markquest/gamestop:latest"
                    }
                }
            }
        }
        
        stage('Create Key Pair for Ansible') {
            steps {
                echo "Creating Key Pair for ${APP_NAME} App"
                sh "aws ec2 create-key-pair --region ${AWS_REGION} --key-name ${ANS_KEYPAIR} --query KeyMaterial --output text > ${ANS_KEYPAIR}"
                sh "chmod 400 ${ANS_KEYPAIR}"
            }
        }
    }
}
