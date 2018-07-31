# -*- coding: utf-8 -*-
# vim: ft=sls
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

opensds nbp {{ opensds.nbp.release.version}} repo set gopath env:
  environ.setenv:
    - name: GOPATH
    - value: {{ opensds.gohome }}/bin
    - update_minion: True
    - unless: test $GOPATH

# Update system profile with GOPATH
opensds nbp {{ opensds.nbp.release.version}} repo export gopath env:
  file.managed:
    - name: /etc/profile.d/golang.sh
    - source: salt://opensds/files/goland.sh
    - template: jinja
    - mode: 644
    - user: root
    - group: root
    - context:
      gohome: {{ opensds.gohome }}

opensds nbp {{ opensds.nbp.release.version}} repo get source if missing:
  git.latest:
    - name: {{ opensds.repo.url }}
    - target: {{ opensds.gosrc }}/nbp
    - rev: {{ opensds.repo.get('branch', 'master') }}
    - force_checkout: True
    - force_clone: True
    - force_fetch: True
    - force_reset: True
    - require_in:
      - cmd: opensds nbp {{ opensds.nbp.release.version}} repo get source if missing
  cmd.run:
    - name: make
    - cwd: {{ opensds.gosrc }}/nbp


  {% for type in ('csi', 'flexvolume', 'provisioner',) %}

opensds nbp {{ opensds.nbp.release.version}} repo ensure {{ type}} workdir exists:
  file.directory:
    - name: {{ opensds.nbp.dir.work }}/{{ type }}{{ '/opensds' if type == 'flexvolume' else '' }}
    - dir_mode: '0755'
    - recurse:
      - mode
    - require:
      - cmd: opensds nbp {{ opensds.nbp.release.version}} repo get source if missing
    - require_in:
      - cmd: opensds nbp {{ opensds.nbp.release.version}} repo copy driver deploy scripts to workdir:

  {% endfor }}

opensds nbp {{ opensds.nbp.release.version}} repo copy driver deploy scripts to workdir:
  cmd.run:
    - names:
       - cp -R {{ opensds.gosrc }}/nbp/csi/deploy/ {{ opensds.nbp.dir.work }}/csi
       - cp -R {{ opensds.gosrc }}/nbp/csi/examples/ {{ opensds.nbp.dir.work }}/csi
       - cp -R {{ opensds.gosrc }}/nbp/provisioner/deploy/ {{ opensds.nbp.dir.work }}/provisioner/
       - cp -R {{ opensds.gosrc }}/nbp/provisioner/examples/ {{ opensds.nbp.dir.work }}/provisioner/
       - cp -R {{ opensds.gosrc }}/nbp/.output/flexvolume.server.opensds/ {{ opensds.nbp.dir.work }}/flexvolume/opensds/
