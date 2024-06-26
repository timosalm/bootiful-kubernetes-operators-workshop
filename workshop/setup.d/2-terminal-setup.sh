#!/bin/bash
set -x
set +e

kubectl config set-context --current --namespace=default
kubectl create secret generic regcred --from-file=.dockerconfigjson=$REGISTRY_AUTH_FILE --type=kubernetes.io/dockerconfigjson

kubectl patch serviceaccount default -p '{"secrets": [{"name": "default-sa-token"}], "imagePullSecrets": [{"name": "regcred"}]}'
mv samples/foo-crd.yaml .

while (! docker stats --no-stream >/dev/null 2>&1); do
  echo "Waiting for Docker to launch..."
  sleep 1
done

# JVM image
docker pull docker.io/paketobuildpacks/builder:base
docker pull docker.io/paketobuildpacks/run:base-cnb

docker pull harbor.main.emea.end2end.link/tap-workshops/foo-controller-native
docker tag harbor.main.emea.end2end.link/tap-workshops/foo-controller-native $REGISTRY_HOST/foo-controller-native
docker push $REGISTRY_HOST/foo-controller-native
docker pull harbor.main.emea.end2end.link/tap-workshops/foo-controller
docker tag harbor.main.emea.end2end.link/tap-workshops/foo-controller $REGISTRY_HOST/foo-controller