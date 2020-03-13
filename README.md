# Presto Sample Pipeline

Builds and Deploys Presto Docker image to [GKE](https://cloud.google.com/kubernetes-engine). 

## Prerequisites 

- Commit access to this repo is required to run the `pipeline.sh` script.  
- You may require additional access privileges to view the Google Cloud Build pipeline.

## Usage

This setup utilizes a basic [GitOps](https://www.gitops.tech/) approach.  

The pipeline may either be triggered with a commit to the repo, or by running
the pipeline script:

```shell
./pipeline.sh
``` 

An optional presto release version may also be provided when initiating via the script.

Once the pipeline completes, the Presto cluster overview webpage is accessible on 
the [host GKE cluster](http://35.238.175.52/ui/).

## Background

x a. Short walkthrough the architecture of the solution
x b. The files / components and their responsibilities
x c. Usage docs
d. External resources (blogs, websites, etc) you read when coming up with a
solution to this exercise
e. List of third-party services/tools used by the solution
f. Time spent on assignment, can break down into problem areas.

### Architecture

The pipeline consists of:
- A GKE cluster instantiated out-of-band
- This repo with a [github Google Cloud Build integration](https://github.com/padolan/presto-pl-gke/settings/installations)
- A Google Cloud Build project, [presto-pl-gke](https://console.cloud.google.com/cloud-build/dashboard?project=presto-pl-gke)
- A Cloud Build pipeline [metadata file](https://github.com/padolan/presto-pl-gke/blob/master/cloudbuild.yaml)
- Other repo components:
  - [pipeline cli](https://github.com/padolan/presto-pl-gke/blob/master/pipeline.sh)
  - [presto Dockerfile](https://github.com/padolan/presto-pl-gke/blob/master/presto/Dockerfile)
  - presto-cli [Dockerfile](https://github.com/padolan/presto-pl-gke/blob/master/presto-cli/Dockerfile)
  and [smoke test script](https://github.com/padolan/presto-pl-gke/blob/master/presto-cli/presto-smoketest.sh)
  - [kubernetes manifest file](https://github.com/padolan/presto-pl-gke/blob/master/presto-common/manifests.k8s.tpl)

The pipeline flows as follows:
```
                 +----------+    +------------+    +-------------+    +------------+    +------------+
    0            |    1     |    |      2     |    |     3       |    |     4      |    |    5       |
Git Commit +---->+  trigger +--->+ Build &    +--->+   Build &   +--->+  Apply k8s +--->+  Run smoke |
                 |   GCB    |    | Push Presto|    | Push Presto |    |  manifests |    |   tests    |
                 |          |    |            |    |   CLI       |    |            |    |            |
                 +----------+    +------------+    +-------------+    +------------+    +------------+
```
### Component Details

#### MySql Container
A separate mysql container is installed alongside presto, used as part of the install validation. 

#### Smoke Tests

"Smoke Tests" are performed on the main presto container via a "test container" pattern: a purpose-built
docker container which contains tools and tests necessary for validating the target container.  In this case
that consists of:
- jvm + presto-cli
- simple bundled test script
 
#### Presto connectors

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
