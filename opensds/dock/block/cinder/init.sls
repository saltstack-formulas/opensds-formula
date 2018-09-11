###  opensds/dock/block/cinder/init.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

include:
  - docker.remove
  - opensds.stacks

opensds dock block cinder loci packages:
  pkg.installed:
    - pkgs:
       {{ getlist(opensds.dock.loci.pkgs, true) }}

opensds dock block cinder loci ensure docker service running:
  service.running:
    - name: docker
    - enable: True

opensds dock block cinder loci build from source:
  file.directory:
    - name: /tmp/{{ opensds.dir.work }}/cinder
    - makedirs: True
  cmd.run:
    - cwd: /tmp/{{ opensds.dir.work }}/cinder
    - name: {{ opensds.dock.loci.docker_build_cmd }} && curl -o docker-compose.yml https://raw.githubusercontent.com/openstack/cinder/master/contrib/block-box/docker-compose.yml && docker-compose up
    - onlyif: echo $DOCKER_PASS | docker login -u$DOCKER_USER --password-stdin $DOCKER_HOST

