### opensds/test.sls
{% from "opensds/map.jinja" import opensds, driver, docker, firewalld, golang, ceph, devstack with context %}

opensds dump the dicts and fail:
  test.show_notification:
    - text: |
        Dumping values of opensds, driver, docker, firewalld, golang, ceph, devstack

{{ opensds }}

{{ driver }}

{{ docker }}

{{ firewalld }}

{{ golang }}

{{ ceph }}

{{ devstack }}

