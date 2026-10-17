pipeline {
    agent any

    options {
        disableConcurrentBuilds()
        buildDiscarder(logRotator(numToKeepStr: '10'))
    }

    stages {
        stage('Choose image') {
            steps {
                script {
                    if (!(env.BRANCH_NAME in ['dev', 'master'])) {
                        error('Only dev and master are supported')
                    }
                    def repository = env.BRANCH_NAME == 'master' ? 'prod' : 'dev'
                    env.APP_IMAGE = "desing96/${repository}:${env.BUILD_NUMBER}-${env.GIT_COMMIT.take(7)}"
                }
            }
        }

        stage('Build') {
            steps {
                sh 'bash build.sh "$APP_IMAGE"'
            }
        }

        stage('Push to Docker Hub') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-creds',
                    usernameVariable: 'HUB_USER',
                    passwordVariable: 'HUB_TOKEN'
                )]) {
                    sh '''
                        set +x
                        export DOCKER_CONFIG="$(mktemp -d)"
                        trap 'rm -rf "$DOCKER_CONFIG"' EXIT
                        printf '%s' "$HUB_TOKEN" |
                            docker login -u "$HUB_USER" --password-stdin
                        docker push "$APP_IMAGE"
                    '''
                }
            }
        }

        stage('Deploy production') {
            when {
                branch 'master'
            }
            steps {
                sh 'bash deploy.sh "$APP_IMAGE"'
                sh 'curl --fail --silent --show-error --retry 5 --retry-connrefused --retry-delay 2 http://localhost/ > /dev/null'
            }
        }
    }
}
