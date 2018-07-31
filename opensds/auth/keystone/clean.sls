# -*- coding: utf-8 -*-
# vim: ft=yaml
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

opensds auth uninstall keystone service:
  file.managed:
    - name: {{ opensds.tmpdir }}/script/keystone.sh
    - source: salt://opensds/files/script/keystone.sh
    - user: root
    - group: root
    - mode: 700
    - makedirs: True
  cmd.run:
    - name: {{ opensds.dir.tmp }}/script/keystone.sh uninstall
    - output_loglevel: 'quiet'
    - onlyif: {{ opensds.auth.uninstall }}
    - require:
      - file: opensds auth uninstall keystone service
    - env:
      - DEST: {{ opensds.dir.log }}
      - DEV_STACK_DIR: {{ opensds.dir.devstack }}
      - HOST_IP: {{ grains.fqdn_ip4 or grains.fqdn_ip6 }}
      - OPENSDS_VERSION: {{ opensds.release.version }}
      - OPENSDS_CONFIG_DIR: {{ opensds.dir.config }}
      - OPENSDS_SERVER_NAME: {{ grains.host }}
      - STACK_BRANCH: {{ opensds.devstack.repo.branch }}
      - STACK_GIT_BASE: {{ opensds.devstack.repo.uri }}
      - STACK_HOME: {{ opensds.devstack.basedir }}
      - STACK_USER_NAME: {{ opensds.devstack.username }}
      - STACK_PASSWORD: {{ opensds.devstack.password }}
      - TOP_DIR: {{ opensds.dir.tmp }}/script             {# ?? #}

opensds auth cleanup keystone service:
  cmd.run:
    - name: {{ opensds.dir.tmp }}/script/keystone.sh cleanup
    - output_loglevel: 'quiet'
    - onlyif: {{ opensds.auth.cleanup }}
    - require:
      - cmd: opensds auth uninstall keystone service
    - env:
      - DEST: {{ opensds.dir.log }}
      - DEV_STACK_DIR: {{ opensds.dir.devstack }}
      - HOST_IP: {{ grains.fqdn_ip4 or grains.fqdn_ip6 }}
      - OPENSDS_VERSION: {{ opensds.release.version }}
      - OPENSDS_CONFIG_DIR: {{ opensds.dir.config }}
      - OPENSDS_SERVER_NAME: {{ grains.host }}
      - STACK_BRANCH: {{ opensds.devstack.repo.branch }}
      - STACK_GIT_BASE: {{ opensds.devstack.repo.uri }}
      - STACK_HOME: {{ opensds.devstack.basedir }}
      - STACK_USER_NAME: {{ opensds.devstack.username }}
      - STACK_PASSWORD: {{ opensds.devstack.password }}
      - TOP_DIR: {{ opensds.dir.tmp }}/script             {# ?? #}
