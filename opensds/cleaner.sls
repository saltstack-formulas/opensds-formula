# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "opensds/map.jinja" import opensds with context %}

  # remove system profile
opensds controller {{ opensds.controller.release }} ensure system profile file absent:
  file.absent:
    - name: /etc/profile.d/opensds.sh

  # cleanup components
include:
  - opensds.auth.clean
  - opensds.dashboard.clean
  - opensds.dock.clean
  - opensds.database.clean
  - opensds.let.clean
  - opensds.env.clean
  - opensds.salt.clean

  {% elif opensds.svc.dock.backend|lower == "cinder" %}

opensds nbp {{ opensds.nbp.release }} block stop CinderaaS:
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
