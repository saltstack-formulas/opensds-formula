###  opensds/gelato/daemon/clean.sls
# -*- coding: utf-8 -*-
# vim: ft=sls
{% from "opensds/map.jinja" import opensds with context %}


  {%- for instance in opensds.gelato.instances %}
    {%- if instance in opensds.gelato.daemon and opensds.gelato.daemon[ instance|string ] is mapping %}
       {%- set daemon = opensds.gelato.daemon[ instance|string ] %}

           ###########################################
           #### OpenSDS gelato keystone service  #####
           ###########################################
       {%- if "keystone" in daemon.strategy|lower %}

         ## skipping 'include: - devstack.remove'

       {%- endif %}

           #########################################
           #### OpenSDS gelato systemd services ####
           #########################################
       {%- if "systemd" in daemon.strategy|lower %}

opensds gelato daemon {{ instance }} systemd service stopped:
  service.dead:
    - name: opensds-{{ instance }}
  file.absent:
    - name: {{ opensds.systemd.dir }}/opensds-{{ instance }}.service
    - watch:
      - service: opensds gelato daemon {{ instance }} systemd service stopped
  cmd.run:
    - names:
      - systemctl daemon-reload
    - watch:
      - file: opensds gelato daemon {{ instance }} systemd service stopped

       {%- endif %}
    {%- endif %}
  {%- endfor %}
