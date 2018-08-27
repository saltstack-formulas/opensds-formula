# -*- coding: utf-8 -*-
# vim: ft=sls
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

  {%- if opensds.let.container.enabled %}

opensds let {{ opensds.controller.release }} container service running:
  docker_container.running:
    - name: {{ opensds.let.service }}
    - image: {{ opensds.let.container.image }}
    - restart_policy: always
    - network_mode: host
    - unless: {{ opensds.let.container.compose }}

  {% else %}

    {%- for i in 1..5 %}
opensds let start daemon service attempt {{ loop.index }}:
  cmd.run:
    - name: nohup {{opensds.dir.work}}/bin/osdslet >{{opensds.dir.log}}/osdslet.out 2> {{opensds.dir.log}}/osdslet.err &
    - unless: ps aux | grep osdslet | grep -v grep
    - onlyif: sleep 5
    {% endfor %}

  {%- endif %}
