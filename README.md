Deploy Monitor
==============


Dependencies
------------

### QEMU
This image is designed to run on a Raspberry PI, to run it locally on your development machine, you need to install QEMU.

```bash
sudo apt-get install qemu-user-static
```
Configuration
-------------

### GitHub

Create `.netrc` file somewhere on the host filesystem.

```bash
machine api.github.com
  login defunkt
  password c0d3b4ssssss!
```

Link it to the container using a volume.

```bash
-v <path_to_netrc_file>:/root/.netrc
```

### Repositories


Build the image
---------------

```bash
docker build . -t lister/deploymonitor:`cat VERSION` -t lister/deploymonitor:latest
```

Run the container
-----------------

### Development
```bash
docker run -v $HOME/.netrc:/root/.netrc -v /var/run/docker.sock:/var/run/docker.sock -v /usr/bin/qemu-arm-static:/usr/bin/qemu-arm-static lister/deploymonitor
```

### Production

```bash
docker run lister/deploy-monitor -v /var/run/docker.sock:/var/run/docker.sock
```
