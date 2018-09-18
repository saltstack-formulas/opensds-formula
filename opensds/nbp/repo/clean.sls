### opensds/nbp/repo/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "opensds/map.jinja" import opensds with context %}

opensds nbp repo {{ driver }} directory removed:
  file.absent:
    - names:
      - {{ golang.go_path }}/github.com/opensds/nbp
    {% for driver in opensds.nbp.plugins %}
      - {{ opensds.nbp.dir.work }}/{{ driver }}/deploy
      - {{ opensds.nbp.dir.work }}/{{ driver }}/examples
    {% endfor %}
