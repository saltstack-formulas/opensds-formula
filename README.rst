================
opensds-formula
================

Deploy 'Bali' release of OpenSDS (www.opensds.io) using the ``opensds`` state.

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

Available META states
======================

.. contents::
    :local:

``opensds``
------------

Runs all the other states in the formula. This state is used by the ``OpenSDS-installer/salt`` module.

``opensds.envs``
-----------------

Deploy os profile (PATHS) and environmental dependencies (devstack, packages, docker) via salt.

``opensds.controller``
-----------------

Deploy opensds controller

``opensds.auth``
-----------------

Deploy authentication service (default keystone).

``opensds.database``
-----------------

Deploy database service (default etcd).

``opensds.dock``
-----------------

Deploy osdsdock service.

``opensds.nbp``
-----------------

Deploy osdsnbp service.

``opensds.let``
-----------------

Deploy osdslet service.


Default Pillars
================

The ``site.j2`` and ``pillar.example`` files contain required pillars!!!

Site-specific Data Collection
==============================

Optionally update ``site.j2`` parameters to reflect site specific parameters.

