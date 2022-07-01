# Flux - multi tenant

## First install

First of all, you can check that your Flux CLI is able to communicate with your Kubernetes cluster.
flux check --pre
Now you will perform the initial configuration of Flux.To do so, you must generate a Github token so that Flux is able to interact with your repository.
As you can see, we indicate two teams (dev1 and dev2) that will be allowed to access the Github repository.These teams must already exist in your Github organization.

```sh
export GITHUB_TOKEN=XXXXXXXXXXXXXXXXXXXXXXXXXXX
export GITHUB_USER="USERNAME"

flux bootstrap github \
--owner=$GITHUB_USER \
--repository=flux \
--branch=main \
--path=./clusters/MBP-von-Manfred.fritz.box/docker-desktop \
--personal
```

## Deploy using helm controller

In this example I install the starboard kubernetes logging using helm.
flux create source helm starboard-operator --url https://aquasecurity.github.io/helm-charts/ --namespace starboard-system

```sh
flux create helmrelease starboard-operator --chart starboard-operator \
  --source HelmRepository/starboard-operator \
  --chart-version 0.10.3 \
  --namespace starboard-system
```

## Deploy an application

First create a namespace:

```sh
kubectl create ns app
```

Now create the application by defining the gitrepository and the definition for the kustomization controller. These Repositories will be stored in the flux-system namespace. The application will be deployed in the targetNamespace - defined in the kustomization section of teh apllication.yaml.
kubectl apply -f examples/application.yaml
