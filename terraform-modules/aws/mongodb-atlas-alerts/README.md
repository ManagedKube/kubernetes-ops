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

# Slack API Token

You can follow this doc to create the token: https://api.slack.com/authentication/basics

The token will be in the form of: `xoxb-xxxx-xxxxx-xxxxx`

## Testing the token
Get a list of the Slack channel:

```
curl https://slack.com/api/conversations.list -H "Authorization: Bearer <SLACK API TOKEN>"
```

You will need to get the channel string from this list and put it into the next request to send a message.

You will need to @ the bot and add the bot to the channel you want to send the message to.

Send a message to the channel:
```
curl -X POST -F channel=CGM7387SP -F text="test test" https://slack.com/api/chat.postMessage -H "Authorization: Bearer <SLACK API TOKEN>"
```

## TL;DR generating the API Token

Without having to read that entire doc =)

1. Create a new app “from scratch”
1. Name: MongoAtlasAlerting
1. Select the ExactPay workspace
1. Click on create app
1. This will bring you to the app’s management page
1. On the left hand side click on: OAuth & Permissions
1. Go down to Scopes → Bot Token Scopes
1. Add the “chat:write,channels:read,groups:read,mpim:read,im:read” scope
1. Go back up to “OAuth Tokens for Your Workspace” and click on “Install into Workspace” and allow the app to access our workspace
1. This will bring you back to the app’s management page and now there is a token there with the format of: xoxb-xxxx-xxx-xxx
