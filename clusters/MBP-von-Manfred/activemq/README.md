# ActiveMQ deployment via Flux

## Create the helm repo

```sh
flux create source helm activemq \
--url https://github.com/disaster37/activemq-kube/tree/master/deploy/helm \
--namespace flux-system \
--export > clusters/MBP-von-Manfred/activemq/helm-repo.yaml
```

## create helmrelease

```sh
flux create helmrelease activemq \
--srouce HelmRepository/activemq \
--chart activemq \
--target-namespace activemq-system \
--create-target-namespace \
--namespace flux-system \
--values helm/activemq/values.yaml \
--export > clusters/MBP-von-Manfred/activemq/helm-release.yaml
```
