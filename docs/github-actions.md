# Github Actions

Introductory doc: [https://help.github.com/en/actions/automating-your-workflow-with-github-actions/configuring-a-workflow](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/configuring-a-workflow)

Workflow syntax: [https://help.github.com/en/actions/automating-your-workflow-with-github-actions/workflow-syntax-for-github-actions](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/workflow-syntax-for-github-actions)

Secrets/Environment vars: [https://help.github.com/en/actions/automating-your-workflow-with-github-actions/creating-and-using-encrypted-secrets](https://help.github.com/en/actions/automating-your-workflow-with-github-actions/creating-and-using-encrypted-secrets)

Google example to build and deploy to a GKE cluster: [https://github.com/actions/starter-workflows/blob/master/ci/google.yml](https://github.com/actions/starter-workflows/blob/master/ci/google.yml)



# Other workflows

## Deployment

https://github.community/t5/GitHub-Actions/GitHub-Actions-Manual-Trigger-Approvals/m-p/31517#M813


# Github status page

Github Action is still new, there can be problems with it triggering.  If you are noticing issues check their
status page:

https://www.githubstatus.com/


..

# Dev workflow

The dev workflow is not so great.

For example, I was trying to download a tool (the tool don't really matter much) and use it
in the workflow.

```yaml
      # Set up sonobuoy
      - name: Set up sonobuoy
        run: |
          curl -o ${SONOBUOY_TAR_FILE}.tar.gz --location ${SONOBUOY_URL}/${SONOBUOY_TAR_FILE}.tar.gz
          tar -zxvf ${SONOBUOY_TAR_FILE}.tar.gz
          export PATH=$(pwd):$PATH
          sonobuoy version
```

This is a working version of it but there were many iterations before I got the tar output correct
and what it outputted and where the `sonobuoy` (tool) binary was.  To debug this you start doing stuff like:

```yaml
      # Set up sonobuoy
      - name: Set up sonobuoy
        run: |
          curl -o ${SONOBUOY_TAR_FILE}.tar.gz --location ${SONOBUOY_URL}/${SONOBUOY_TAR_FILE}.tar.gz
          tar -zxvf ${SONOBUOY_TAR_FILE}.tar.gz
          ls -l
          export PATH=$(pwd):$PATH
          sonobuoy version
```

Adding `ls -l` into the step and then committing it and then waiting for the Github Action executor to
execute it.  If you are lucky you get it correct on the first try.  I'm not that lucky.  It took me a
bunch of tries before I got it correct.

If you look at the commits around this time, you will see what I had to do: [https://github.com/ManagedKube/kubernetes-ops/commit/807185895f0ef0c19652b250f687b998a117b592](https://github.com/ManagedKube/kubernetes-ops/commit/807185895f0ef0c19652b250f687b998a117b592)

That is not that cool of a workflow.

Once I got that figured out, then if you look at this run: [https://github.com/ManagedKube/kubernetes-ops/commit/807185895f0ef0c19652b250f687b998a117b592/checks?check_suite_id=342939929#step:9:16](https://github.com/ManagedKube/kubernetes-ops/commit/807185895f0ef0c19652b250f687b998a117b592/checks?check_suite_id=342939929#step:9:16)

```bash
time="2019-12-05T02:45:48Z" level=error msg="could not create sonobuoy client: couldn't get sonobuoy api helper: could not get api group resources: Get https://api-dev-test-us-east-1-k8-idc14e-1850800389.us-east-1.elb.amazonaws.com/api?timeout=32s: dial tcp 18.211.59.240:443: i/o timeout"
```

It timed out on trying to reach the Kubernetes API endpoint.  That is the correct thing, I now have to open up the Kubernetes API to the
source IP of where Github Actions are coming from.

Now, im debugging infrastructure issues here.  This will have to be done but it doesn't have to be figured out right now.  I am still
trying to figure out this pipeline run.

What I really want to do is to run this pipeline locally and not have to do this commit->push loop all the time for every single little
action or change I want to make.

I am specifically mentioning Github Actions here but this is not a problem exclusive to them.  Jenkins pipelines has the same problem as 
well.  You are not able to run anything locally and you have to go through the commit->push loop to make Jenkins run your updates.

# Am I using these pipelines wrong?

I was working on another project today and it was about Apache Airflow.  I didn't know much about it but the developers were running it on Kubernetes
and needed some help.  So in helping them out, I was Googling around for information on what Airflow was, what the architecture was like, 
how did it use/integrate with Kubernetes, and generally how it works.

The blog that I came around to that is related to this problem is this blog:

[https://medium.com/bluecore-engineering/were-all-using-airflow-wrong-and-how-to-fix-it-a56f14cb0753](https://medium.com/bluecore-engineering/were-all-using-airflow-wrong-and-how-to-fix-it-a56f14cb0753)

The short of it, is that they were running into the same problems as I am right now with these "pipelines".  They had to commit
everything then have the Airflow harness to run it and then each Airflow thing was wrapped around with an Operator (an Airflow 
Operator not a Kubernetes Operator) and then it executed the action.  In this sequence many things can go wrong.  The problem
can be in Airflow scheduling, in the Airflow Operator (which they were saying happened a lot), or their own logic.  So going
through this process they had to debug a lot of stuff until they got to the problem and most developers were not Airflow or Kubernetes
experts which makes debugging it even harder and very time consuming.  Which means nobody really like it or used it.  The adoption of
this was low in their company.

The way they solve it was to run a generic Airflow Operator.  This generic Airflow Operator basically only ran a Docker container which
gave it some nice properties.  One of the big thing it gave them was that the developer can run the core logic without the Airflow
scheduling harness around it on her laptop.  The Airflow Operator that spawned off a pod was very stable unlike other Operators that
are community maintained.  The developer didn't have to know much about Airflow or Kubernetes to build a pipeline.  They just had to 
know the Airflow entry points and how to hook into it.

This leads us back to my problem.  I am having all of the same problems that they describe in the blog and all of the same solutions
would work for my problem.  In my case, the Github Action is equivalent to Airflow which I really do not want to debug.  Github Action
also can just run a Docker container for me.  If I made Github Action run my container, then I can develop all I want locally until it works
then try to have Github Actions to run it for me.
