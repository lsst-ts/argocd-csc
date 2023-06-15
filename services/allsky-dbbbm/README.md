# allsky-dbbm

Chart for the All-Sky camera DBBBM

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | This specifies the scheduling constraints of the pod |
| annotations | object | `{}` | This allows the specification of pod annotations |
| configfile | object | `{}` | This key allows specification of a YAML configuration file If this section is used, it must contain the following attributes defined: _path_ (The container path for the configuration file), _filename_ (The configuration file name), _content_ (The YAML content for the configuration file) |
| image | object | `{"pullPolicy":"Always","repository":"lsstts/dbbbm","tag":"latest"}` | This section holds the configuration of the container image |
| image.pullPolicy | string | `"Always"` | The policy to apply when pulling an image for deployment |
| image.repository | string | `"lsstts/dbbbm"` | The Docker registry name of the container image |
| image.tag | string | `"latest"` | The tag of the container image |
| mgr.gid | int | `983` | Group id for the mgr account |
| mgr.uid | int | `1000` | User id for the mgr account |
| namespace | string | `"allsky-dbbbm"` | This is the namespace in which the All-Sky DBBM will be placed |
| nfsMountpoint | list | `[]` | This section holds the information necessary to create a NFS mount for the container. If this section is used, each object listed can have the following attributes defined: _name_ (A label identifier for the mountpoint), _path_ (The path inside the container to mount), _readOnly_ (This sets if the NFS mount is read only or read/write), _server_ (The hostname of the NFS server), _serverPath_ (The path exported by the NFS server) |
| nodeSelector | object | `{}` | This allows the specification of using specific nodes to run the pod |
| resources | object | `{}` | This allows the specification of resources (CPU, memory) requires to run the container |
| service.port | int | `nil` | The port number to use for the Service. |
| sshSecrets.containerPath | string | `"/tmp/.ssh"` | Temporary storage location within the container |
| storage.classname | string | `nil` |  |
| storage.path | string | `"/var/dbbbm"` | Container path for the storage claim |
| storage.request | string | `"1Gi"` | The size of the storage request. |
| tolerations | list | `[]` | This specifies the tolerations of the pod for any system taints |
| vaultPrefixPath | string | `""` | The Vault prefix path |
