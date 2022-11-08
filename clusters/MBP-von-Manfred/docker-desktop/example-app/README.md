# Example app

## Create Tnant

```sh
flux create tenant example-app \
  --with-namespace=example-app-dev \
  --with-namespace=example-app-staging \
  --with-namespace=example-app-production \
  --cluster-role=example-app-full-access \
  --export > ./clusters/MBP-von-Manfred/docker-desktop/example-app/flux-tenant.yaml
```
