# ocps-uws-job

Collector application for OCPS UWS Jobs

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| spec.destination.server | string | `"https://kubernetes.default.svc"` | The URL for the Kubernetes server |
| spec.source.repoURL | string | `"https://github.com/lsst-ts/argocd-csc"` | The repository URL that contains the configuration |
| spec.source.targetRevision | string | `"u/mareuter/make_uws_job_app"` | The target revision (repository branch) to use for the configuration |
