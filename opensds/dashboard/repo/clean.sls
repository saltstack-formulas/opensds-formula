###  opensds/dashboard/repo/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from "opensds/map.jinja" import opensds with context %}

opensds dashboard remove source directory:
  file.absent:
    - name: {{ golang.go_path }}/src/github.com/opensds/dashboard
    - onlyif: test -d {{ golang.go_path }}/src/github.com/opensds/dashboard
