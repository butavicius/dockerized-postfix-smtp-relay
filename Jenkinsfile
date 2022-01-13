img = 'butavicius/wordpress-test'
repo = ''
prodServer = '107.152.35.191'

pipeline {
    agent any

    stages {
        stage('Build docker image') {
            when {
                branch 'main'
            }

            steps {
                sh("set +x; docker login --username \$DOCKER_USERNAME --password \$DOCKER_PASSWORD; set -x")
                sh("docker pull ${img}:latest || true")
                sh """
              docker build \
              --cache-from ${img}:latest \
              -t ${img}:latest \
              -f "./Dockerfile" \
              "."
             """
            }
        }
        stage('Deploy to Dockerhub') {
            when {
                branch 'main'
            }

            steps {
                sh("set +x; docker login --username \$DOCKER_USERNAME --password \$DOCKER_PASSWORD; set -x")
                sh("docker push ${img}:latest")
            }
        }
            stage('Deploy to server') {
                when {
                    branch 'main'
                }
                steps {
                    sh "echo 'files are following'"
                    sh "ls -al"
                    sh "ssh -o StrictHostKeyChecking=no jenkins@${prodServer} \
                    touch iwasheRe3.txt"
                }
            }
    }
}
