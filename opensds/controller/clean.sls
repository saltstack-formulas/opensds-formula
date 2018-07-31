# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

  {%- if opensds.controller.container.enabled %}
    {%- if "controller" in docker.compose and docker.compose.controller.container_name is defined %}

opensds controller container service stopped:
  docker_container.stopped:
    - names:
       - docker.compose.controller.container_name

    {% endif %}
  {% else %}

  # update PATH
opensds controller {{ opensds.controller.release }} ensure system profile file absent:
  file.absent:
    - name: /etc/profile.d/opensds.sh

    {% endif %}
