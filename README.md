# Syslog forwarding with HAProxy and Docker

Demonstrates using `log-forward` to forward logs from the Docker daemon.

## Run it

1. Create the environment:

   ```
   $ vagrant up
   ```

2. SSH onto the HAProxy machine, where Docker is also installed.

   ```
   $ vagrant ssh haproxy
   ```

3. Start a Docker container:

   ```
   $ sudo docker run -p 80:80 -it --rm nginx:latest
   ```

   You can then make requests to it via http://192.168.56.41.

4. SSH onto the syslog server:

   ```
   $ vagrant ssh syslog1
   ```

5. Start the rsyslog Docker container, which listens for incoming messages with the *local1* facility:

   ```
   $ cd /vagrant/syslog1
   $ sudo docker compose -f docker-compose.rsyslog.yml up -d
   ```

5. Watch the NGINX logs come through on the syslog server:

   ```
   $ sudo docker compose -f docker-compose.rsyslog.yml logs -f syslog1
   ```

## Delete the environment

- Run `vagrant destroy`:

```
$ vagrant destroy
```