##############
CSC Helm Chart
##############

0.12.1
------

  Fixed templating issue with ``affinity``, ``nodeSelector``, ``tolerations`` and ``resources`` attributes.

0.12.0
------

  This version centralizes the ``values.yaml`` into the ``values/csc`` directory and is linked into all CSC applications. This allows for single point editing of the Helm chart configuration attributes. There are two consequences of the centralization. The first is that the ``namespace`` attribute must be added to either the application's site specific values file or an application specific one. The second is that the version in the ``Chart.yaml`` of each CSC application must be updated if the ``values.yaml`` or the associated Helm chart is updated. The only exception would be pure documentation updates to the ``values.yaml``. The ``bin/update_shared_chart_version.py`` script is available to help with this.

  The init container usage has also been revamped. Two attributes, ``ddsRouteFixer`` and ``secretPermFixer`` have been added to handle the configuration. The ``ddsRouteFixer`` replaces the old ``initContainer`` attribute and is being deprecated for futher use. The ``secretPermFixer`` is now used to handle the butler secrets as well as other secrets files, like SSH keys. This changes the configuration methodology for the butler secrets compared to version 0.10.0. The configuration now should look like:

  .. code::

    butlerSecret:
      containerPath: &bS-cP /home/saluser/.lsst
      dbUser: oods
    secretPermFixer:
    - name: butler-secret
      containerPath: *bS-cP

  The ``bS-cP`` references allow the path to be specified in one place (``&``)  and reused in the other (``*``).

0.11.0
------

  This version provides the ability to have a configuration file (YAML) for a CSC and provides the specification of a security context for the pods. Use this version if you need to add either of the following to the ``values.yaml``:

  .. code::

    # -- This key allows specification of a YAML configuration file
    # If this section is used, it must contain the following attributes defined:
    # _path_ (The container path for the configuration file),
    # _filename_ (The configuration file name),
    # _content_ (The YAML content for the configuration file)
    configfile: {}

    # -- This key allows for the specification of a pod security context for volumes.
    # If this section is used, it must contain the following attributes:
    # _user_ (The user id for the volumes)
    # _group_ (The group id for the volumes)
    # _fsGroup_ (OPTIONAL: A special supplemental group that applies to all containers in a pod)
    securityContext: {}

  To activate the configuration file feature, the site-specific values files need to have explicit information added.
  This a snippet of an example from the ``atoods`` ``values-tucson-teststand.yaml``:

  .. code::

      configfile:
        path: /etc
        filename: atoods.yaml
        content: |
          defaultInterval: &interval
              days: 0
              hours: 0
              minutes: 0
              seconds: 0

  To activate the security context, the site-specific values files need to have explicit information added.
  This is an example:

  .. code::

    securityContext:
      user: 1042
      group: 3323
      fsGroup: 3323


0.10.0
------

  This version provides for injecting Butler secrets into the application pod.
  In order to use this version, the following needs to be added to the application ``values.yaml``:

  .. code::

    # -- This key allows for specification of Butler secret information
    # If this section is used, it must contain the following attribute:
    # __containerPath__ (The directory location for the Butler secret)
    # __dbUser__ (The username for the Butler backend database)
    butlerSecret:

  To activate the feature, the site-specific values files need to have explicit information added.
  This is an example from the ``atqueue`` ``values-tucson-teststand.yaml``:

  .. code::

    butlerSecret:
      containerPath: /home/saluser/.lsst
      dbUser: oods

0.9.2
-----

  This is the canonical version of the CSC Helm chart.
  It contains the following functionality:

  * Specify the container image for the application
  * Specify environmental variables for the application
  * Specify secret type environmental variables for the application
  * Provide the capability of overriding the container entrypoint
  * Specify Persistent Volume Claims for application ephemeral storage
  * Specify NFS mounts for application data sharing
  * Ability to use either external or internal OSPL configuration
  * Provide flexible location of the OSPL shmem directory
  * Provide annotation capability for the application pod
  * Provide mechanism for init containers for handling multus access
  * Allow application pods to use host PID and IPC spaces
  * Provide the capability for a Service attachment for the application
