Flux Usage
============
Flux will sync Kubernetes yaml files in this repo to your Kubernetes cluster.  Each Flux operator that you deploy, you point it to a certain folder in your repository and it will just sync all of those file to the cluster.

To use these items, you need to copy the folder `<repo root>/kubernetes` to the root of your repository.  It has to be at the root of your repository because all of the paths are pointing from that fixed location.  You can change the location but then you will have to change various paths in the deployment files to point to the correct location.

