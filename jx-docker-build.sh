#!/usr/bin/env bash
# Copyright 2018 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -o errexit
set -o nounset
set -o pipefail

TAG_NUM=$1
ORG=$2
TAG=dev_$TAG_NUM

echo "====================================="
docker -v
echo "====================================="

docker build -t $ORG/jenkins-filerunner:$TAG -f Dockerfile-filerunner .
echo "Built $ORG/jenkins-filerunner:$TAG"

docker build --build-arg JENKINS_BASE_TAG=$ORG/jenkins-filerunner:$TAG -t $ORG/jenkins-base:$TAG -f Dockerfile-base .
echo "Built $ORG/jenkins-base:$TAG"

declare -a arr=("maven" "javascript" "go" "gradle" "python" "scala" "rust" "csharp" "jenkins" "cwp")

## now loop through the above array
for i in "${arr[@]}"
do
    echo "building builder-$i"
    docker build --build-arg ORG=$ORG --build-arg BASE_TAG=$TAG -t $ORG/jenkins-$i:$TAG -f Dockerfile-$i .
done

#for i in "${arr[@]}"
#do
#    echo "pushing builder-$i"
#    docker push $ORG/jenkins-$i:$TAG
#done
