###  opensds/dock/block/cinder/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from "opensds/map.jinja" import opensds with context %}

opensds dock cinder block service container stopped:
  docker_container.stopped:
    - name: {{ opensds.dock.block.cinder.service }}
    - error_on_absent: False
    - onlyif: {{ opensds.dock.block.cinder.container.enabled }}
