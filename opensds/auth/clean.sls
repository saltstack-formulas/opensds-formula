### opensds/auth/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

  {%- if opensds.auth.container.enabled %}

opensds auth container service stopped:
  docker_container.stopped:
    - name: {{ opensds.auth.service }}
    - error_on_removed:False

  {%- elif opensds.auth.container.composed %}

include:
  - opensds.stacks.clean

  {%- elif opensds.auth.provider == 'keystone' %}

include:
  - opensds.stacks.devstack.clean

  {% endif %}


  ## Cleanup opensds.conf file
  {% for section, configuration in opensds.auth.conf.items() %}

opensds config ensure osdsauth {{ section }} section removed:
  ini.sections_absent:
    - name: {{ opensds.conf }}
    - sections:
      - osdsauth

  {% endfor %}
