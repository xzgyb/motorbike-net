environment "production"

bind "tcp://0.0.0.0:80"
pidfile "/home/sunqp/motorbike-net/tmp/pids/puma.pid"
state_path "/home/sunqp/motorbike-net/tmp/sockets/puma.state"
directory "/home/sunqp/motorbike-net"

workers 3
threads 0,16