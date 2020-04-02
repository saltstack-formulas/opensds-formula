================
opensds-formula
================

Deploy official releases of OpenSDS (www.opensds.io) using Salt on CENTOS-7, UBUNTU-18, and OPENSUSE-15. This is an experimental solution using repeatable patterns to deploy cloud-native stack using infrastructure as code.  This formula compliments the OpenSDS-Installer_ project.

.. _OpenSDS-Installer: https://github.com/sodafoundation/opensds-installer


.. notes::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

Architectural View
===================

.. image:: solutionDesign.png
   :target: https://github.com/sodafoundation/opensds
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

Prepare your environment by running the ``salt.formulas`` state from ``https://github.com/saltstack-formulas/salt-formula``. See ``pillar.example`` and/or opensds-installer/salt README.
