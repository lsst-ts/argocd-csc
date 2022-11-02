# rubintv-broadcaster

A Helm chart for deploying the RubinTV broadcaster services.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | This specifies the scheduling constraints of the pod. |
| butlerSecret | object | `{}` | This section allows for specification of Butler secret information. If this section is used, it must contain the following attributes: _key_ (The vault key for the Butler secret), _containerPath_ (The directory location for the Butler secret), _dbUser_ (The username for the Butler backend database) |
| credentialFile | string | `""` | The name of the expected credential file for the broadcasters |
| credentialSecretsPath | string | `""` | The key for the credentials including any sub-paths. |
| env | object | `{}` | This section holds a set of key, value pairs for environmental variables (ENV_VAR: value). NOTE: RUN_ARG is taken care of by the chart using _script_. |
| fullnameOverride | string | `""` | Specify the deployed application name specifically. Overrides all other names. |
| image.pullPolicy | string | `"IfNotPresent"` | The policy to apply when pulling an image for deployment. |
| image.repository | string | `"ts-dockerhub.lsst.org/rubintv-broadcaster"` | The Docker registry name for the container image. |
| image.tag | string | `"develop"` | The tag of the container image to use. |
| imagePullSecrets | list | `[]` | The list of pull secrets needed for the images. If this section is used, each object listed can have the following attributes defined: _name_ (The label identifying the pull-secret to use) |
| nameOverride | string | `""` | Adds an extra string to the release name. |
| namespace | string | `"rubintv-broadcaster"` | This is the namespace where the applications will be deployed. |
| nfsMountpoint | list | `[]` | This section holds the information necessary to create a NFS mount for the container. If this section is used, each object listed can have the following attributes defined: _name_ (A label identifier for the mountpoint), _containerPath_ (The path inside the container to mount), _readOnly_ (This sets if the NFS mount is read only or read/write), _server_ (The hostname of the NFS server), _serverPath_ (The path exported by the NFS server) |
| nodeSelector | object | `{}` | This allows the specification of using specific nodes to run the pod. |
| podAnnotations | object | `{}` | This allows the specification of pod annotations. |
| pullSecretsPath | string | `""` |  |
| resources | object | `{}` | This allows the specification of resources (CPU, memory) requires to run the container. |
| scripts | list | `[]` | List of the script to run for the broadcaster. |
| tolerations | list | `[]` | This specifies the tolerations of the pod for any system taints. |
| vaultPrefixPath | string | `""` | The Vault prefix path |
