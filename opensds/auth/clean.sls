### opensds/auth/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from "opensds/map.jinja" import opensds with context %}


    {%- if opensds.auth.container.enabled %}

opensds auth container service stopped:
  docker_container.stopped:
    - name: {{ opensds.auth.service }}
    - error_on_removed: False

      {%- if opensds.auth.provider in ('keystone', 'devstack',) %}
include:
  - devstack.remove
      {% endif %}

    {% endif %}

### opensds.conf ###
opensds config ensure osdsauth section removed from opensds.conf:
  ini.sections_absent:
    - name: {{ opensds.controller.conf }}
    - sections:
      - {{ opensds.auth.service }}
