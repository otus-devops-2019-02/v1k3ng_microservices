FROM cloudprober/cloudprober

ADD cloudprober.cfg /etc/cloudprober.cfg
ENTRYPOINT sysctl -w net.ipv4.ping_group_range="0 5000" && ./cloudprober --logtostderr 