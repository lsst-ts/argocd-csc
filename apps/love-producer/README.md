# love-producer

Helm chart for the LOVE producer.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Affinity rules for the LOVE producer pods |
| env | object | `{"LSST_DDS_PARTITION_PREFIX":"test","OSPL_ERRORFILE":"/tmp/ospl-error-love-producer.log","OSPL_INFOFILE":"/tmp/ospl-info-love-producer.log","WEBSOCKET_HOST":"love-nginx/manager/ws/subscription"}` | This section holds a set of key, value pairs for environmental variables |
| envSecrets | object | `{"PROCESS_CONNECTION_PASS":"process-connection-pass"}` | This section holds a set of key, value pairs for secrets |
| image.nexus3 | string | `"pull-secret"` | The tag name for the Nexus3 Docker repository secrets if private images need to be pulled |
| image.pullPolicy | string | `"IfNotPresent"` | The pull policy on the LOVE producer image |
| image.repository | string | `"lsstts/love-producer"` | The LOVE producer image to use |
| image.tag | string | `"develop"` | The tag to use for the LOVE producer image |
| namespace | string | `"love"` | The overall namespace for the LOVE producers |
| nodeSelector | object | `{}` | Node selection rules for the LOVE producer pods |
| osplVersion | string | `"V6.10.4"` | This is the version of the OpenSplice library to run. It is used to set the location of the OSPL configuration file |
| podAnnotations | object | `{}` | This allows the specification of pod annotations. |
| producers | object | `{}` | This sections sets the list of producers to use. The producers should be specified like: _name_: _CSC name:index_ Example: ataos: ATAOS:0 |
| replicaCount | int | `1` | Set the replica count for the LOVE producers |
| resources | object | `{}` | Resource specifications for the LOVE producer pods |
| shmemDir | string | `"/my/test"` | This is the path to the Kubernetes local store where the shared memory database will be written |
| tolerations | list | `[]` | Toleration specifications for the LOVE producer pods |
