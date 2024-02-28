# nightreport

Helm chart for the nightreport.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Affinity rules for the ts_nightreport pods |
| config | object | `{"site_id":""}` | Application-specific configuration |
| config.site_id | string | `""` | Site ID; a non-empty string of up to 16 characters. This should be different for each non-sandbox deployment. Sandboxes should use `test`. |
| db | object | `{"database":"nightreport","host":"postgres.postgres","port":5432,"user":"nightreport"}` | This section holds a list of database connection parameters |
| db.database | string | `"nightreport"` | database name |
| db.host | string | `"postgres.postgres"` | database host |
| db.port | int | `5432` | database port |
| db.user | string | `"nightreport"` | database user |
| fullnameOverride | string | `""` | Specify the deployed application name specifically. Overrides all other names. |
| image.nexus3 | string | `"nexus3-docker"` | The tag name for the Nexus3 Docker repository secrets if private images need to be pulled |
| image.pullPolicy | string | `"IfNotPresent"` | The pull policy on the ts_nightreport image |
| image.repository | string | `"lsstts/nightreport"` | The ts_nightreport image to use |
| image.tag | string | `"develop"` | The tag to use for the ts_nightreport image |
| ingress.annotations | object | `{}` | Annotations for the ts_nightreport ingress |
| ingress.className | string | `"nginx"` | Assign the Ingress class name |
| ingress.hostname | string | `"nightreport.local"` | Hostname for the ts_nightreport ingress |
| ingress.httpPath | string | `"/"` | Path name associated with the ts_nightreport ingress |
| ingress.pathType | string | `"Exact"` | Set the Kubernetes path type for the ts_nightreport ingress |
| nameOverride | string | `""` | Adds an extra string to the release name. |
| namespace | string | `"nightreport"` | The overall namespace for the ts_nightreport |
| nodeSelector | object | `{}` | Node selection rules for the ts_nightreport pods |
| podAnnotations | object | `{}` | This allows the specification of pod annotations. |
| ports.container | int | `80` | Container port for the ts_nightreport service (to be accessed from the outside) |
| ports.node | int | `30000` | Node port for the ts_nightreport service |
| ports.service | int | `8000` | Service port for the ts_nightreport service (to be accessed from within the cluster) |
| pullSecretsPath | string | `""` |  |
| resources | object | `{}` | Resource specifications for the ts_nightreport pods |
| secretsPath | string | `""` |  |
| serviceType | string | `"ClusterIP"` | Service type specification |
| tolerations | list | `[]` | Toleration specifications for the ts_nightreport pods |
| vaultPrefixPath | string | `""` | The Vault prefix path |
