# MongoDB Atlas Alerts
This module is here to help you add in a list of alerts and it also recreates all of the
default MongoDB Atlas alerts.  The reason to recreate it is to allow you to setup the
notifications for all of these alerts with Terraform.  Currently there is no way to
set those alerts with default notification without going into each one and setting it.


## var.default_alerts
The default alerts are the set of alerts that Mongo Atlas provides to your project when
you create it.  These are basic standard alerts applicable to any installation

## Creating a Mongo Atlas API key

https://www.mongodb.com/docs/atlas/configure-api-access/#create-an-api-key-for-a-project


## Creating the list of default alerts
Since we have to translate the alerts in the GUI to terraform/API configuration, the
easiest way is to get the list of alerts:

Mongo API to get the list of alerts:
```
curl --user "${MONGODB_ATLAS_PUBLIC_KEY}:${MONGODB_ATLAS_PRIVATE_KEY}" --digest \
  --header 'Accept: application/json' \
  --include \
  --request GET "https://cloud.mongodb.com/api/atlas/v1.0/groups/61e2162831a32a210d907b76/alertConfigs?pretty=true"
```

