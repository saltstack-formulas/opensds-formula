# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

include:
  - packages.archives

opensds lang copy {{ opensds.controller.release }} archive content to {{ opensds.lang.home }} directory:
  file.copy:
    - name: {{ opensds.lang.home }}
    - source: {{ opensds.dir.tmp }}/{{ opensds.lang.home }}
    - makedirs: True
    - force: True
    - onlyif: test -d {{ opensds.dir.tmp }}/{{ opensds.lang.home }}
    - require_in:
      - environ: opensds lang {{ opensds.controller.release }} set langpath env
      - file: opensds lang {{ opensds.controller.release }} set system profile path

opensds lang {{ opensds.controller.release }} set langpath env:
  environ.setenv:
    - name: GOPATH
    - value: {{ opensds.lang.home }}/bin
    - update_minion: True
    - unless: test $GOPATH
    - onlyif: test -f {{ opensds.lang.home }}/bin/go
