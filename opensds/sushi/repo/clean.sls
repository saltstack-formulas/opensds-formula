### opensds/sushi/repo/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "opensds/map.jinja" import opensds, golang with context %}

opensds sushi repo {{ driver }} directory removed:
  file.absent:
    - names:
      - {{ golang.go_path }}/github.com/opensds/sushi
    {% for driver in opensds.sushi.plugins %}
      - {{ opensds.sushi.dir.work }}/{{ driver }}/deploy
      - {{ opensds.sushi.dir.work }}/{{ driver }}/examples
    {% endfor %}
