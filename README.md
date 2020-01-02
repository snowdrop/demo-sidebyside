## Introduction

This repository contains the code of the second part of Georgios Andrianakis's [presentation](https://www.youtube.com/watch?v=9wJm8g83vqA&t=2678s) at Devoxx Belgium 2019.

All the necessary code can be found under the `hello` folder. That directory contains a `hello world application` written using 3 different frameworks: 
* Quarkus with Spring API compatibility layer - in the `quarked` subdirectory
* Vanilla Spring Boot  - in the `booted` subdirectory
* Node.js (using the Hapi.js framework) - in the `nodejs` subdirectory  

The purpose of the demo is to :
- Deploy all 3 applications to a Kubernetes cluster that has KNative Service enabled
- Show how quickly the 3 different applications can scale up when receiving a burst of traffic
- Demonstrate that a `Quarkus` application consumes the least amount of memory ;-)

## Table of contents

  * [Instructions](#instructions)
     * [Pre-requisite](#pre-requisite)
     * [Steps](#steps)
        * [Build](#build)
        * [Deployment](#deployment)
        * [Running the actual scenario](#running-the-actual-scenario)
        * [Checking memory](#checking-memory)

## Instructions

### Pre-requisite

- Openshift 4.2 is available
- KNative Serving has been deployed using the `Serverless` Operator
- Have access to a Docker server/daemon

### Steps

#### Build 

The docker images referenced by the Kubernetes manifests (deployment, service, ...) that we will use
must be built and pushed under a local docker registry.

They can be (re)build and (re)push using the following bash scripts `./dockerbuild.sh` and `./dockerpush.sh`

**NOTE**: The name of the target image has been hard coded to the user `geoand` and can be changed with your own username. Just substitute `geoand` with your username in all places the former is used

#### Deployment

- Create first a project where you will deploy the 3 applications : `oc new-project cool-demo`
- For each one of the applications, apply the `kubefiles/knService_docker.yml` file using the command : `oc apply -f kubefiles/knService_docker.yml`.
- To force KNative to launch (and keep running) a single pod of the application, you can poll the application by executing the `./knpoller.sh` script (or `./knpoller_ocp4.sh` if using OpenShift 4.x).

#### Running the actual scenario

For each of one of the application open two terminals.

In the first terminal, execute the `./count_ready.sh` script which will constantly monitor the number of pods the application is running.

In the second terminal execute `./knburst.sh` (or `./knburst_ocp4.sh` when using Openshift 4.x). The effect this has is to create a large burst of traffic that the application will have to handle.
KNative will as a result of the traffic burst scale the application up. In this scenario KNative should spin up about 10 to 15 pods of each application.

When executing the scenario, you will see that the Quarkus application will scale up much faster that the other two, followed by Node.js.


#### Checking memory

If you are using a cluster that a dashboard showing memory consumption for each pod, you can see that the pods running the Quarkus application consume the least amount of memory.


  