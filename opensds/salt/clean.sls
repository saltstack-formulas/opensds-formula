# -*- coding: utf-8 -*-
# vim: ft=sls
{% from  tpldir ~ "/map.jinja" import opensds with context %}

  {%- for name, url in opensds.salt.solutions.items() %}

opensds salt {{ name }} repo removed:
  file.absent:
    - name:
      - {{ opensds.salt.basedirs.states }}/{{ name }}
      - {{ opensds.salt.basedirs.formula }}/{{ name }}

  {%- endfor %}
