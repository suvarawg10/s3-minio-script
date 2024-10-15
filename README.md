# s3-minio-script
s3 to minio replication script
#!/bin/bash
mc alias set s3-bucket https://s3.amazonaws.com <access-key> <secret-key>
mc alias set ecos-bucket https://minio.mydomain.com <access-key> <secret-key>
sh bucket-migration.sh > run.log 2>&1

#cron lines

#whole bucket
30 * * * * sh /root/bucket-data-migration/bucket-migration_cron.sh bucket-1 > /root/data-migration-log/run.log 2>&1
#bucket folder
30 * * * * sh /root/bucket-data-migration/bucket-migration_cron.sh bucket-2/folder-1 > /root/data-migration-log/run.log 2>&1
