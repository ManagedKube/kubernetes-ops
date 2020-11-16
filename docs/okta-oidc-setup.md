Table of Contents
=================

* [How to configure OIDC to access your cluster with Okta](#how-to-configure-oidc-to-access-your-cluster-with-okta)
* [Step 1: (OIDC Setup)  Creating an OKTA application for OIDC](#step-1-oidc-setup--creating-an-okta-application-for-oidc)
    * [Create an application (Needed per cluster)](#create-an-application-needed-per-cluster)
      * [Gather important information](#gather-important-information)
  * [(OIDC Setup) Creating a shareable kubecfg](#oidc-setup-creating-a-shareable-kubecfg)
  * [Share the kubeconfig with your team members](#share-the-kubeconfig-with-your-team-members)
    * [Verify cluster access](#verify-cluster-access)
    * [You can switch the default context to oidc\.](#you-can-switch-the-default-context-to-oidc)

# How to configure OIDC to access your cluster with Okta

# Step 1: (OIDC Setup)  Creating an OKTA application for OIDC

We want to authenticate to our clusters using OKTA, for this we use JWT tokens, as per the specification https://tools.ietf.org/html/rfc7519, so for each cluster we will need to create an OKTA application, a detailed information on how to create an application can be found if the official documentation, https://developer.okta.com/docs/guides/add-an-external-idp/saml2/register-app-in-okta/ here is a simplified guide;

### Create an application (Needed per cluster)

Sign in to https://okta.com/ and change to the Classic UI view by selecting the option in the top left drop down.

Go to the Applications tab and create a new Web application with the OIDC sign on method. Specify a login redirect URI of http://localhost:8000.

In the General tab, make sure that the authorisation code and refresh token are set as allowed grant types.

In the Sign On tab, edit the OpenID Connect ID Token section, changing the groups claim type to filter, and the groups claim filter to groups with a regex value of .*.  Checkout https://support.okta.com/help/s/article/Okta-Groups-or-Attribute-Missing-from-Id-Token?language=en_US

In the Assignments tab, assign people and groups to your application as necessary.

Expose the groups claim (Only need to do once - should be able to skip)

Go to Security, API and add a new authorisation server (or edit the default server). The Audience field corresponds to the audience claim.

In the Scopes tab, add a new scope called groups and include it in public metadata.

In the Claims tab, add a new claim called groups that is included with the ID token, of value type Groups, with a Regex filter of .* and that is included in the groups scope.

In the Access Policies tab add a new access policy and assign your application.

Add a new rule to your access policy called Default Policy Rule keeping all the settings as they are.

You can test your setup by going to the Token Preview tab, specifying your application as the client, grant type as authorisation code and scopes as groups and OpenID. The returned payload should contain the list of groups containing the user you chose.

#### Gather important information

For launching the Kops cluster you will need oidcIssuerURL oidcClientID and oidcClientSecret

## (OIDC Setup) Creating a shareable kubecfg

Install and configure kubelogin  

First you will need to install kubelogin from  

In case you are using MacOS the easiest way is brew install int128/kubelogin/kubelogin

Configure your kubectl with the oidcIssuerURL oidcClientID and oidcClientSecret from step 2.

kubectl config set-credentials oidc \
          --exec-api-version=client.authentication.k8s.io/v1beta1 \
          --exec-command=kubectl \
          --exec-arg=oidc-login \
          --exec-arg=get-token \
          --exec-arg=--oidc-issuer-url=<oidcIssuerURL> \
          --exec-arg=--oidc-client-id=<oidcClientID> \
          --exec-arg=--oidc-client-secret=<oidcClientSecret> \
          --exec-arg=--oidc-extra-scope=groups

Bind a cluster role

Now you need a clusterrolebinding for each group of the claim, here is an example of an admin access to Everyone group as mapped in OKTA.

It is possible  you’ll want to bind this to a more restrictive group in OKTA. Be sure it’s as restrictive as possible.

❯ kubectl create clusterrolebinding oidc-cluster-admin --clusterrole=cluster-admin --group=Everyone
clusterrolebinding.rbac.authorization.k8s.io/oidc-cluster-admin created

You should never give cluster-admin access to Everyone group, this is just an example :)

## Share the kubeconfig with your team members

Finally you just need to share the kubeconfig via lastpass with your coworkers, here is a example of a kubecfg

apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUMwekNDQWJ1Z0F3SUJBZ0lNRmlQV2w4bTgyTkJGR2RLTE1BMEdDU3FHU0liM0RRRUJDd1VBTUJVeEV6QVIKQmdOVkJBTVRDbXQxWW1WeWJtVjBaWE13SGhjTk1qQXdOekU1TVRnd05EQXdXaGNOTXpBd056RTVNVGd3TkRBdwpXakFWTVJNd0VRWURWUVFERXdwcmRXSmxjbTVsZEdWek1JSUJJakFOQmdrcWhraUc5dzBCQVFFRkFBT0NBUThBCk1JSUJDZ0tDQVFFQXRsZGxrQ0N3SlYwU1V6NzRZMHZjVlFlRFJKVmhSY0V0L016L1pCUS9vOXV0RWJ0WEZzNncKRVowamh1YTN2TjM1UmlpUXF3d1JoYmhldFFxcEtYUjJXMmIweENGSnpDOUYrVGc2NncxZVVXRGVyY20wMFU4bApPVk9SUDgvbnRwVGNHalVwOGVtMVdKNXBlcmNHZ0RkNCtZQXRVQkEyTUpIdmw4TFlSd1Q2WFFwR2hnVXpuWVFqClQvODZwb1RSRThPVk1IMSs5c3U0SW9IbG9NWmtxblVLZVlIUjRvOXpPY2l1VWszSkFLbTBKTStBSnp0UDFUbXcKckVaREE1NElDSVlsNGdIQlA1bnh6ZXZDYjdzUGU1cGRNaWZRS3djUm5SRldYR1lmYUFLdkFZVFJhajJneFdqQgptaTNFQmxzQUdESEZCdXdadXBVNGRQUzNPNmhZWkYxczJ3SURBUUFCb3lNd0lUQU9CZ05WSFE4QkFmOEVCQU1DCkFRWXdEd1lEVlIwVEFRSC9CQVV3QXdFQi96QU5CZ2txaGtpRzl3MEJBUXNGQUFPQ0FRRUFyakpmZURES05CZlUKZlkyeURQb0NFbE9iS1pNRm0rK1daVkhSNzRlVDBnNHQvRzZwOXlnZU9QNHZWNlJFR1FIMVFNV1hoQTdmUVZmbAoyQkxKMWVoMXFIOFM0UEdHVzVtbDJQY2daSjJ1emFTOFRVS0g3SG9NdWsvV3c0Y0VmYWtkcml2VXIvazBNN2NoClpKSTFOTTV3SER6WnJZNm5CRnk4TXo0NEowdHpJYlJhNkV3TWJzVkk0NUpXWGcwMlY2aklDd05Na1pQRXZjSG8KVU84cWxKMEtLODhhQUdNcG1ONURwZVovQmNqcHZIVGk5MWozS25hMmhXVkFMNnVMbStlcWNMeTV2SmZTTlhVRwptT2RUODk1c0tvQ2kxVXNiV0ZGcWdiSmh2alJ1Y2pKOXF1Q3hQeFQ3YTVkeUJtcFNad202UDViL2lGd1JZYnNVClRjVlllWkFkVmc9PQotLS0tLUVORCBDRVJUSUZJQ0FURS0tLS0tCg==
    server: https://internal-api-test-us-west-2-k8s-lo-bou9g7-1033340004.us-west-2.elb.amazonaws.com
  name: test.us-west-2.k8s.local
contexts:
- context:
    cluster: test.us-west-2.k8s.local
    user: oidc
  name: test.us-west-2.k8s.local
current-context: test.us-west-2.k8s.local
kind: Config
preferences: {}
users:
- name: oidc
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1beta1
      args:
      - oidc-login
      - get-token
      - --oidc-issuer-url=<oidcIssuerURL>
      - --oidc-client-id=<oidcClientID>
      - --oidc-client-secret=<oidcClientSecret>
      - --oidc-extra-scope=groups
      command: kubectl

### Verify cluster access

kubectl --user=oidc get nodes

### You can switch the default context to oidc.

kubectl config set-context --current --user=oidc
