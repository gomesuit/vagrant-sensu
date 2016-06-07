#!/bin/sh

yum install -y rabbitmq-server

systemctl start rabbitmq-server

cat <<EOF > /etc/rabbitmq/rabbitmq.config
[
    {rabbit, [
    {ssl_listeners, [5671]},
    {ssl_options, [{cacertfile,"/etc/rabbitmq/ssl/cacert.pem"},
                   {certfile,"/etc/rabbitmq/ssl/cert.pem"},
                   {keyfile,"/etc/rabbitmq/ssl/key.pem"},
                   {verify,verify_peer},
                   {fail_if_no_peer_cert,true}]}
  ]}
].
EOF

systemctl restart rabbitmq-server.service


rabbitmqctl add_vhost /sensu
rabbitmqctl add_user sensu rabbitmq-sensu-password
rabbitmqctl set_permissions -p /sensu sensu ".*" ".*" ".*"
rabbitmq-plugins enable rabbitmq_management
service rabbitmq-server restart
rabbitmqctl add_user admin rabbitmq-admin-password
rabbitmqctl set_user_tags admin administrator
systemctl restart rabbitmq-server.service

yum install -y redis
systemctl start redis

cat <<EOF > /etc/yum.repos.d/sensu.repo
[sensu]
name=sensu-main
baseurl=http://repos.sensuapp.org/yum/el/$releasever/$basearch/
gpgcheck=0
enabled=1
EOF

yum install -y sensu

cat <<EOF > /etc/sensu/conf.d/rabbitmq.json
{
  "rabbitmq": {
    "ssl": {
      "cert_chain_file": "/etc/sensu/ssl/cert.pem",
      "private_key_file": "/etc/sensu/ssl/key.pem"
    },
    "host": "localhost",
    "port": 5671,
    "vhost": "/sensu",
    "user": "sensu",
    "password": "rabbitmq-sensu-password"
  }
}
EOF

cat <<EOF > /etc/sensu/conf.d/redis.json
{
  "redis": {
    "host": "localhost",
    "port": 6379
  }
}
EOF

cat <<EOF > /etc/sensu/conf.d/api.json
{
  "api": {
    "host": "localhost",
    "port": 4567,
    "user": "admin",
    "password": "sensu-api-admin-password"
  }
}
EOF

cat <<EOF > /etc/sensu/conf.d/client.json
{
  "client": {
    "name": "Sensu-Server",
    "address": "127.0.0.1",
    "subscriptions": [ "all" ]
  }
}
EOF

/etc/init.d/sensu-server start
/etc/init.d/sensu-client start
/etc/init.d/sensu-api start

yum install -y uchiwa

vi /etc/sensu/uchiwa.json

/etc/init.d/uchiwa start
