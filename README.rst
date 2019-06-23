================
opensds-formula
================

Deploy official releases of OpenSDS (www.opensds.io) using Salt on CENTOS-7, UBUNTU-18, and OPENSUSE-15. This is an experimental solution using repeatable patterns to deploy cloud-native stack using infrastructure as code. Please use Salt 2018.3.4 or earlier while potential impacts from a NON-BACKWARD-COMPATIBLE-CHANGE-TO-YAML-RENDERER_ are reviewed. This formula compliments the OpenSDS-Installer_ project.

.. _NON-BACKWARD-COMPATIBLE-CHANGE-TO-YAML-RENDERER: https://docs.saltstack.com/en/develop/topics/releases/2019.2.0.html#non-backward-compatible-change-to-yaml-renderer
.. _OpenSDS-Installer: https://github.com/opensds/opensds-installer


.. notes::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

Architectural View
===================

.. image:: solutionDesign.png
   :target: https://github.com/opensds/opensds
   :scale: 25 %
   :alt: salt formula high level architecture

Available META states
======================

.. contents::
    :local:

``opensds``
------------

Runs all the other states in the formula. Used by the ``OpenSDS-installer/salt`` module.

``opensds.infra``
-----------------

Deploy os profile (PATHS) and environmental dependencies (packages, nginx, docker, etc) via salt.

``opensds.telemetry``
-----------------

Deploy prometheus and grafana via salt.

``opensds.keystone``
-----------------

Deploy devstack with keystone configuration for hotpot and gelato.

``opensds.config``
-----------------

Deploy opensds configuration file

``opensds.hotpot``
-----------------

Deploy opensds hotpot

``opensds.auth``
-----------------

Deploy authentication service (default keystone).

``opensds.database``
-----------------

Deploy database service (default etcd).

``opensds.dock``
-----------------

Deploy osdsdock service.

``opensds.sushi``
-----------------

Deploy osdsnbp service.

``opensds.gelato``
-----------------

Deploy multi-cloud service.

``opensds.dashboard``
-----------------

Deploy Dashboard service.

``opensds.freespace``
-----------------

Free some disk space


Site-specific Data Collection
================

The ``site.j2`` and ``pillar.example`` files contain required pillars!

You may review and cautiously update ``site.j2`` to reflect site requirements and preferences.

Prerequisite
==============

Prepare your environment by running the ``salt.formulas`` state from ``https://github.com/saltstack-formulas/salt-formula``.
The following ``pillar.example`` extract is suggested::

        salt:
          master:
            file_roots:
              base:
                - /srv/salt
            pillar_roots:
              base:
                - /srv/pillar
          minion:
            file_roots:
              base:
                - /srv/salt
            pillar_roots:
              base:
                - /srv/pillar
          ssh_roster:
            hotpot1:
              host: {{ grains.ipv4[-1] }}
              user: stack
              sudo: True
              priv: /etc/salt/ssh_keys/sshkey.pem
        salt_formulas:
          git_opts:
            default:
              baseurl: https://github.com/saltstack-formulas
              basedir: /srv/formulas
          basedir_opts:
            makedirs: True
            user: root
            group: root
            mode: 755
          minion_conf:
            create_from_list: True
          list:
            base:
             {{ '- epel-formula' if grains.os_family in ('RedHat',) else '' }}
             - salt-formula
             - openssh-formula
             - packages-formula
             - firewalld-formula
             - etcd-formula
             - ceph-formula
             - deepsea-formula
             - docker-formula
             - etcd-formula
             - firewalld-formula
             - helm-formula
             - iscsi-formula
             - lvm-formula
             - packages-formula
             - devstack-formula
             - golang-formula
             - memcached-formula
             - opensds-formula
             - timezone-formula
             - resolver-formula
             - nginx-formula
             - mysql-formula
             - prometheus-formula
             - grafana-formula
             - sysstat-formula
