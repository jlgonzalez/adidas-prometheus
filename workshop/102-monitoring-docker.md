# Monitoring Microservices with Prometheus - Workshops

---

# 102: Monitoring Docker

In this workshop you will log into your VMs (or locally if you've chosen to develop locally) and run
some containers. You will apply some load and use docker's tools to inspect resource usage.

## Webservers!

Let's run a simple docker-compose file. Inside this file we're running:

- A webserver (nginx base image)
- ApacheBench (A HTTP load generator)

```bash
$ cd <workshop directory>/102-monitoring-docker
$ docker-compose up -d
```

## See What's Running

```bash
$ docker ps
```

## (If on Linux) Look at `cgroup` Aggregates

Take a look at the files:

- `/sys/fs/cgroup/memory/docker/<longid>/cpuacct.stat`
- `/sys/fs/cgroup/memory/docker/<longid>/memory.stat`


- What resource metrics can you see?
- How do these numbers map to physical resources?

## `docker stats`

Now try `docker stats`

```bash
$ docker stats --no-stream
```

_Note: If the load test container has finished you might need to do a `docker-compose down` and
rerun the command to start the container._

- What resource metrics can you see?
- How do these numbers map to physical resources?
- Do these map to the aggregates show above?

## Scale It!

```bash
$ docker-compose down
$ docker-compose up -d --scale web=3 --scale load=3
$ docker stats --no-stream
```

## `docker top`

Find one of your containers and use `docker top` to inspect the processes.

```bash
$ docker top 102monitoringdocker_web_1
PID                 USER                TIME                COMMAND
14000               root                0:00                nginx: master process nginx -g daemon off;
14305               chrony              0:00                nginx: worker process
```
