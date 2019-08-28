pipeline {
  agent none

  options {
    buildDiscarder(logRotator(numToKeepStr: '5', artifactNumToKeepStr: '5'))
    timeout(time: 60, unit: "MINUTES")
  }

  stages {
    stage('update incrementals') {
      environment {
        GITHUB = credentials("e1729308-6350-4c74-9537-91f8413129a7") 
        GITHUB_LOGIN = "${GITHUB_USR}"
        GITHUB_PASSWORD = "${GITHUB_PSW}"
      }
      agent {
        docker {
          image 'maven:3-alpine'
        }
      }
      steps {
        sh('mvn io.jenkins.tools.incrementals:incrementals-maven-plugin:updatePluginsTxt -DpluginsFile=plugins.txt')
      }
    }

    stage('build image') {
      agent any

      steps {
        withDockerRegistry("https://registry.hub.docker.com/","81012788-1be1-49e4-bfab-a882101f0442") {
          sh('docker build blueocean/blueocean:ci-blueocean-io && docker push')
        }
      }
    }
  }
}
