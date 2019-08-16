logstash-input-s3-container
============================

Logstash container setup to pull Flowlogs from S3 and insert it into Elasticsearch.




# sincedb file
This file controls the last point the data was collected.

Format:
```
bash-4.2$ cat /sincedb/sincedb_file
2019-07-05 12:59:23 UTC
```

It is possible to manually manipulate this file and set it back or forward to
a time when you want Logstash to collect from.

For example, if you have been emitting Flowlogs to S3 for months and only want
to start ingestion from today.  You can set this to today's date instead of leaving
it which then Logstash will start ingesting from the first date it finds.
