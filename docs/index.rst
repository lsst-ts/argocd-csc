###########################
CSC Operations with Argo CD
###########################

`Argo CD`_ is the mechanism used to control the deployment configuration of some control system components to Kubernetes_.
The description of the control system architecture is given in `LSE-150 <https://ls.st/lse-150>`_.
The `Overview of the Phalanx platform concepts <https://phalanx.lsst.io/about/introduction.html>`_ has a good brief on the concepts of the deployment mechanism.
The deployment system uses Helm_ charts to control the delivered content to Kubernetes_.
The Helm_ charts are part of the application or linked from a shared directory if more than one application uses the same chart.
The `Argo CD`_ configuration and this documentation are stored in the `argocd-csc <https://github.com/lsst-ts/argocd-csc>`_ repository in GitHub_.

This deployment mechanism leverages many technologies provided by Data Management's `SQuaRE <https://github.com/lsst-sqre>`_ group.
This documentation bears heavy resemblance to theirs as many of the concepts and applications of methodologies are similar if not the same.

The following environments are managed by `Argo CD`_ using configuration in this repository.
The links are links to the `Argo CD`_ dashboards, which require authentication.
The names are the environment names used internally in this repository to name values files and for other purposes.

.. _CSC-Ops-with-ArgoCD-UI-URLs:

* `tucson-teststand <https://tucson-teststand.lsst.codes/argo-cd>`_
* `base-teststand <https://base-lsp.lsst.codes/argo-cd>`_
* `summit <https://summit-lsp.lsst.codes/argo-cd>`_

Overview
========

This section provides a description of the repository and ancillary systems used for control system application deployment.

.. toctree::
   :maxdepth: 2

   arch/repository
   arch/secrets

Application Maintenance
=======================

This section handles adding, upgrading and maintaining control system applications.
The actions described in this section require access to the `Argo CD`_ UIs or Kubernetes_ instances.
The UIs require credentials for access and those are stored in the Rubin Observatory IT's 1password system.
For the Kubernetes_ systems, the appropriate ``kubeconfig`` file can be obtained by the site specific Rancher instance.

.. toctree::
   :maxdepth: 2

   app-maint/upgrade-application
   app-maint/add-application
   app-maint/precommit-and-helm-docs
   app-maint/making-changes

Shared Helm Charts
==================

This section covers tracking changes to the two shared charts: ``csc`` and ``csc_collector``.
The individual applications using these shared charts can point the ``version`` attribute in its ``Chart.yaml`` file independently of any other application.

.. toctree::
   :maxdepth: 2

   shared-charts/csc
   shared-charts/csc-collector

Operations Guide
================

These sections describe some of the more important applications used in the deployment as well as how to bootstrap a new deployment.

Applications
------------

.. toctree::
   :maxdepth: 2

   ops/cluster-config
   ops/ospl-config
   ops/ospl-main-daemon
   ops/ospl-daemon
   ops/kafka-producers
   ops/love-producer
   ops/love-manager
   ops/love-nginx
   ops/love-commander
   ops/hexapodsim
   ops/test-csc
   ops/rapid-analysis

The rest of the applications, except those listed in :ref:`CSC-Ops-with-ArgoCD-Collector-Apps`, are CSCs and are managed by an internal chart located in ``charts/csc``.

.. _CSC-Ops-with-ArgoCD-Collector-Apps:

Collector Applications
----------------------

These applications are what `Argo CD`_ calls an app of apps.
They are collections of child applications (CSCs, components or both) that are grouped into a particular namespace.
All collector applications, except ``love``, support running simulators for a CSC.
All simulators are specified by adding the CSC name to the ``isSim`` key.
The collector applications (except ``love``) also support renaming the default application name by providing a key, value pair via the ``renameMap`` key.
Further documentation on the options available can be found in the ``README.md`` in each collector application directory.

.. toctree::
   :maxdepth: 2

   ops/auxtel
   ops/calsys
   ops/dmocps
   ops/eas
   ops/love
   ops/maintel
   ops/obssys

Bootstrapping
-------------

.. toctree::
   :maxdepth: 2

   ops/bootstrapping

Secret Management
-----------------

.. toctree::
   :maxdepth: 2

   ops/add-a-onepassword-secret
   ops/update-a-onepassword-secret
   ops/secrets-for-bare-metal

Administration
--------------

.. toctree::
   :maxdepth: 2

   ops/config-deploy-admin
