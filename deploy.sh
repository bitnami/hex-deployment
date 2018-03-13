#!/usr/bin/env bash

# Get the current git hash
K8S_ENV=${K8S_ENV:-development}
REPO_GIT_HASH=`git rev-parse origin/master`
IMAGE=gcr.io/bitnami-containers/hex-docs-$K8S_ENV:$REPO_GIT_HASH

# Build the new image to production
if [ "$SKIP_IMAGE_BUILDING" != true ]; then
  echo "Building the image..."
  # Build the project
  dir=$(pwd)
  docker run --rm -v $dir:/scripts $(dirname "$dir"):/app /scripts/build.sh

  if [ $? -ne 0 ]; then
    echo "There was an error building the project. The deployment has been canceled."
    exit 1
  fi

  docker build -t $IMAGE -f deployment/Dockerfile .
  gcloud docker -- push $IMAGE
fi

# Update the deployment!
cp deployment/deployment.template deployment/deployment.yaml
SAFE_IMAGE_URL=$(echo "$IMAGE" | sed -e 's/\//\\\//g')
sed -i '' -e "s/PRODUCTION_IMAGE/$SAFE_IMAGE_URL/g" deployment/deployment.yaml

# Apply the changes
echo "Deploying..."
kubectl apply -f deployment/deployment.yaml
kubectl apply -f deployment/service.yaml
kubectl apply -f deployment/ingress.yaml
