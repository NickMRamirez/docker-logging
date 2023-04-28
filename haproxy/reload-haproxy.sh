#! /bin/bash

cp /vagrant/haproxy/haproxy.cfg /etc/haproxy/
systemctl reload haproxy