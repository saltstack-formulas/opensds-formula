# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "opensds/map.jinja" import opensds with context %}

include:
  - opensds.let.clean

opensds kill osds containerized services:
  docker_container.stopped:
    - containers:
      - {{ opensds.svc.let.controller.docker_img }}
      - {{ opensds.svc.dock.docker_img }}
    - onlyif: {{ opensds.svc.let.container_enabled }} || {{ opensds.svc.dock.container_enabled }}

  {% for dir in [opensds.prefix, opensds.tmpdir, opensds.cfgdir, opensds.logdir,] %}
opensds clean release {{ dir }} files:
  file.absent:
    name: {{ dir }}
    require:
      - docker_container: opensds kill osds containerized services
  {% endfor %}

opensds clean opensds csi plugin if csi plugin specified:
  cmd.run:
    - name: . /etc/profile && kubectl delete -f deploy/kubernetes
    - cwd: {{ opensds.sds.prefix }}/csi
    - onlyif: test "{{ opensds.nbp.type|lower }}" == "csi"

  {% for dir in [opensds.nbp.prefix, opensds.nbp.tmpdir, opensds.nbp.flexvoldir,] %}
opensds clean nbp {{ dir }} release files:
  file.absent:
    name: {{ dir }}
    require:
      - docker_container: opensds kill osds containerized services
  {% endfor %}

  {% if opensds.svc.dock.backend|lower == "lvm" %}

    {% for vg in opensds.backend.lvm.vg %}
remove {{ vg }} volume group if lvm backend specified:
  lvm.vg_absent:
    - name: {{ vg }}
    {% endfor %}

    {% for pv in opensds.backend.lvm.pv %}
remove {{ pv }} physical volume if lvm backend specified:
  lvm.pv_absent:
    - name: {{ pv }}
    {% endfor %}

  {% elif opensds.svc.dock.backend|lower == "cinder" %}

stop cinder-standalone service:
  cmd.run:
    - name: docker-compose down
    - cwd: {{ opensds.backend.cinder.data_dir }}/cinder/contrib/block-box

    {% for vg in opensds.backend.cinder.vg %}
opensds clean the {{ vg }} volume group of cinder:
  cmd.script:
    - source: salt://opensds/files/clean_lvm_vg.sh
    - context:
       cinder_volume_group: {{ vg }}
       cinder_data_dir: {{ opensds.backend.cinder.data_dir }}
    {% endfor %}

  {% endif %} {# Cinder #}
      
- name: kill osdslet daemon service
  shell: killall osdslet osdsdock
  when: container_enabled == false
  ignore_errors: true

- name: kill osdslet containerized service
  docker_container:
    name: osdslet
    image: "{{ controller_docker_image }}"
    state: stopped
  when: container_enabled == true

- name: kill osdsdock containerized service
  docker_container:
    name: osdsdock
    image: "{{ dock_docker_image }}"
    state: stopped
  when: container_enabled == true

- name: stop container where dashboard is located
  docker_container:
    name: dashboard
    image: "{{ dashboard_docker_image }}"
    state: stopped
  when: dashboard_installation_type == "container"

- name: clean opensds flexvolume plugins binary file if flexvolume specified
  file:
    path: "{{ flexvolume_plugin_dir }}"
    state: absent
    force: yes
  ignore_errors: yes
  when: nbp_plugin_type == "flexvolume"

- name: clean opensds csi plugin if csi plugin specified
  shell: |
    . /etc/profile
    kubectl delete -f deploy/kubernetes
  args:
    chdir: "{{ nbp_work_dir }}/csi"
  ignore_errors: yes
  when: nbp_plugin_type == "csi"

- name: clean all configuration and log files in opensds and nbp work directory
  file:
    path: "{{ item }}"
    state: absent
    force: yes
  with_items:
    - "{{ opensds_work_dir }}"
    - "{{ nbp_work_dir }}"
    - "{{ opensds_config_dir }}"
    - "{{ opensds_log_dir }}"
  ignore_errors: yes

- name: include scenarios/auth-keystone.yml when specifies keystone
  include_tasks: scenarios/auth-keystone.yml
  when: opensds_auth_strategy == "keystone"

- name: include scenarios/repository.yml if installed from repository
  include_tasks: scenarios/repository.yml
  when: install_from == "repository" or dashboard_installation_type == "source_code"

- name: include scenarios/release.yml if installed from release
  include_tasks: scenarios/release.yml
  when: install_from == "release"

- name: include scenarios/backend.yml for cleaning up storage backend service
  include_tasks: scenarios/backend.yml
