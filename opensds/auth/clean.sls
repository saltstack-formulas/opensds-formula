# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

  {%- if opensds.auth.container.enabled %}

opensds auth container service stopped:
  docker_container.stopped:
    - names:
       - {{ opensds.auth.service }}
      {%- if opensds.auth.container.compose and "osdsauth" in docker.compose %}
       - {{ docker.compose.osdsauth.container_name }}
      {%- endif %}
    - error_on_removed:False

  {%- else %}

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
