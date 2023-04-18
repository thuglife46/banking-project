pipeline {
    agent any

    tools {
        maven "maven"
    }

    stages {
        stage('Git checkout') {
            steps {
              
                   git 'https://github.com/thuglife46/banking-project.git'
            
                }
            }
        stage('maven build') {
              steps {
              
                     sh "mvn install package"
                }
        }
        
        stage('Publish HTML') {
              steps {
                    publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: '/var/lib/jenkins/workspace/banking-project/target/surefire-reports', reportFiles: 'index.html', reportName: 'project-02-HTML Report', reportTitles: '', useWrapperFileDirectly: true])
                }
        }
        
          stage('Docker build image') {
              steps {
                  
                  sh'sudo docker system prune -af '
                  sh 'sudo docker build -t thuglife46/bank-finance:${BUILD_NUMBER}.0 .'
              
                }
            }
                
        stage('Docker login and push') {
              steps {
                   withCredentials([string(credentialsId: 'docpass', variable: 'docpasswd')]) {
                  sh 'sudo docker login -u thuglife46 -p ${docpasswd} '
                  sh 'sudo docker push thuglife46/banking-project:${BUILD_NUMBER}.0 '
                  }
                }
        }    
                
        stage (' configuring Test-server with terraform & ansible and deploying'){
            steps{

                dir('test-server'){
                sh 'sudo chmod 600 DEMOKEY.pem'
                sh 'terraform init'
                sh 'terraform validate'
                sh 'terraform apply --auto-approve'
                }
               
            }
        }

        stage('waitng to start the app') {
              steps {
                  
                  sh ' sleep 40'
                           
                }
            }
       
        stage('Selenium test') {
              steps {
                  
                  sh 'sudo java -jar seleniumbank.jar'
                  sh"echo 'application is logged in succussfully done' "
                           
                }
            }
          
         stage ('setting Prod-Server with terraform and ansible'){
            steps{
                
                dir('prod-server'){
                sh 'chmod 600 DEMOKEY.pem'
                sh'terraform init'
                sh'terraform validate'
                sh'terraform apply --auto-approve'
            }
        }
         }

        
    }
}
