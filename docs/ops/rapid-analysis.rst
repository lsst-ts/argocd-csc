##############
rapid-analysis
##############

.. list-table::
   :widths: 10,40

   * - Edit on GitHub
     - `/services/rapid-analysis <https://github.com/lsst-ts/argocd-csc/tree/main/services/rapid-analysis>`_
   * - Type
     - Helm_
   * - Namespace
     - ``rapid-analysis``

.. rubric:: Overview

This application handles the rapid analysis services for RubinTV.
It runs the scripts specified in the `rubintv_production <https://github.com/lsst-sitcom/rubintv_production>`_ repository.
The application uses an internal Helm_ chart located in ``services/rapid-analysis/templates``.
