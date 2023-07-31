pipeline {

    agent any

    tools{
        jdk "Java17"
    }

    environment {
        NEXUS_URL  = '172.32.5.240:5050'
        IMAGE_URL_WITH_TAG = "${NEXUS_URL}/sbr-fbe-service:${currentBuild.number}"
    }

    stages {      

        stage('Code Review') {
        steps{
          withMaven(maven: 'MAVEN_HOME') {
            withSonarQubeEnv('SonarQube') {
              sh "mvn clean verify sonar:sonar"
              }
            }
          }   
      }            

        stage('Image Build') {
            steps {
                sh "docker build . -t ${IMAGE_URL_WITH_TAG}"
            }
        }


        stage('Push to Image Registry') {
            steps {
                withCredentials([string(credentialsId: 'nexus-pwd', variable: 'nexusPwd')]) {
                    sh "docker login -u admin -p ${nexusPwd} ${NEXUS_URL}"
                    sh "docker push ${IMAGE_URL_WITH_TAG}"
                }
            }
        }


        stage('Sending Deployment Artifacts to smartbranch-uat-122') {
            steps {
                sh 'chmod +x changeTag.sh'
                sh "./changeTag.sh ${currentBuild.number}"

                sshPublisher(publishers: [sshPublisherDesc(configName: 'smartbranch-uat-122', transfers: [sshTransfer(cleanRemote: false, excludes: '', execCommand: '', flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: '/pipelines/sbr-fbe-service/', remoteDirectorySDF: false, removePrefix: '', sourceFiles: '*.yml')], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: false)])                
            }
        }

        stage('Deployment in smartbranch-uat-122') {
            steps {
               sshPublisher(publishers: [sshPublisherDesc(configName: 'smartbranch-uat-122', transfers: [sshTransfer(cleanRemote: false, excludes: '', execCommand: 'docker login -u admin -p Crdb2021 172.32.5.240:5050 && docker stack deploy -c /home/smbroot/pipelines/sbr-fbe-service/docker-compose.yml sbr-fbe-service --with-registry-auth', flatten: false, makeEmptyDirs: false, noDefaultExcludes: false, patternSeparator: '[, ]+', remoteDirectory: '', remoteDirectorySDF: false, removePrefix: '', sourceFiles: '')], usePromotionTimestamp: false, useWorkspaceInPromotion: false, verbose: false)])
            }
        }


    }
}
