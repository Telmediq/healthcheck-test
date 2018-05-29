properties([
    pipelineTriggers([
        [$class: "GitHubPushTrigger"]
    ])
])

def projectName = 'smartcall'
def buildLock = "${projectName}_${env.BRANCH_NAME}"

pipeline {
    options {
        ansiColor('xterm')
    }

    agent {
        label('ec2-dynamic')
    }

    environment {
        AWS = credentials('jenkins-docker-build')
        COMPOSE_PROJECT_NAME = "${projectName}x${env.GIT_COMMIT}"
        BRANCH_NAME = "${env.BRANCH_NAME}"
        GIT_COMMIT = "${env.GIT_COMMIT}"
        BUILD_NUMBER = "${env.BUILD_NUMBER}"
    }

    stages {
        stage('Build') {
            steps {
                lock(resource: buildLock, inversePrecedence: true) {
                    sh '''
                        export AWS_ACCESS_KEY_ID=$AWS_USR
                        export AWS_SECRET_ACCESS_KEY=$AWS_PSW

                        make build
                    '''
                    milestone(10)
                }
            }
        }

        stage('Publish') {
            when {
                expression {
                    return env.BRANCH_NAME ==~ /(master)/
                }
            }
            steps {
                sh '''
                    export AWS_ACCESS_KEY_ID=$AWS_USR
                    export AWS_SECRET_ACCESS_KEY=$AWS_PSW
                    make publish
                '''
                milestone(60)
            }
        }
    }
}
