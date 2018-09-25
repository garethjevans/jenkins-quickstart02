#!/bin/bash

set -e
set -u
set -o pipefail

ORG=garethjevans
TAG=$1

TEAM=$(basename ${PWD})
echo "TEAM=${TEAM}"

if [ -f Dockerfile ]; then
  BUILD_TAG=${ORG}/${TEAM}:${TAG}
  docker build -t ${BUILD_TAG} .
  docker push ${BUILD_TAG}
fi

if [ -f Chart.yaml ]; then
  sed -i "" -e "s/ImageTag: .*/ImageTag: \"${TAG}\"/" values.yaml
  rm -fr charts
  helm init --client-only
  helm lint
  helm dependency update
  helm template .
fi
