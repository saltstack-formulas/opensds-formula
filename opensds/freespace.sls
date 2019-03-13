###  opensds/freespace.sls
# -*- coding: utf-8 -*-
# vim: ft=yaml
{%- from "opensds/map.jinja" import opensds with context %}

opensds freespace auto-remove debian packages:
  cmd.run:
    - name: apt autoremove -y
    - onlyif: {{ grains.os_family == 'Debian' }}

opensds freespace auto-prune docker:
  service.running:
    - name: docker
    - enable: True
    - onlyif: docker --version >/dev/null 2>&1
    - require_in:
      - cmd: opensds freespace auto-prune docker

  #####################################################################
  ##### Commented out due to https://github.com/docker/compose/issues/5745#issuecomment-370048997
  ##cmd.run:
  ##  - names:
  ##    echo $DOCKER_PASS | docker login -u$DOCKER_USER --password-stdin $DOCKER_HOST
  ##    docker system prune -a -f  ### do not run! See https://github.com/docker/compose/issues/5745#issuecomment-370048997
  ##    docker rm -v $(docker ps -a -q -f status=exited)
  ##    docker rmi -f  $(docker images -f "dangling=true" -q)
  ##    docker volume ls -qf dangling=true | xargs -r docker volume rm
  ##  onlyif: docker --version >/dev/null 2>&1
  ###################################################################

opensds freespace cleanup tmp dir:
  file.absent:
    - names:
      - /tmp/devstack
      - /tmp/go?.??.linux-amd64.tar.gz
      - /tmp/saltstack-packages-formula-archives
