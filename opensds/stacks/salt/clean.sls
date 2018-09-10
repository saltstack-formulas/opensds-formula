###  stacks/salt/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{% from  tpldir ~ "/map.jinja" import opensds with context %}

  {%- for name, url in opensds.stacks.salt.solutions.items() %}

opensds stacks salt {{ name }} repo removed:
  file.absent:
    - name:
      - {{ opensds.stacks.salt.basedirs.states }}/{{ name }}
      - {{ opensds.stacks.salt.basedirs.formula }}/{{ name }}

  {%- endfor %}
