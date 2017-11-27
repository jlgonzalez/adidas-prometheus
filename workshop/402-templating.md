# 402: Templating

You can use Prometheus to render Go-based HTML templates on the server side. All templates are
available at: `http://<public_ip:9090/consoles/<template_filename>`.

Again we use
[Kubernetes ConfigMap's](https://kubernetes.io/docs/tasks/configure-pod-container/configmap/) to
store our template definition. This allows us to version control the template. If you did this for
real, you wouldn't put it all in one giant file!

## References

You'll probably need take a look at the documentation to do anything cool. Here are some references:

- [Go Templates](https://golang.org/pkg/text/template/)
- [Prometheus Function Reference](https://github.com/prometheus/prometheus/blob/master/docs/configuration/template_reference.md)
- [More examples](https://github.com/prometheus/prometheus/blob/master/docs/configuration/template_examples.md)

## Clean up

Remove all previous containers/k8s pods/docker-compose's etc.

```bash
$ cd <workshop directory>/401-grafana
$ kubectl delete -f manifest.yml
```

## Install Prometheus With Example Templates

```bash
$ cd <workshop directory>/402-templating
$ kubectl apply -f manifest.yml
```

Browse to:

- `http://<public_ip:9090/consoles/simple.html`
- `http://<public_ip:9090/consoles/a.html`
- `http://<public_ip:9090/consoles/b.html`
- `http://<public_ip:9090/consoles/c.html`

To see the examples I showed in the slides.

You can see these defined in the manifest: `402-templating/manifest.yml#L429`.

## Tasks

- Add a new template. Start simple.
  - Add your template to the manifest
  - Apply the new template
  - Restart the prometheus pod to force a configuration refresh

_Note: you can also refresh the config on a live system with: `curl -X POST
http://<public_ip>:9090/-/reload`

- Make the template more complex. Again, try and recreate something that would be useful to you in
  production.
- Add your app and add a template for that.

You're only limited by your imagination here. Go wild.

## A Little Crazy

- Ajax requests to the k8s API server to scale up your pod?
- Dropdown box to allow you to select different K8s namespaces to monitor?
- Monitoring Roulette: A button to present a random metric...
