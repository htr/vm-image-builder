# vm image builder

This repo contains a almost-ready-to-use Debian VM image builder.


### Quickstart

DigitalOcean droplet:

* run `./build-digitalocean.sh`. You'll get a DigitalOcean ready image in `output/nixos.qcow2.gz`. This image will configure the hostname and root's ssh keys.

Generic VM image:

* take a look at [configuration.nix](./artifacts/configuration.nix). You might want to configure a user or root's ssh keys. Run `./build-generic.sh`. The generated image will be created in `output/nixos.qcow2.gz`.


### Running locally

The [runner script](./run.sh) allows you to quickly run the image locally:
```shell
./run.sh -i test.qcow2
```

you should be able to login locally:
```
ssh root@localhost -p50022
```


### Uploading to a cloud provider
The qcow2 format is supported by many cloud providers as is. During boot, the image will use any cloud-init configuration available (ssh keys, network configuration, etc).

Personally, I like to shrink the image to the smallest possible size before uploading it:

```shell
$ virt-sparsify test.qcow2 test-sparse.qcow2 # you might need to run this as root

$ pigz test-sparse.qcow2

```

I use [do-image-uploader](https://github.com/htr/do-image-uploader) to upload my images to DigitalOcean:

```shell
$ export DO_API_TOKEN=$(pass show do-tokens/personal)
$ do-image-uploader --image-file=test-sparse.qcow2.gz --region=fra1 --name=test-image --wait-until-available

```

