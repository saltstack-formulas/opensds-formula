### opensds/infra/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{%- from "opensds/map.jinja" import opensds with context %}

include:
  # golang.remove         ## need remove state
  - docker.remove
  # memcached.uninstall
  - apache.uninstall      ### manages port 80
  # nginx.ng.clean        ### https://github.com/saltstack-formulas/nginx-formula/issues/214

   {%- if opensds.pkgs %}

opensds infra required packages purged:
  pkg.purged:
    - names: {{ opensds.pkgs }}

  {%- endif %}
