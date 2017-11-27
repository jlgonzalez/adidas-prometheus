# Training Deep Dive: Monitoring Microservices with Prometheus

This is an epic training course all about the Microservices monitoring application Prometheus.

See the [abstract](./abstract.md) for full details of content.

## Running the Presentation

This was developed using my own template. To run using that template:

```bash
cd slides
./build.sh
python3 -m http.server
```

This will concatenate the markdown files into a single file, then start a python http server. Then
just browse to: [http://localhost:8000](http://localhost:8000).

Alternatively, use the CS template.

## Workshop VMs

The workshops were created using this infrastructure:
[https://github.com/ContainerSolutions/training-modules/tree/b0f6095bda2277dc633965a36e34e6964d9e9244/infrastructure/docker-workshop](https://github.com/ContainerSolutions/training-modules/tree/b0f6095bda2277dc633965a36e34e6964d9e9244/infrastructure/docker-workshop)

Users will need to clone the workshop materials onto the VM.

Users can use the markdown files in github, or get a copy of the PDFs.

## Create the PDFs

To create the Slide PDFs, I've found it easiest just to use Chrome's `Print->Save as PDF` feature.

To create the workshop PDFs you will need pandoc installed.

Then run:

```bash
./pdfs
```
