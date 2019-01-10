###  opensds/gelato/repo/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from "opensds/map.jinja" import opensds with context %}

opensds gelato remove source directory:
  file.absent:
    - name: {{ golang.go_path }}/src/github.com/opensds/multi-cloud
    - onlyif: test -d {{ golang.go_path }}/src/github.com/opensds/multi-cloud
    - onlyif: {{ opensds.gelato.provider }} = 'repo'
