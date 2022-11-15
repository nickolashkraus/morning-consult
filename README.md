# [Morning Consult](https://morningconsult.com)

[![MIT License](https://img.shields.io/badge/License-MIT-blue.svg)](https://github.com/nickolashkraus/morning-consult/blob/master/LICENSE)

Solution for the technical interview problem

[Google Slides](https://docs.google.com/presentation/d/1YTHk83fRqV9TUDvS1VarhDV4agciidF0nnBxhAJO5rI)

## Prompt

>You have a Twitter Firehose that is constantly pushing you data. You need to deploy a service that ingests that data and writes it to a backend data store for downstream application consumption.

## Overview

### Solution 1: Fully-hosted

* [Confluent.io](https://www.confluent.io)

### Solution 2: Kubernetes

* Apache Kafka -> Service -> Data Store

### Solution 3: AWS

* Amazon Kinesis -> AWS Lambda -> Amazon S3
