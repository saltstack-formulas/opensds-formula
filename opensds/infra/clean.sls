### opensds/infra/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml

include:
  # golang.remove         ## need remove state
  - docker.remove
  - memcached.uninstall
  - devstack.remove
  - opensds.infra.conflicts.clean
  - golang.remove
  - devstack.remove

   {%- if opensds.pkgs %}

opensds infra required packages purged:
  pkg.purged:
    - names: {{ opensds.pkgs }}

  {%- endif %}
