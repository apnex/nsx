#!/bin/bash

dnf install -y tcpdump
dnf install -y boost-filesystem

#dnf install -y PyYAML # fail
dnf install -y python3-yaml # alternate?

dnf install -y boost-iostreams
dnf install -y boost-chrono
dnf install -y python3-mako
dnf install -y python3-netaddr
dnf install -y python3-six
dnf install -y gperftools-libs
dnf install -y libunwind

# dnf install -y libelf-dev # fail
dnf install -y elfutils-libelf-devel # alternate?

dnf install -y snappy
dnf install -y boost-date-time
dnf install -y c-ares
dnf install -y redhat-lsb-core
dnf install -y wget
dnf install -y net-tools
dnf install -y dnf-utils
dnf install -y lsof
dnf install -y python3-gevent
dnf install -y libev
dnf install -y python3-greenlet
dnf install -y libvirt-libs
