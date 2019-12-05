FROM ubuntu:18.04

# Add the entire repository into the container
ADD ./ /opt/repo/

WORKDIR /opt/repo/containers/kops-update

RUN ./setup.sh

WORKDIR /opt/repo