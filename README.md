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
--path=./clusters/MBP-von-Manfred/docker-desktop \
--personal
```

## Deploy ingress-nginx using helm controller

In this example I install the starboard kubernetes logging using helm.

```sh
flux create source helm ingress-nginx \
--url https://kubernetes.github.io/ingress-nginx \
--namespace flux-system \
--export > clusters/MBP-von-Manfred/docker-desktop/ingress-nginx/helm-chart.yaml
```

```sh
flux create helmrelease ingress-nginx \
--source HelmRepository/ingress-nginx \
--chart ingress-nginx \
--chart-version 4.1.4 \
--target-namespace ingress-nginx \
--create-target-namespace \
--namespace flux-system \
--values helm/ingress-nginx/values.yaml \
--export > clusters/MBP-von-Manfred/docker-desktop/ingress-nginx/helm-release.yaml
```

## Monitoring

```sh
flux create source git flux-monitoring \
  --interval=30m \
  --url=https://github.com/fluxcd/flux2 \
  --branch=main \
  --namespace=flux-system \
  -- export > clusters/MBP-von-Manfred/docker-desktop/monitoring/git-source.yaml
```
