### opensds/auth/config.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

  ##Update opensds.conf file
  {% for section, configuration in opensds.auth.conf.items() %}

opensds auth config ensure osdsauth {{ section }} section exists:
  ini.sections_present:
    - name: {{ opensds.conf }}
    - sections:
      - osdsauth

     {%- for k, v in configuration.items() %}

opensds auth config ensure osdsauth {{ section }} {{ k }} exists:
  ini.options_present:
    - name: {{ opensds.conf }}
    - separator: '='
    - strict: True
    - sections:
        osdsauth:
          {{ k }}: {{ v }}
    - require:
      - opensds auth config ensure osdsauth {{ section }} section exists

     {%- endfor %}

  {% endfor %}
