# audio-broadcaster

Helm chart for the ts_audio_broadcaster.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Affinity rules for the ts_audio_broadcaster pods |
| env | object | `{"WEBSERVER_PORT": 8888}` | This section holds a set of key, value pairs for environmental variables |
| image.nexus3 | string | `"nexus3-docker"` | The tag name for the Nexus3 Docker repository secrets if private images need to be pulled |
| image.pullPolicy | string | `"IfNotPresent"` | The pull policy on the ts_audio_broadcaster image |
| image.repository | string | `"lsstts/audio-broadcaster"` | The ts_audio_broadcaster image to use |
| image.tag | string | `"develop"` | The tag to use for the ts_audio_broadcaster image |
| namespace | string | `"love"` | The overall namespace for the ts_audio_broadcasters |
| nodeSelector | object | `{}` | Node selection rules for the ts_audio_broadcaster pods |
| podAnnotations | object | `{}` | This allows the specification of pod annotations. |
| microphones | object | `{}` | This sections sets the list of microphones to use. Each microphone should be an object with host and port params |
| replicaCount | int | `1` | Set the replica count for the ts_audio_broadcasters |
| resources | object | `{}` | Resource specifications for the ts_audio_broadcaster pods |
| tolerations | list | `[]` | Toleration specifications for the ts_audio_broadcaster pods |
