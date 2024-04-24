pipeline {
    agent any
    
    tools{
        jdk 'jdk17'
        maven 'maven3'
    }
    
    environment{
        SCANNER_HOME = tool 'sonar-scanner'
        AWS_CRED = credentials('oguzbeliren1')
        APP_NAME = "gamestop"
        AWS_REGION = "us-east-1"
        ANS_KEYPAIR = "${APP_NAME}-dev-${BUILD_NUMBER}.key"
    }
    
    stages {
        stage('git-checkout') {
            steps {
                git branch: 'main', credentialsId: 'git-access', url: 'https://github.com/markquest/gamestop.git'
            }
        }
    
        stage('mvn-compile') {
            steps {
                sh 'mvn compile'
            }
        }
    
    
        stage('mvn-test') {
            steps {
                sh 'mvn test'
            }
        }
        
        stage('trivy file sytem') {
            steps {
                sh 'trivy fs --format table -o trivy-fs-report.html .'
            }
        }
        
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonar') {
                    sh ''' $SCANNER_HOME/bin/sonar-scanner -Dsonar.projectName=BoardGame -Dsonar.projectKey=BoardGame \
                            -Dsonar.java.binaries=.
                    '''
                                          }
                
                  }
                                    }
    
        stage('Quality Gate') {
            steps {
                script {
                    waitForQualityGate abortPipeline: false, credentialsId: 'sonar-token'
                        }
                  }
                              }
                              
        stage('mvn-build') {
            steps {
                sh 'mvn package'
            }
        }
        
        
        stage('Nexus Repostory Push') {
            steps {
                withMaven(globalMavenSettingsConfig: 'global-settings', jdk: 'jdk17', maven: 'maven3', mavenSettingsConfig: '', traceability: true) {
                        sh "mvn deploy"
                                                                                                                                                    }
                  }
                                      }
                                      
        
        stage('docker image build') {
            steps {
               script {
                   // This step should not normally be used in your script. Consult the inline help for details.
                    withDockerRegistry(credentialsId: 'dockerhub-access', toolName: 'docker') {
                              sh "docker build -t markquest/gamestop:latest ."
                                                                                              }
                      }
                
                  }
                                    }
                                      
                                      
        stage('trivy image scan') {
            steps {
                sh 'trivy image --format table -o trivy-fs-report.html markquest/gamestop:latest'
            }
        }
        
        
        stage('docker image push ') {
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
