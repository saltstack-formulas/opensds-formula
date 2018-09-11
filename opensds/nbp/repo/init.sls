###  opensds/nbp/repo/init.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{% from salt.file.dirname(tpldir) ~ "/map.jinja" import opensds with context %}

include:
  - opensds.stacks

opensds nbp {{ opensds.nbp.release.version }} repo get source if missing:
  git.latest:
    - name: {{ opensds.repo.url }}
    - target: {{ opensds.lang.home }}/{{ opensds.lang.src }}/nbp
    - rev: {{ opensds.repo.get('branch', 'master') }}
    - force_checkout: True
    - force_clone: True
    - force_fetch: True
    - force_reset: True
    - require_in:
      - cmd: opensds nbp {{ opensds.nbp.release.version }} repo get source if missing
  cmd.run:
    - name: make
    - cwd: {{ opensds.langsrc }}/nbp


  {% for type in opensds.nbp.plugin.types %}

opensds nbp {{ opensds.nbp.release.version }} repo ensure {{ type }} workdir exists:
  file.directory:
    - name: {{ opensds.nbp.dir.work }}/{{ type }}{{ '/opensds' if type == 'flexvolume' else '' }}
    - dir_mode: '0755'
    - recurse:
      - mode
    - require:
      - cmd: opensds nbp {{ opensds.nbp.release.version }} repo get source if missing
    - require_in:
      - cmd: opensds nbp {{ opensds.nbp.release.version }} repo copy driver deploy scripts to workdir:

  {% endfor }}


opensds nbp {{ opensds.nbp.release.version }} repo copy driver deploy scripts to workdir:
  cmd.run:
    - names:
       - cp -R {{ opensds.lang.src }}/nbp/csi/deploy/ {{ opensds.nbp.dir.work }}/csi/
       - cp -R {{ opensds.lang.src }}/nbp/csi/examples/ {{ opensds.nbp.dir.work }}/csi/
       - cp -R {{ opensds.lang.src }}/nbp/provisioner/deploy/ {{ opensds.nbp.dir.work }}/provisioner/
       - cp -R {{ opensds.lang.src }}/nbp/provisioner/examples/ {{ opensds.nbp.dir.work }}/provisioner/
       - cp -R {{ opensds.lang.src }}/nbp/.output/flexvolume.server.opensds/ {{ opensds.nbp.dir.work }}/flexvolume/opensds/

