###  opensds/config.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "opensds/map.jinja" import opensds, golang, devstack with context %}

include:
  {{ '- epel' if grains.os_family in ('RedHat',) else '' }}
  - packages.pips
  - packages.pkgs
  - packages.archives
  - golang
  - docker.compose

opensds config ensure directories exists:
  file.directory:
    - names:
      {%- for k, v in opensds.dir.items() %}
      - {{ v }}
      {%- endfor %}
    - makedirs: True
    - force: True
    - user: {{ opensds.user or 'root' }}
    - dir_mode: {{ opensds.dir_mode or '0755' }}
    - recurse:
      - user
      - mode

opensds config ensure opensds conf exists:
  file.managed:
   - name: {{ opensds.hotpot.conf }}
   - makedirs: True
   - replace: False
   - user: root
   - mode: {{ opensds.file_mode or '0644' }}

opensds config ensure docker running:
  service.running:
    - name: docker
    - enable: True
  #cmd.run:
  #  - name: echo $DOCKER_PASS | docker login -u$DOCKER_USER --password-stdin $DOCKER_HOST

### sdsrc
opensds config sdsrc file generated:
  file.managed:
    - name: {{ opensds.dir.hotpot }}/sdsrc
    - source: salt://opensds/files/sdsrc.jinja
    - makedirs: True
    - template: jinja
    - user: {{ opensds.user or 'root' }}
    - mode: {{ opensds.file_mode or '0644' }}
    - context:
      golang: {{ golang }}
      devstack: {{ devstack }}
      opensds: {{ opensds }}
