# GitOps with FLUX

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

Add gitrepository

```sh
flux create source git flux-monitoring \
  --interval=30m \
  --url=https://github.com/fluxcd/flux2 \
  --branch=main \
  --namespace=flux-system \
  --export > clusters/MBP-von-Manfred/docker-desktop/monitoring/git-source.yaml
```

Create Prometheus stack

```sh
flux create kustomization kube-prometheus-stack \
  --interval=1h \
  --namespace flux-system \
  --prune \
  --source=flux-monitoring \
  --path="./manifests/monitoring/kube-prometheus-stack" \
  --health-check-timeout=5m \
  --target-namespace=monitoring \
  --export > clusters/MBP-von-Manfred/docker-desktop/monitoring/kustonize.yaml
```

Install loki stack

```sh
flux create kustomization loki-stack \
  --depends-on=kube-prometheus-stack \
  --interval=1h \
  --prune \
  --source=flux-monitoring \
  --path="./manifests/monitoring/loki-stack" \
  --health-check-timeout=5m \
  --export > clusters/MBP-von-Manfred/docker-desktop/monitoring/loki.yaml
```

Install Grafana Dashboards

```sh
flux create kustomization monitoring-config \
  --depends-on=kube-prometheus-stack \
  --interval=1h \
  --prune=true \
  --source=flux-monitoring \
  --path="./manifests/monitoring/monitoring-config" \
  --health-check-timeout=1m \
  --export > clusters/MBP-von-Manfred/docker-desktop/monitoring/grafana-dashboards.yaml
```

Test the monitoring

```sh
kubectl -n monitoring port-forward svc/kube-prometheus-stack-grafana 3000:80

open http://127.0.0.1:3000
```

## Example App using kustomize

### Stage DEV

Create the github source

```sh
flux create source git example-app-dev \
  --interval=30m \
  --url=https://github.com/mkoellges/example-app.git\
  --branch=dev \
  --namespace=flux-system \
  --export > clusters/MBP-von-Manfred/docker-desktop/example-app-dev/git-source.yaml
```

```sh
flux create kustomization example-app-dev \
 --interval=1h \
 --prune=true \
 --source=example-app-dev \
 --path="./overlay/dev" \
 --target-namespace=example-app-dev \
 --health-check-timeout=1m \
 --export > clusters/MBP-von-Manfred/docker-desktop/example-app-dev/kustomize.yaml
```
