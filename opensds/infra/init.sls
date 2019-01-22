###  opensds/infra/init.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from "opensds/map.jinja" import opensds with context %}


include:
  - timezone
  - resolver.ng
  {{ '- epel' if grains.os_family in ('Redhat',) else '' }}
  - packages.pips
  - packages.pkgs
  - packages.archives
  - opensds.infra.docker
  - opensds.infra.profile
  - memcached
  - mysql.apparmor
  - devstack.user
  - opensds.infra.conflicts.init
  - devstack.install
  - opensds.infra.conflicts.clean

  {%- if opensds.pkgs %}

opensds infra ensure required packages installed:
  pkg.installed:
    - names: {{ opensds.pkgs }}

  {%- endif %}
   
opensds infra ensure opensds dirs exist:
  file.directory:
    - names:
      {%- for k, v in opensds.dir.items() %}
      - {{ v }}
      {%- endfor %}
    - makedirs: True
    - force: True
    - user: {{ opensds.user or 'root' }}
    - dir_mode: {{ opensds.dir_mode or '0755' }}
    - recurse:
      - user
      - mode

