###############
Add Application
###############

The following is the procedure to add a new application to the system.

#. Add a directory to ``/apps`` or ``/services`` named for the application.
    a. For example, ``/apps/my_new_application`` for an application named ``my_new_application``.
    b. The ``/apps`` directory is used for control system components.
    c. The ``/services`` directory is used for applications supporting observatory operations.
#. If the application uses a chart not used by other applications, create a ``templates`` directory for the Helm_ manifests.
   Otherwise, link the appropriate chart from the ``charts`` directory as the ``templates`` directory.
   If the application will now share a chart with an existing application that uses an internal chart, the ``templates`` directory contents will need to be copied to a new directory in ``charts`` and the original application will need adjustments from below following applications with shared charts.
   If the previous statement is enacted, the ``values.yaml`` file from the application must be copied into a new directory in ``values`` and the original application will need adjustments from below following applications with shared charts.
#. Add a ``Chart.yaml`` file and add content based on one of the following options.
    a. If the application uses a new, internal Helm_ chart, fill out the information accordingly.
    b. If the application uses a shared Helm_ chart, fill out the information for the new application, but use the version number from another application that shares the same chart.
#. Add a ``values.yaml`` file to the application.
    a. If the application uses an internal Helm_ chart, the options in the ``values.yaml`` file must be documented according to `Helm docs <https://github.com/norwoodj/helm-docs>`_ standards.
    b. If the application uses a shared Helm_ chart (except for csc_collector apps), the ``values.yaml`` file from the corresponding entry in ``values`` for the chart must be symlinked into the application.
#. Add ``values-<environment>.yaml`` files for each environment in which that application will be deployed.
    a. For example, add ``values-summit.yaml`` for the summit environment.
#. Indexed components should contain a values file for each deployed instance.
   The files should be named ``values-<csc name><csc index>.yaml``.
   Simulator variants of indexed components should have values files like ``values-<csc name><csc index>-sim.yaml``.
#. If the application needs to be integrated with a :ref:`collector application <CSC-Ops-with-ArgoCD-Collector-Apps>`, add the application name to the list in the appropriate environment file in the collector.
#. Add the application reference to the love and kafka producers on the desired site yaml file.

If the application is part of a :ref:`collector application <CSC-Ops-with-ArgoCD-Collector-Apps>`, then once the change with the application is committed and pushed to GitHub, syncing the collector application will create the application.
After the application is created, it can then be synced via methods described in :ref:`CSC-Ops-with-ArgoCD-Upgrade-Application`.

If an application is not part of a collector application, it must be created manually.
To create an application using the command-line, log into the appropriate `Argo CD`_ environment and run the following command:

.. prompt:: bash

  argocd app create <app deploy name> --dest-namespace argocd --dest-server https://kubernetes.default.svc --repo https://github.com/lsst-ts/argocd-csc.git --revision HEAD --path <app subdir>/<app name> --values values-<environment>.yaml

The ``<app deploy name>`` and ``<app name>`` directory don't have to match but should be the same for most instances.
The main variation is CSCs that are run in simulation mode are identified with ``-sim`` at the end of the application deployment name, but the application directory is the name of the CSC.
The ``<app subdir>`` is either ``apps`` or ``services`` depending on the application being created.
The configuration of an application can use extra values files, so this should be reflected by adding more ``--values <values file>`` options to the command-line call.
When using multiple values files, the last one specified wins in terms of parameters that exist in all values files.
