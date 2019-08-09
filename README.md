# kubernetes-ops

Kubernetes Ops has been a culmination of how we have been helping clients use
Kubernetes over the years.  There has been a lot of trial an error as we have
grown up with Kubernetes.  This represents how we are currently helping our clients
use Kubernetes and how we help them maintain their infrastructure.  You can view
this as a reference implementation of a fully productionalized Kubernetes setup.

We lean towards the immutable infrastructure and Gitops Flow methodologies and use
no configuration management tools.  Everything starts out in Git as either code
or configuration.  Items are manipulated to what we want the desired state to be
and that is applied onto the infrastructure.  

One of the biggest problem that this repository helps out with is what people are
starting to refer to as "day 2" problems (where "day 1" is creation).  The "day 1"
problems are well documented and there are plenty of tutorials out there for it.
The problem with these tutorials and examples are that they mostly leave you hanging
on how to move forward with the infrastructure pieces.  Day 2 problems are: what is the upgrade, patching,
and modification strategy, how do I manage the infrastructure git repository, etc?  
This is where we think we can provide some contribution.
With our experience in managing many Kubernetes clusters over the years, we think
we can provide this information.  Creation of your cluster is about 10 to maybe
20 percent of the infrastructure activity (if that), making changes to the infrastructure
to suite your needs as time moves on is the bulk of the activity and finally
deletion of the entire or parts of the infrastructure as new items comes into play.

If you follow through the instructions, you might think this is overly complex.
If this is your first time playing around with Kubernetes, it probably is overly
complex and this project is probably not well suited for you at this time.  When
you want to take Kubernetes into production, this is where we think this set of
methodologies starts to shine.  For example, this gives you an example of how
to lay out a repository for you infrastructure.  It gives you the process and
workflow to create and update infrastructure pieces.  From working with many
clients, we have come to a place where managing the infrastructure in this way
has made sense and has worked out really well in large and small teams.

## The stack this will create

![the stack](/docs/images/the-stack/kubernetes-managed-service-stack-v2.png)

## Whys

### Why do all of this?  
Isn't there already projects that bring up Kubernetes for me?  Why don't I just use GKE, EKS, AKS, \*KS?

Yes, there is and we use all of that.  You can use anyone of those services and
go to the respective web console and bring up a Kubernetes cluster.  In our opinion
and from our experience this is fine if you are testing out Kubernetes or just trying
out something new.  It is fast and easy to understand what is going on.  However,
when you want to bring that "new thing" into production, managing it that way
is not ideal.  It is hard to reproduce from dev to qa to prod.  Making manual
changes are hard to track and very error prone.  

We stress that this project does not represent the "easy" way of managing infrastructure.
This project represents a way to manage infrastructure in a Gitops flow kinda way and
in a sane way where a team of people can work on it together.  

### GitOps workflow, how does that play into this project?
This project mainly follow a Gitops workflow methodology.  Changes are made in
this repository to code or configs in a branch.  A PR can be opened on that branch
where other team members can review the changes.  Then depending on your merging
techniques and automation it can be applied or merged then applied to any one
environment.

### Why an entire repository?
We have found that having an "infrastructure" repository makes sense.  You need
these items to live somewhere.  It is usually not application code and it is an
entity all to itself.  The infrastructure repository also usually gets fairly large
overtime as new items gets added into the software stack and new requirements for
services comes along.

As an organization grows, it also tends to be a different set of people that
maintains the infrastructure and this repository.  You have application developers
and DevOps or infrastructure groups.  Even if you have those two teams in the same
group having this separate is a good delineation on what is actually being changed.
If items in here are changed, it is clearly an infrastructure related item.

## What tools do we use
We mainly only use open source tools.  There might be some paid tools eventually
ending up in this repository and we will explicitly label those.

Infrastructure building:
* Terraform
* Terragrunt
* Kops

Kubernetes:
* Kops using pure upstream Kubernetes
* Helm
* Helm Charts from  their repository
* All kinds of other open source Kubernetes packages

Kubernetes clusters:
* Kops
* GKE
* EKS

## How do I start using this?

There are various docs and guides in the `docs` directory.

## Read the setup
This is the first thing you should read.  This has all of the setup information
that you will need to get started.

[main doc](docs/)

### The manual way for a Kops cluster
This is a more manual walk through on how to create a cluster using this project.
The intention here is to give you a deep dive into what goes
into creating a Kops cluster:

[the-manual-way](docs/the-manual-way.md)

### Creating a Kops cluster on AWS the easier way

the "easier way" takes the manual steps in the previous example and hides most
of the steps in a script where you can just run:

[the-easier-way](docs/the-easier-way.md)
