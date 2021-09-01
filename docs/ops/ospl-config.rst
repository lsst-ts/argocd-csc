###########
ospl-config
###########

.. list-table::
   :widths: 10,40

   * - Edit on GitHub
     - `/apps/ospl-config <https://github.com/lsst-ts/argocd-csc/tree/master/apps/ospl-config>`_
   * - Type
     - Helm_
   * - Namespace
     - ``argocd``

.. rubric:: Overview

This application sets the OpenSplice configuration for all control system related applications.
The application constructs the `ospl-shmem.xml <https://github.com/lsst-ts/ts_ddsconfig/blob/develop/config/ospl-shmem.xml>`_ similar to the link provided, but allows for more configuration tweaking.
This was useful during the `DDS stabilization investigation <https://tstn-023.lsst.io/>`_, but has now settled down to accepted values for all systems.
The application is managed by the `ospl-config Helm chart <https://github.com/lsst-ts/charts/tree/master/charts/ospl-config>`_.