FROM ghcr.io/vmware-tanzu-labs/educates-jdk17-environment:2.6.16

USER root

RUN yum install moreutils wget -y

USER 1001

RUN fix-permissions /home/eduk8s
