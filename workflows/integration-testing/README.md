# integration-testing

Helm chart for Integration Testing Workflows.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| image.tag | string | `nil` | The image tag for the Integration Test runner container |
| namespace | string | `"dds-test"` | Namespace where the Workflow related APIs will be created. |
| persistentVolume.claimName | string | `"saved-reports"` | PVC name for saving the reports |
| persistentVolume.storage | string | `"1Gi"` | Storage size request for the PVC |
| reportLocation | string | `"/home/saluser/robotframework_EFD/Reports"` | Container location of the RobotFramework reports |
| s3Bucket | string | `nil` | The S3 bucket name to use |
| s3Endpoint | string | `nil` | The URL for the S3 instance |
| serviceAccount | string | `"integration-tests"` | This sets the service account name |
| siteTag | string | `nil` | The site tag for the resource location |
| workflowName | string | `"integration-test-workflow"` | Name for the top-level workflow |
