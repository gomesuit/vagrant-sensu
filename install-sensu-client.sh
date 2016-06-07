#!/bin/sh

NODENAME=$1
IP_ADDRESS=$2

cat <<EOF > /etc/yum.repos.d/sensu.repo
[sensu]
name=sensu-main
baseurl=http://repos.sensuapp.org/yum/el/\$releasever/\$basearch/
gpgcheck=0
enabled=1
EOF

yum install -y sensu

cat <<EOF > /etc/sensu/conf.d/rabbitmq.json
{
  "rabbitmq": {
    "host": "server",
    "port": 5672,
    "vhost": "/sensu",
    "user": "sensu",
    "password": "rabbitmq-sensu-password"
  }
}
EOF

cat <<EOF > /etc/sensu/conf.d/client.json
{
  "client": {
    "name": "$NODENAME",
    "address": "$IP_ADDRESS",
    "subscriptions": [ "all" ]
  }
}
EOF

/etc/init.d/sensu-client start
