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
        HOME = "/tmp"
      }
      agent {
        docker {
          image 'maven:3-alpine'
        }
      }
      steps {
        sh('echo -e "login=${GITHUB_USR}\npassword=${GITHUB_PSW}\n" > ~/.github')
        sh('mvn io.jenkins.tools.incrementals:incrementals-maven-plugin:updatePluginsTxt -DpluginsFile=plugins.txt')
      }
    }

    stage('build image') {
      agent any

      steps {
        script {
          docker.withRegistry("https://registry.hub.docker.com/","81012788-1be1-49e4-bfab-a882101f0442") {
            docker.build("blueocean/blueocean:ci-blueocean-io").push()
          }
        }
      }
    }
  }
}
