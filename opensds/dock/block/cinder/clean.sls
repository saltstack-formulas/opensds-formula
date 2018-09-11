###  opensds/dock/block/cinder/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

opensds dock block cinder loci docker compose down:
  cmd.run:
    - cwd: /tmp/{{ opensds.dir.work }}/cinder
    - name: docker-compose down
