# Visualisation 2: Templating with Prometheus

Remember that I said that Grafana can sometimes be too complicated?

Prometheus's key selling point is it's simplicity and Grafana can feel a bit... corporate.

We can do something else, templating.

---

## What is Templating?

- Server-side rendering of code, usually HTML.

How does this help?

- Because we can load the template into Prometheus and use an endpoint off the Prometheus API to
  access our rendered HTML.

Why is that simpler?

- Because the code is static! It's statically generated content. There's no users, no organisations,
  no complex dashboards. Only what you need.

---

## Introduction to Go Templates

- Under the hood, Prometheus is just using [Go Templates](https://golang.org/pkg/text/template/).

This is a mustache like syntax that is very powerful. It essentially allows you to access all of
Go's language possibilities in scripts. E.g. I use it for my websites in the static site generator
Hugo.

This is an example of a simple template:

---

```yaml
  simple.html: |
    {{template "head" .}}
    <h1>My Python Job!</h1>
    {{template "tail"}}
```

All internal functions are called using a "mustache" syntax. This one calls an external template
(e.g. another html file).

---

### Prometheus Templating Libraries

Prometheus has a range of helper functions: [https://github.com/prometheus/prometheus/blob/master/docs/configuration/template_reference.md](https://github.com/prometheus/prometheus/blob/master/docs/configuration/template_reference.md)

We can use these in our templates:

```yaml
  a.html: |
    {{template "head" .}}
    <h1>My Python Job!</h1>
    <tr>
      <th>Python-App (# Pods)</th>
      <th>
        {{ template "prom_query_drilldown" (args "sum(up{kubernetes_name='python-app'})") }} / {{ template "prom_query_drilldown" (args "count(up{kubernetes_name='python-app'})") }}
      </th>
    </tr>
    {{template "tail"}}
```

This calls a Prometheus helper function called `prom_query_drilldown`. It allows us to perform a
query and format the result.

---

### Using Go Functions

Here's another example with all the HTML trimmings. We're using Go's `range` function ([godocs](https://golang.org/pkg/text/template/#hdr-Actions)) to loop
through an array. Prometheus's `query` function returns raw results as a Go array.

```yaml
  b.html: |
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <title>Title</title>
    </head>
    <body>
        <h1>Jobs that are up:</h1>
        <ul>
        {{ range query "up" }}
          <li>
          {{ .Labels.kubernetes_name }} {{ .Labels.instance }} {{ .Value }}
          </li>
        {{ end }}
        </ul>
        <h1>My Python Job!</h1>
        <tr>
          <th>Python-App (# Pods)</th>
          <th>
            {{ template "prom_query_drilldown" (args "sum(up{kubernetes_name='python-app'})") }} / {{ template "prom_query_drilldown" (args "count(up{kubernetes_name='python-app'})") }}
          </th>
        </tr>
    </body>
    </html>
```

---

### A Plot

Finally, Prometheus provide's a little javascript script based upon D3.js to plot the data.

```yaml

  c.html: |
    {{template "head" .}}
    <h1>A plot</h1>
    <tr>
      <th>Python-App (# Pods)</th>
      <th>
        {{ template "prom_query_drilldown" (args "sum(up{kubernetes_name='python-app'})") }} / {{ template "prom_query_drilldown" (args "count(up{kubernetes_name='python-app'})") }}
      </th>
    </tr>
    <div id="queryGraph"></div>
    <script>
    new PromConsole.Graph({
      node: document.querySelector("#queryGraph"),
      expr: "sum(rate(http_request_duration_seconds_count[1m]))"
    })
    </script>
    {{template "tail"}}
```

The `head` template contains the required javascript libraries. The `PromConsole` class has some
more options: [see here](https://prometheus.io/docs/visualization/consoles/#graph-library).

---

## Misc. Templating Notes

- This is rendered on the server-side. You'll have to refresh the browser to load metrics.

- When you reload the template you'll have to restart Prometheus. (So you'll lose the data)

- Make sure your queries work in the Prometheus UI first. It's easier to debug.

- You can use `{{ printf "%#v" . }}` to print the current template context.

- The possibilities are endless!

---

### References

- [Go Templates](https://golang.org/pkg/text/template/)
- [Prometheus Function Reference](https://github.com/prometheus/prometheus/blob/master/docs/configuration/template_reference.md)
- [More examples](https://github.com/prometheus/prometheus/blob/master/docs/configuration/template_examples.md)

---

## Hands On

Let's try your hand at HTML.

Bonus points for the best templates!

---
