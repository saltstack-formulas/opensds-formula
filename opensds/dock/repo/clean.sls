###  opensds/dock/repo/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{%- from "opensds/map.jinja" import opensds with context %}

    {%- if opensds.deploy_project not in ('gelato',)  %}
        {%- for id in opensds.database.ids %}

opensds database repo {{ id }} ensure directory removed:
  file.absent:
    - name: {{ opensds.dir.hotpot + '/' + id }}

        {%- endfor %}
    {%- endif %}
