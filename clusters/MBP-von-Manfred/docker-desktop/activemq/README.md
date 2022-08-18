# ActiveMQ deployment via Flux

## Create the helm repo

```sh
flux create source helm activemq-artemis \
--url https://deviceinsight.github.io/activemq-artemis-helm \
--namespace activemq-system \
--interval=1m0s \
--export > clusters/MBP-von-Manfred/activemq/helm-repo.yaml
```

## create helmrelease

```sh
flux create helmrelease activemq-artemis \
--source HelmRepository/activemq-artemis \
--chart artemis \
--target-namespace activemq-system \
--create-target-namespace \
--namespace activemq-system \
--values helm/activemq/values.yaml \
--export > clusters/MBP-von-Manfred/activemq/helm-release.yaml
```
