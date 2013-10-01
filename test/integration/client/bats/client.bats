#!/usr/bin/env bats

@test "Verfiy remote collectd server is configured" {
  grep example.com /etc/collectd/plugins/network.conf
}
