# Cert-Manager

## Create helm repo source

```sh
flux create source helm cert-manager \
--url https://charts.jetstack.io \
--namespace cert-manager \
--interval=1m0s \
--export > clusters/MBP-von-Manfred/docker-desktop/cert-manager/helm-repo.yaml
```

## create helmrelease

```sh
flux create helmrelease cert-manager \
--namespace cert-manager \
--source HelmRepository/cert-manager \
--chart cert-manager \
--chart-version v1.9.1 \
--target-namespace cert-manager \
--create-target-namespace \
--values ./helm/cert-manager/values.yaml \
--export > clusters/MBP-von-Manfred/docker-desktop/cert-manager/helm-release.yaml
```
