# Presto Sample Pipeline

Builds and Deploys Presto Docker image to [GKE](https://cloud.google.com/kubernetes-engine). 

## Prerequisites 

- Commit access to this repo is required to run the `pipeline.sh` script.  
- You may require additional access privileges to view the Google Cloud Build pipeline.

## Initiating the pipeline

This setup uses a basic [GitOps](https://www.gitops.tech/) approach.  

Pipelines can either be triggered with any commit to the repo, or by running
the pipeline script:

```shell
./pipeline.sh
``` 

An optional presto release version may also be provided for the install.

Once initiated, the Presto cluster overview webpage is accessible on the [host cluster](http://35.238.175.52/ui/).

## Background

### MySql Container
A separate mysql container is installed alongside presto, used as part of the install validation. 

### Smoke Tests

"Smoke Tests" are performed on the main presto container via a "test container" pattern: a purpose-built
docker container which contains tools and tests necessary for validating the target container.  In this case
that consists of:
- jvm + presto-cli
- simple bundled test script
 
### Presto connectors utilized

Presto docker container is started with following connectors:
* tpch
* tpcds
* memory
* blackhole
* jmx
* system

On top of this, a mysql connector is added for basic validation purposes.

## OpenJDK license

By using this image, you accept the OpenJDK License Agreement for Java SE available here:
[https://openjdk.java.net/legal/gplv2+ce.html](https://openjdk.java.net/legal/gplv2+ce.html)
