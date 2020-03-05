region = "us-central1"
project_name = "managedkube"

# regional cluster with 3 masters use the region with the zone (eg. us-central1).  This cost $0.10/hour.
# zonal cluster that has only one master and in one zone.  Add the zone to the region. (eg. us-central1-a).  There is no GCP charge for this.
google_container_cluster_location = "us-central1-a"