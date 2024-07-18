# hexapodsim

Chart for the hexapod simulator that supports the ATHexapod

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| image | object | `{"nexus3":"pull-secret","pullPolicy":"Always","repository":"ts-dockerhub.lsst.org/hexapod_simulator","tag":"latest"}` | This section holds the configuration of the container image |
| image.nexus3 | string | `"pull-secret"` | The tag name for the Nexus3 Docker repository secrets |
| image.pullPolicy | string | `"Always"` | The policy to apply when pulling an image for deployment |
| image.repository | string | `"ts-dockerhub.lsst.org/hexapod_simulator"` | The Docker registry name of the container image |
| image.tag | string | `"latest"` | The tag of the container image |
| namespace | string | `"auxtel"` | This is the namespace in which the hexapod controller simulator will be placed |
