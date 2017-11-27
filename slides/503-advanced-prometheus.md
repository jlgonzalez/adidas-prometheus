# 503: Advanced Prometheus

In this final section I will try and cover some of the more advanced features of Prometheus.

However, I'm not going to cover them in depth, because they aren't a core part of the Prometheus use
case.

---

## Storage

Prometheus includes an on-disk time series database, but also integrates with other remote storage
systems.

Prometheus isn't designed as a long-term data store. It defaults to only storing 15 days worth of
data.

Prometheus should be viewed as an ephemeral sliding window of recent data.

If you need better persistency or longer durations, think carefully about what you are doing.

[Storage presentation - Pre 2.0](https://www.youtube.com/watch?v=HbnGSNEjhUc)

---

### Local Storage

- A custom format

- Blocks of two-hours

- All stored in one `/data/` directory: `--storage.tsdb.path` setting

- Two hour blocks are eventually compacted into longer blocks in the background.

- Defaults to 15d storage: `--storage.tsdb.retention` setting

It uses around 2 bytes per sample so you can calculate the total disk space required:

`needed_disk_space = retention_time_seconds * ingested_samples_per_second * bytes_per_sample`

[More information on 2.0 storage layer improvements here](https://coreos.com/blog/prometheus-2.0-storage-layer-optimization)

---

### Remote Storage

Prometheus is not designed to store data. You should be able to wipe the data directory and carry on
without any issues.

If you want a longer term storage solution, use one of the
[remote storage integrations](https://prometheus.io/docs/operating/integrations/#remote-endpoints-and-storage).

Notable data stores:

- Graphite
- InfluxDB
- OpenTSDB
- PostgreSQL

---

## Security

As a rule of thumb, anyone with any access to any part of Prometheus has access to all the functionality
and data within.

So all instances should be locked down on locked networks.

If you need external access then they should be placed behind API gateways or reverse proxies that
implement authentication and authorisation.

Prometheus does not offer any encryption, authentication or authorisation. This is part of its
simplicity.

---

## Wire Formats

- Text format (we've used this the whole time)
  * Human-readable
  * Easy to assemble, especially for minimalistic cases (no nesting required)
  * Readable line by line (with the exception of type hints and docstrings)
  * Verbose
  * Types and docstrings not integral part of the syntax, meaning little-to-nonexistent metric
      contract validation
  * Parsing cost

---

- Protocol Buffer Format
  * Cross-platform
  * Size
  * Encoding and decoding costs
  * Strict schema
  * Supports concatenation and theoretically streaming (only server-side behavior would need to
    change)
  * Not human-readable

The text format is nice, human readable, but verbose. Consider moving to ProtoBuf if you have lots
to scrape.

---

## Kubernetes Operator

Even though we haven't tried it today (we concentrated on core prometheus) CoreOS have developed a
[Prometheus Operator for Kubernetes](https://coreos.com/operators/prometheus/docs/latest/user-guides/getting-started.html).

This simplifies the initial setup of Prometheus on Kubernetes.

Definitely check it out if you're using this on Kubernetes.

---

## Performance

Since the 2.0 upgrade, much of the "tweaking" that was performed to optimise memory and disk usage
has gone.

[CoreOS reports](https://coreos.com/blog/prometheus-2.0-storage-layer-optimization) significant
improvements in memory usage and memory consistency (good for container setups where we have to set
limits!).

- Mem usage reduced by a factor of 3
- CPU usage reduced by a factor of 5
- Disk I/O reduced by factor of 80
- Storage space reduced by a factor of 5

Java Client benchmarks show that it takes around 1-20ns to write to a metric, depending on the type.
[source](https://github.com/prometheus/client_java/blob/master/benchmark/README.md). So it is highly
unlikely to cause you any issues on the client side.

---

## Thats It!

- If you're interested in the Data Science, check out https://TrainingDataScience.com, an attempt to
  bring data science to Software Engineers by Phil Winder.

- If there is anything that you think should belong in this traing, please let us know.

- If some of it was too hard, or too difficult, please let us know.

- I've also provided an appendix which has links to loads more documentation, talks and blog posts.

Thanks!

---


