acrUrl = 'butavicius' // container registry account
app = 'wordpress-test' // application name

img = "${acrUrl}/${app}"

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
                withCredentials([sshUserPrivateKey(credentialsId: '1f6af17f-a4a8-404f-83b1-1084a3eed6a2', keyFileVariable: 'keyfile')]) {
                    steps {
                        sh "ssh -o StrictHostKeyChecking=no -i ${keyfile} jenkins@107.152.35.191"
                        sh 'touch iwashere.txt'
                        sh 'exit'
                    }
                }
            }

        // stage('Deploy to Kubernetes') {
        //     when {
        //         branch 'master'
        //     }

    //     steps {
    //         container('kubectl') {
    //             sh """
    //      helm upgrade --install ${team}-${app} ./helm/deployment \
    //      -f ./helm/values.yaml --namespace ${team} \
    //      --set nameOverride=${app} \
    //      --set container.image=${img} \
    //      --set service.ingress.hostname=${hostname} \
    //      --set service.ingress.paths[0]=/api
    //       """
    //         }
    //     }
    // }
    }
}
