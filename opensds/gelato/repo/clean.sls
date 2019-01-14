###  opensds/gelato/repo/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from "opensds/map.jinja" import opensds, golang with context %}

opensds gelato remove source directory:
  file.absent:
    - name: {{ golang.go_path }}/src/github.com/opensds/multi-cloud
    - onlyif:
      - test -d {{ golang.go_path }}/src/github.com/opensds/multi-cloud
      - test '{{ opensds.gelato.provider }}' = 'repo'
