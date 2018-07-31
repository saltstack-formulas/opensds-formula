# -*- coding: utf-8 -*-
# vim: ft=sls
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

  {%- if not opensds.let.container.enabled %}

    {%- for i in 1..5 %}
opensds let start daemon service attempt {{ loop.index }}:
  cmd.run:
    - name: nohup {{opensds.dir.work}}/bin/osdslet >{{opensds.dir.log}}/osdslet.out 2> {{opensds.dir.log}}/osdslet.err &
    - unless: ps aux | grep osdslet | grep -v grep
    - onlyif: sleep 5
    {% endfor %}

  {%- endif %}
