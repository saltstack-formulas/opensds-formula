# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

include:
  - packages.archives

opensds lang copy {{ opensds.controller.release }} archive content to {{ opensds.stacks.lang.home }} directory:
  file.copy:
    - name: {{ opensds.stacks.lang.home }}
    - source: {{ opensds.dir.tmp }}/{{ opensds.stacks.lang.home }}
    - makedirs: True
    - force: True
    - onlyif: test -d {{ opensds.dir.tmp }}/{{ opensds.stacks.lang.home }}
    - require_in:
      - environ: opensds lang {{ opensds.controller.release }} set langpath env
      - file: opensds lang {{ opensds.controller.release }} set system profile path

opensds lang {{ opensds.controller.release }} set langpath env:
  environ.setenv:
    - name: GOPATH
    - value: {{ opensds.stacks.lang.home }}/bin
    - update_minion: True
    - unless: test $GOPATH
    - onlyif: test -f {{ opensds.stacks.lang.home }}/bin/go
