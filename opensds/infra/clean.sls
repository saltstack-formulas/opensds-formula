### opensds/infra/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{%- from "opensds/map.jinja" import opensds with context %}

include:
  # golang.remove         ## need remove state
  - docker.remove
  - memcached.uninstall
  - devstack.remove
  - opensds.infra.conflicts.clean
  - devstack.remove

   {%- if opensds.pkgs %}

opensds infra required packages purged:
  pkg.purged:
    - names: {{ opensds.pkgs }}

  {%- endif %}
