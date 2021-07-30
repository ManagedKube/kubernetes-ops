Updating a Kops Cluster
========================

Sometime refer to as "Day 2" problems.  The other part of the lifecycle after
cluster creations.  This is where most of the Kubernetes cluster's lifecycle will
reside in.

# Updating instance size
The most common operation to perform is updating the instance size to be
larger or smaller.  This is an easy operation.

Lets say you have a `dev` cluster.  

The following paths all starts from the root of this repository.

Open and edit the file: `./clusters/aws/kops/clusters/dev/values.yaml`

Lets say that you want to update the `onDemandGroup1` group.

## Update the configuration file
Search or scroll down in the file until you find the group settings for `onDemandGroup1`

```
...
onDemandGroup1:
  # CoreOS: https://github.com/kubernetes/kops/blob/06b0111251ab87861e57dbf5f8d36f02e84af04d/docs/images.md#coreos
  image: 595879546273/CoreOS-stable-2023.5.0-hvm
  machineType: t3.large
  maxSize: 10
  minSize: 1
...
```

Update the `machineType` value to the new instance type you want it to be.

## Apply changes
After this change, we have to apply these changes

Run a dry run to see what it will change:
```
cd clusters/aws/kops
./kops.sh --name dev --update true --dry-run true
```

Apply the changes:
```
./kops.sh --name dev --update true --dry-run false
```

## Roll the nodes
When we applied the changes, Kops changed the AWS configuration of the Launch
Configuration of the ASG group.  This does not touch the current nodes that
are running.  When a new node starts, it will use the new configuration but the
current node will stay as is.  

For this reason, we have to "roll" the nodes.  This means that we will have to
terminate and let the system launch new nodes.  

Roll the nodes:
```
./kops.sh --name dev --rolling-update true --dry-run false --cloudonly true
```

This will select nodes that needs updating and turn them off one by one until they
are all updated.

## Commit back the changes

Now that we have made the changes, we want to commit back these changes to our
repository.

Another Git flow we could have used was after we made the config changes, we could
have started a new branch, commit the changes to that branch, and then opened a
pull request for these changes.  With the Pull Request, we would solicit feedback
from our peers on what they think about this change.  If everyone says it is ok,
we could merge and apply the changes and roll the nodes.
