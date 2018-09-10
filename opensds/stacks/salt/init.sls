### stacks/salt/init.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{% from  tpldir ~ "/map.jinja" import opensds with context %}

  {%- for dir in [opensds.stacks.salt.basedir,] %}
opensds stacks salt {{ dir }} directory created:
  file.directory:
    - name: {{ dir }}
    - makedirs: True
    - user: {{ opensds.user }}
    - dir_mode: {{ opensds.dir_mode }}
    - recurse:
      - user
      - mode
  {%- endfor %}

  {%- for name, url in opensds.stacks.salt.solutions.items() %}
opensds stacks salt {{ name }} repo cloned:
  git.latest:
    - name: {{ url }}
    - target: {{ opensds.stacks.salt.basedirs.formula }}/{{ name }}
    - user: {{ opensds.user }}
  file.symlink:
    - name: {{ opensds.stacks.salt.basedirs.states }}/{{ name }}
    - target: {{ opensds.stacks.salt.basedirs.formula }}/{{ name }}/{{ name if name in opensds.stacks.salt.basedirs.formula else '' }}
    - force: True
    - makedirs: True
    - force_clone: True
    - user: {{ opensds.user }}
  {%- endfor %}
