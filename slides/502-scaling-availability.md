# 502: Scaling and Availability

Now we're all experts at _using_ Prometheus, we're going to use it for everything.

But what happens when you start scraping so many containers that you need to scale out?

And since monitoring is a key part of your infrastructure, how can we make it highly available?

That's what this section is about.

![scale](img/scale.jpg)

---

## Scaling And Federation

First: It's be shown (depending on the number of metrics) that a single Prometheus server can
support in the order of 1000 servers. (This number might be a lot higher with 2.0's new backend
optimisation).

So only the largest clusters need to scale for performance reasons.

A more likely scenario is that you have multiple data centres or air-gapped clusters for any number
of reasons.

In this case you can run a prometheus instance per data centre.

---

### Federation

Once you have multiple servers, you probably want to aggregate them into a "global" prometheus server.

This is called hierarchical federation.

Basically the trick is to run a third Prometheus that is scraping from the two primary Prometheus's:

```yaml
- scrape_config:
  - job_name: dc_prometheus
    honor_labels: true
    metrics_path: /federate         # Default path to get data from other Prom nodes
    params:
      match[]:
        - '{__name__=~"^job:.*"}'   # Request all job-level time series
    static_configs:
      - targets:
        - dc1-prometheus:9090
        - dc2-prometheus:9090
```

Here you can filter out all the non-critical metrics to avoid sending too much data over WANs or the
internet.

---

### Splitting

It is also a good idea to empower teams to provide them with their own Prometheus server, where it
makes sense.

Each Prometheus would monitor its own stack. E.g. frontend, backend and machines.

Or this could be further split into domains.

Splitting ahead of time can help with isolation and coupling. E.g. Prevent scenarios like "I'm going
to ignore that frontend alert because I'm working on the backend at the moment".

You can still federate some metrics to pull out some top level SLI's out of the various Prometheus',
for example.

---

### Sharding

Much later you might grow to the point where your scrapes are too slow because the load is too high.

When this happens you can enable _sharding_.

This is only required when a Prometheus instance is monitoring thousands of instances.

In general, I would recommend avoiding this as it adds complication. Imagine trying to generate
queries with hundreds of thousands of metrics!

---

The idea is that you have several "slave" Prometheus servers that only scrape a certain subset of machines.

To do this we take a modulus of an address. If the modulus matches the current slave number, we scrape.

```yaml
global:
  external_labels:
    slave: 1  # This is the 2nd slave. This prevents clashes between slaves.
scrape_configs:
  - job_name: some_job
    # Add usual service discovery here, such as static_configs
    relabel_configs:
    - source_labels: [__address__]
      modulus:       4    # 4 slaves
      target_label:  __tmp_hash
      action:        hashmod
    - source_labels: [__tmp_hash]
      regex:         ^1$  # This is the 2nd slave
      action:        keep
```

---

Then we use federation to aggregate all the slaves:

```yaml
- scrape_config:
  - job_name: slaves
    honor_labels: true
    metrics_path: /federate
    params:
      match[]:
        - '{__name__=~"^slave:.*"}'   # Request all slave-level time series
    static_configs:
      - targets:
        - slave0:9090
        - slave1:9090
        - slave3:9090
        - slave4:9090
```

But again, I don't advocate this. Most people will never need to do it and it adds unnecessary
complication.

---

## High Availability

Prometheus can also be made highly available.

_Note: High Availability (HA) is a distributed setup which allows for the failure of one or more
services._

And thanks to Prometheus' simplicity, a HA mode is also very simple!

Remember that all Prom does is scrape targets and store them in a DB?

To make them HA, simply **run two Prometheus instances!**

Two scrape cycles, two databases. If one goes down, the other is still free to scrape!

---

### Not Entirely True

It's not _just_ about running two instances. Not quite, anyway.

The first problem is with dashboarding. The dashboards need to be able to connect to _either_
Prometheus instance. If one goes down, the dashboard needs to use the other.

This requires some sort of load balancing.

Since we're using Kubernetes, we can simply put multiple Prometheus pods behind the same service.

If your using something else then you might need to enable sticky sessions or something.

---

However, the slightly more tricky part is the Alertmanager.

Two Prometheuses will send send two alerts to the Alertmanager.

That's fine, it will de-duplicate.

But we also need to make the Alertmanager HA too.

---

### HA Alertmanager

We can make the Alertmanager HA by running multiple Alertmanagers. [docs](https://github.com/prometheus/alertmanager#high-availability)

But to make sure we don't send multiple alerts for the same problem, Alertmanager needs to
communicate with the other.

This is unfortunate, because it requires the two Alertmanagers to be synchronised, which usually
means complexity.

---

#### Prometheus Talks to Both

The first addition is that each Prometheus needs to talk to _both_ Alertmanagers.

I.e. if one Alertmanager goes down, both Prometheuses can talk to the one remaining.

This is easy to achieve in practice because we're using k8s to discover pods. We can use that.

---

Secondly, the Alertmanagers need to communicate with each other, so we need to connect them.

Alertmanager has a ([few](https://github.com/prometheus/alertmanager#high-availability)) command line options to specify that:

`-mesh.peer=alertmanager-2:9093`

Which is actually quite annoying. We're using K8s for service discovery in Prometheus, but for
alertmanager we're going to have to rely on DNS.

It uses the `Gossip` protocol to find other peers. So that means you only need to provide one
address and it will find all the other instances through the protocol.

However, this is actually quite difficult in Kubernetes because `kube-dns` doesn't expose name-based
dns entries (why!?).

So instead, we have to use two different separate k8s service.

But all of this is a moot point. If you really wanted a HA setup then they would be running in
separate clusters.

---

So imagine two copies of deployments and services.

Then one has:

```yaml
args:
  - '-config.file=/etc/alertmanager/config.yml'
  - '-mesh.peer=alertmanager-2.monitoring.svc.cluster.local:6783'
```

and the other has:

```yaml
args:
  - '-config.file=/etc/alertmanager/config.yml'
  - '-mesh.peer=alertmanager-1.monitoring.svc.cluster.local:6783'
```

---

## Hands On

---
