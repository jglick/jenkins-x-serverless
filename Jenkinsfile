pipeline {
    agent any
    environment {
      ORG               = 'garethjevans'
      APP_NAME          = 'jenkins-x-oneshot-masters'
      GIT_PROVIDER      = 'github.com'
      CHARTMUSEUM_CREDS = credentials('jenkins-x-chartmuseum')
    }
    stages {
      stage('CI Build and push snapshot') {
        when {
          branch 'PR-*'
        }
        environment {
          PREVIEW_VERSION = "0.0.0-SNAPSHOT-$BRANCH_NAME-$BUILD_NUMBER"
          PREVIEW_NAMESPACE = "$APP_NAME-$BRANCH_NAME".toLowerCase()
          HELM_RELEASE = "$PREVIEW_NAMESPACE".toLowerCase()
        }
        steps {
          checkout scm
          sh "make build"
          sh 'export VERSION=$PREVIEW_VERSION'
          sh './jx-docker-build.sh $VERSION $ORG'
        }
      }
      stage('Build Release') {
        when {
          branch 'master'
        }
        steps {
          git 'https://github.com/garethjevans/jenkins-x-oneshot-masters.git'
          sh "git config --global credential.helper store"
          sh "jx step validate --min-jx-version 1.1.73"
          sh "jx step git credentials"
          sh "echo \$(jx-release-version) > VERSION"
          sh "make build"
          sh 'export VERSION=`cat VERSION`'
          sh "jx step validate --min-jx-version 1.2.36"
          sh './jx-docker-build.sh $VERSION $ORG'
        }
      }
    }
  }
