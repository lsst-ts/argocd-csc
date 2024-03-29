##############
cluster-config
##############

.. list-table::
   :widths: 10,40

   * - Edit on GitHub
     - `/apps/cluster-config <https://github.com/lsst-ts/argocd-csc/tree/main/apps/cluster-config>`_
   * - Type
     - Helm_
   * - Namespace
     - ``argocd``

.. rubric:: Overview

This application handles creating all of the necessary namespaces for CSC deployment.
It also manages injecting secrets into all of the necessary namespaces.
The namespaces can be managed on a per-site basis by utilizing the ``values-<environment>.yaml`` files.
It has the capability of injecting secrets into namespaces that the application does not create.
The main example of this it the ``uws`` namespace which houses the OCPS CSCs.
The ``uws`` namespace is managed by Data Management and must exist for the application to inject the secrets.
The application is managed by an internal Helm_ chart that resides in ``apps/cluster-config/templates``.

.. note::

  In all site deployments, this application is named ``csc-cluster-config``.
