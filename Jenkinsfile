pipeline {
    agent any
    environment {
    APP_NAME = "test app name"
    IMAGE_NAME = "ghcr.io/potjamanp/imcworkshop"
    } 
    stages {
        stage('Build Image' ) {
            steps {
                sh "echo ${env.APP_NAME}"
            }
        }
        stage('Build Stage Docker' ) {
            agent {label 'build-server'}
            steps {
                sh "docker build -t ${env.IMAGE_NAME} ."
            }
        }
        stage('Deliver Docker Image') {
            agent {label 'build-server'}
            steps {
                withCredentials(
                [usernamePassword(
                    credentialsId: 'potjamanp',
                    passwordVariable: 'githubPassword',
                    usernameVariable: 'githubUser'
                )]
                ){
                    sh "docker login ghcr.io -u ${env.githubUser} -p ${env.githubPassword}"
                    sh "docker tag ${env.IMAGE_NAME} ${env.IMAGE_NAME}:${env.BUILD_NUMBER}"
                    sh "docker push ${env.IMAGE_NAME}"
                    sh "docker push ${env.IMAGE_NAME}:${env.BUILD_NUMBER}"
                    sh "docker rmi ${env.IMAGE_NAME}"
                    sh "docker rmi ${env.IMAGE_NAME}:${env.BUILD_NUMBER}"
                }
            }
        }
        stage('Deploy Stage (K8s)'){
            agent {label 'deploy-server'}
            steps {
                script {
                    try {
                          sh "kubectl delete -f deploy-web.yml"
                        } catch (e){
                            sh "echo can't delete , please check!"
                        }
                    sh "kubectl apply -f deploy-web.yml"
                }
            }
        }
    }
}