# -*- coding: utf-8 -*-
# vim: ft=sls
{% from  tpldir ~ "/map.jinja" import opensds with context %}

  {%- for dir in [opensds.salt.basedir,] %}
opensds salt {{ dir }} directory created:
  file.directory:
    - name: {{ dir }}
    - makedirs: True
    - user: {{ opensds.user }}
    - dir_mode: {{ opensds.dir_mode }}
    - recurse:
      - user
      - mode
  {%- endfor %}

  {%- for name, url in opensds.salt.solutions.items() %}
opensds salt {{ name }} repo cloned:
  git.latest:
    - name: {{ url }}
    - target: {{ opensds.salt.basedirs.formula }}/{{ name }}
    - user: {{ opensds.user }}
  file.symlink:
    - name: {{ opensds.salt.basedirs.states }}/{{ name }}
    - target: {{ opensds.salt.basedirs.formula }}/{{ name }}/{{ name if name in opensds.salt.basedirs.formula else '' }}
    - force: True
    - makedirs: True
    - force_clone: True
    - user: {{ opensds.user }}
  {%- endfor %}
