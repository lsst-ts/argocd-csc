# cluster-config

A Helm chart for handling CSC cluster configuration.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| namespaces | list | `["auxtel","calsys","eas","love","maintel","obssys","kafka-producers","ospl-daemon","dds-test"]` | List of namespaces to create for the Kubernetes cluster. |
| secrets | object | `{}` | This section holds secret specifications. This is a dictionary object that uses the following convention: namespace: "secret_name" if a secret is needed namespace: "" if a secret is not needed Pull secrets are created by default. |
| vaultPathPrefix | string | `""` | Site-specific Vault path for secrets. |
