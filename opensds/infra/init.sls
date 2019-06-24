###  opensds/infra/init.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{%- from "opensds/map.jinja" import opensds with context %}

include:
  {{ '- epel' if grains.os_family in ('RedHat',) else '' }}
  - packages.pkgs
  - packages.pips
  - packages.archives
  - golang
  - timezone
  - resolver.ng
  - docker
  - memcached
  - mysql.apparmor
  - apache      ### manages port 80
  - nginx       ### manages port 8088 (daemon or container)


    {%- if opensds.pkgs and opensds.pkgs is iterable and opensds.pkgs is not string %}
        {%- for p in opensds.pkgs %}
opensds infra pkgs install {{ p }}:
  pkg.installed:
    - name: {{ p }}
        {%- endfor %}
    {%- endif %}
