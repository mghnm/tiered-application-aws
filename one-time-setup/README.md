Terraform back-end bucket creation with dynamo-db lock set.


Back-end corruption recovery/mitigation strategy:

S3 Versioning takes snapshots of the bucket object as backups in the same region.
We can have cross region S3 backup.