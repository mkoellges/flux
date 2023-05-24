# Bootstrap Flux

```sh
export GITHUB_TOKEN=$(pass github.com/fluxcd/GITHUB_TOKEN)

flux bootstrap github \
--owner=mkoellges \
--repository=flux \
--branch=main \
--path=./clusters/MBP-von-Manfred/docker-desktop \
--personal
```
