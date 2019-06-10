node("docker") {
    deleteDir()
    stage('build blueocean') {
        dir("blueocean") {
            git url: 'https://github.com/jenkinsci/blueocean-plugin.git', branch: "master"
            sh 'git log -n 1 --pretty=format:"%H" > ../revision'
            sh 'docker build -t blueocean_build_env --build-arg GID=$(id -g ${USER}) --build-arg UID=$(id -u ${USER}) - < Dockerfile.build'
            docker.image('blueocean_build_env').inside {
                withEnv(['GIT_COMMITTER_EMAIL=me@hatescake.com','GIT_COMMITTER_NAME=Hates','GIT_AUTHOR_NAME=Cake','GIT_AUTHOR_EMAIL=hates@cake.com']) {
                    sh "mvn clean install -B -DcleanNode -Dmaven.test.failure.ignore"
                    step([$class: 'JUnitResultArchiver', testResults: '**/target/surefire-reports/TEST-*.xml'])
                }
            }
        }
    }

    stage('build image') {
        dir("image"){
            git(branch: 'use-lts-image', url: 'https://github.com/cloudbees/blueocean-docker-image.git')
            sh "mkdir -p plugins"
            sh "cp ../blueocean/*/target/*.hpi plugins"
            sh "rename 's/\$/.override/' plugins/*.hpi"
            docker.withRegistry("https://registry.hub.docker.com/","81012788-1be1-49e4-bfab-a882101f0442") {
                image = docker.build("blueocean/blueocean:latest")
                image.push()
            }
        }
    }
    trackDeploy()
}
