###  opensds/infra/init.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{%- from "opensds/map.jinja" import opensds with context %}

include:
  {{ '- epel' if grains.os_family in ('RedHat',) else '' }}
  - packages.pips
  - packages.pkgs
  - packages.archives
  - golang
  - timezone
  - resolver.ng
  - docker
  - memcached
  - mysql.apparmor

    {%- if opensds.pkgs and opensds.pkgs is iterable and opensds.pkgs is not string %}
        {%- for p in opensds.pkgs %}
opensds infra pkgs install {{ p }}:
  pkg.installed:
    - name: {{ p }}
        {%- endfor %}
    {%- endif %}
