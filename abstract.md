# Training Deep Dive: Monitoring Microservices with Prometheus

Microservice-based systems are on the rise in an attempt to improve scalability and reliability. But replacing monoliths with microservices means translating complicated software into complex systems. The complexity in the service-level domain means that traditional monitoring systems are no longer capable of ensuring reliable operation.

Prometheus is a simple, but effective solution to that problem. At it's heart it is a time-series database. But the key feature lies in the fact that it uses a pull model. It scrapes and pulls metrics from services. This alone makes it robust, simple and scalable which fits perfectly with a Microservices architecture.

In this training we will take a deep dive into Prometheus, exploring it's architecture and investigating its capabilities. You will learn to use prometheus in a production-ready environment. You will write you own applications that are visible in Prometheus. We will look at how Prometheus integrates well with Kubernetes and discuss how to implement a production ready system. Of course, we'll also talk about the theory of monitoring, a little bit of Data Science and some Site Reliability Engineering.

This training is tailored towards Engineers and Technical Leads who want to understand the fundamentals of Monitoring and gain practical experience with Prometheus.

## Training Prerequisites and Assumptions

**Attendees must have the following software installed before the workshop**:
- Docker
- Docker Compose
- Minikube

Attendees must have the following:
- Unrestricted access to the internet
- Unrestricted ability to install and administer software

Caveats:
- Unix based operating systems are preferred (Mac/Linux)
- Windows users may not be able to run all the practical examples.

Knowledge Expectations:
- Familiarity with Docker
- Some familiarity with Prometheus
- Understanding of Microservice theory and fundamentals.

Expected outcomes:
- Confidence and practical experience with working with Prometheus
- Intimiate knowledge of how Prometheus works
- Ability to walk away and implement production-ready monitoring and alerting services

Training outline:
* Introduction
*
  * What are we doing?
  * Assumptions?
  *
    * Docker
    * Kubernetes
    * Your code
    * Your users

* Monitoring Docker
*
  * Docker stats
  * Docker top
  * Hands-on

* cAdvisor
*
  * What is it?
  * How does it work?
  * Installation: In a container, of course!
  * Web interface
  *
    * Processes, CPU, RAM, Network, Filesystem
    * Containers

  * What's the catch?
  * API
  * Hands-on

* Introduction to Prometheus
*
  * Introduction
  *
    * What is it
    * Where does it sit
    * Prometheus vs...
    *
      * InfluxDB

  * Architecture
  * What it is not (important!)
  * Data model
  *
    * Time Series Databases
    * How is the database structured?
    * Types of Metrics

  * Obtaining Metrics
  *
    * How does it get the data?
    * Push vs. Pull models

  * Using Metrics
  *
    * How are names generated?
    * What are labels?
    * How to use labels?
    * Metric naming best practices
    * Best Practices
    *
      * Labels
      * Metric names
      * Etc.

* Using Prometheus
*
  * Prometheus Configuration
  *
    * Command line flags? No.
    * Configuration file
    * Important configuration concepts
    *
      * Globals
      * Rules
      * Scraping
      * Alerting

    * Example simple configuration

  * Installing prometheus (docker of course!)
  * Doing something useful
  *
    * Creating a configuration to read from cAdvisor

  * The Prometheus UI
  *
    * Status
    * Graph
    * Alerts (not yet!)
    * Help

  * What's the catch, part 2?
  *
    * Just a database
    * No Visualisation
    * No Alerting
    * Need to create lots of `/metrics` apis.

  * Hands-on

* Monitoring Theory
*
  * Logging vs. Tracing vs. Metrics
  * Site Reliability Engineering
  * Risk and Service Metrics
  * Toil and "Normal" operation
  * What to Monitor?
  *
    * Material impacts to the business
    * User monitoring
    * Resource monitoring
    * 4 Signals
    * RED Metrics

  * Being On-Call
  *
    * Alert Fatigue

  * Emergency Response
  * Managing incidents and Postmortems
  * Chaos Engineering
  * Devops
  * The future
  *
    * Stateful vs. Semantic Monitoring
    * Automation

* Instrumenting an App In
*
  * Bash
  * Java/Scala
  * .Net
  * Go
  * Node.js
  * Python
  * Ruby
  * C++
  * ...
  * Lots of hands on

* Prometheus Queries
*
  * What is a query?
  * How to use queries?
  *
    * Prometheus UI
    * HTTP API

  * Query types
  * Operators
  * Functions
  * Examples
  * Queries for our apps.
  * Hands-on

* Data Science
*
  * Statistics
  * Probability
  *
    * What is Random?
    * Population, Sample, Observation
    * Probability Distributions
    * Common Probability distributions
    * Central Limit Theorem

  * Modelling
  *
    * What is a model?
    * Creating a model
    * Describing a model with metrics
    * Mean and Standard Deviation
    *
      * Normal Distribution
      * Outliers
      * Don't use the mean!

    * So what do we do?
    *
      * Median
      * Quantiles
      * Distribution specific metrics

  * Anomaly Detection

* Prometheus Exporters
*
  * What are they?
  * Why are they required?
  *
    * Software exposing Prometheus metrics

  * Types
  *
    * [Databases](https://prometheus.io/docs/instrumenting/exporters/#databases)
    * [Hardware related](https://prometheus.io/docs/instrumenting/exporters/#hardware-related)
    * [Messaging systems](https://prometheus.io/docs/instrumenting/exporters/#messaging-systems)
    * [Storage](https://prometheus.io/docs/instrumenting/exporters/#storage)
    * [HTTP](https://prometheus.io/docs/instrumenting/exporters/#http)
    * [APIs](https://prometheus.io/docs/instrumenting/exporters/#apis)
    * [Logging](https://prometheus.io/docs/instrumenting/exporters/#logging)
    * [Other monitoring systems](https://prometheus.io/docs/instrumenting/exporters/#other-monitoring-systems)
    * [Miscellaneous](https://prometheus.io/docs/instrumenting/exporters/#miscellaneous)

  * Using Exporters
  *
    * MySQL Exporter/Elasticsearch?
    * Node Exporter
    * Kafka
    * HAProxy
    * ...

  * Hands on

* Monitoring Kubernetes
*
  * K8s already exports metrics!
  * So it's just configuration
  *
    * Step by step configuration

  * What about our apps?
  *
    * Scraping Pods

  * Service K8s deployment manifests
  *
    * Scraping
    * Not scraping

  * Prometheus configuration in k8s configmap
  * Hands on

* Visualisation 1 - Grafana
*
  * This looks crap. What can we do about it?
  * Grafana
  *
    * Not too much, it's pretty big.
    * Just use Grafana
    * Data Source
    * Organisation/User
    * Dashboards
    * Row/Panel
    * Queries

  * How to store dashboards
  *
    * Dashboards in configmaps? Yeah.

  * Further resources
  * Hands on

* Visualisation 2 - Templating
*
  * Templating? Oh yeah...
  * What is a template?
  *
    * Introduction to Go templates
    * Use all the functions in go templates
    * Prometheus specific notes

  * What is a console?
  * Example
  * Hands on

* Visualisation 3 - Goals of a Dashboard
*
  * Visual perception
  * Information overload
  * Scales and windows
  * Focused dashboards
  * Dashboard Design
  * Types of information
  * Choosing the best plot for you datatype

* Alerting
*
  * Architecture
  * AlertManager
  *
    * Alerting rules
    * Configuration
    * Integrations

  * Relationship to metrics
  * Best Practices
  * Hands on

* Scaling and availability
*
  * High availability
  *
    * Multiple Prometheus servers
    *
      * Load balancing
      * Sticky sessions

    * Multiple Alertmanagers
    *
      * Deduplication

  * Scaling and Federation
  *
    * Sharding
    * Hierarchical federation

* Advanced Prometheus
*
  * Database Storage (https://www.youtube.com/watch?v=HbnGSNEjhUc)
  *
    * Memory Usage
    * Disk Usage
    * Chunk encodings (https://prometheus.io/blog/2016/05/08/when-to-use-varbit-chunks/)
    * Retention and failure recovery
    * Key performance metrics

  * Performance Optimisation (https://www.youtube.com/watch?v=hPC60ldCGm8)
  * Wire Formats
  *
    * Text
    * Protobuf
