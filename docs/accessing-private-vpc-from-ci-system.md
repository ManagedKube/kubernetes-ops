# Accessing a Private VPC from a CI/CD System

A lot of the popular CI/CD systems that are hosted and are on the internet:

* Github Actions
* Gitlab
* CiricleCI
* CodeFresh

The best practice for our VPCs and Kubernetes cluster is to have only internal addresses.

The problem is how do these CI/CD systems get access to our private VPC and Kubernetes clusters
which do not any any public IPs it can reach?

The following are some ideas on how we can address the problem.

## Bastion host
This seems like a common way and this seems to be the way that network operators has solved this
problem for a long time now.  You basically are given access to a bastion host which sits between
the internet and the internal network.

```
Internet <---> (Public IP) Bastion Host (Internal IP) <---> Internal Network (can reach items on the internal network)
```

This is nice if you already have a Bastion host setup and this is the standard way you are doing things.  This not
so great, if you have to stand up a bastion host for CI/CD purposes.  The reason is that now, someone will have to manage
and secure this machine going forward.  In companies that have higher security requirements turning on a bastion host
might not be a trivial thing and can cause a lot of questions to be asked and you would have to go through a lot
of process to get this in place.

If there was a bastion host, using something like [sshuttle](https://github.com/sshuttle/sshuttle) becomes very easy
to use and to gain access to a remote network like it was directly connected locally.

## AWS System Manager Session
This is an AWS service that helps you get access to machines and private VPCs in your accounts.

Doc: [https://aws.amazon.com/blogs/aws/new-port-forwarding-using-aws-system-manager-sessions-manager/](https://aws.amazon.com/blogs/aws/new-port-forwarding-using-aws-system-manager-sessions-manager/)

This can potentially span access from the CI/CD system to a private VPC network. 

This is however, a unquiely an AWS only solution since other cloud providers does not have something like this.

## Slack overlay network
This is an interesting idea on how to span networks: [https://slack.engineering/introducing-nebula-the-open-source-global-overlay-network-from-slack-884110a5579](https://slack.engineering/introducing-nebula-the-open-source-global-overlay-network-from-slack-884110a5579)

I think a little bit more research have to be done on this first on how to use this.  This requires a machine on the internet that
all hosts trying to connect into the overlay to know.  This also might be a problem to setup, secure, and continue on going maintenance on it.  Which
can cause a lot of overhead just for the CI/CD use case.


## Running containers in the VPC via Fargate/CloudRun/etc
What we really want is to just run a "process" in the remote private VPC and get back the output from it like:
* What happened?
* Did it succeed/fail/etc?
* The log output

We can have the CI/CD system launch a container in the remote private VPC which it then would have access to the
private VPC's network and cloud resources (whatever permissions was given to it).  Then this container would run
the process/program to perform some kind of updates or sequence just like the CI/CD system would and then report
back the output.

![aws fargate ci-cd runner](/docs/images/ci-cd-fargate-runner/ci-cd-fargate-runner.png)

1) The CI/CD system is instructed to run this Fargate container

2) Launching the Fargate container
* This "step" should have the approapriate AWS IAM access to launch this.  
* It will launch the predetermined container on Fargate in the targeted private VPC.
* This step will call the AWS API with the appropriate information to launch the Fargate task

3) Fargate container launches
* The Fargate container launches inside the VPC that was targeted
* This container runs 

4) The Kubernetes update process
* The container runs through to update Kubernetes and whatever else this container is programed to do

5) Fargate container logs
* Logs from the Fargate container is extracted and outputted to the CI/CD systems output
* This allows someone to inspect this pipeline run from the CI/CD system on what happend

There are some pros and cons to this solution:

Pros:
* Does not require any VPN type connections between the CI/CD system and the remote private VPC
* A developer can test the update logic (#4) locally.  Generally these pipelines cannot be tested locally because the CI/CD system has to run the pipeline.  Since it is disconnected, this means the developer can run this locally to test if it is working as expected.
* This scheme would work on most major cloud provider that has a "container as a service" offering

Cons:
* This disconnects the CI/CD system from the actual run
* Changing the update logic (#4) will mean having to push a new container to the Fargate runner

Example Github Action:

```yaml
    steps:
      # Checkout the repository
      - name: Checkout
        uses: actions/checkout@v1
      - name: Launch Fargate Task
        run: |
		  FARGATE_TASK_ID=aws fargate launch task \
		  --image=managedkube.com/update-kops-cluster:0.1.1
		  --env=foo=bar \
		  --env=foo2=bar2
	  - name: Wait for Fargate task
		run: |
		  # Wait for Fargate task
	  - name: Get Fargate tasks logs
		run: |
		  aws fargate get logs ${FARGATE_TASK_ID}
		  # output to stdout so that the CI/CD system can show the log to the operator
```

Example of what the `managedkube.com/update-kops-cluster:0.1.1` will do:

```bash
#!/bin/bash -ex

# [DRY RUN] Run the kops update
./kops.sh --name dev --update true --dry-run true

# [Not DRY RUN] Run the kops update
./kops.sh --name dev --update true --dry-run false

# Run e2e tests
./e2e-test.sh --name dev

# Roll the nodes with testing on each node group
./kops.sh --name dev --rolling-update --run-tests true --dry-run false
```