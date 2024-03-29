.. _CSC-Ops-with-ArgoCD-Upgrade-Application:

###################
Upgrade Application
###################

Commandable SAL Components
--------------------------

This covers upgrading a CSC at a given site since the sites are controlled independently.
The upgrade could be just a new container image, but it could also cover new configuration for the CSC.

#. Push the new container image with the current cycle tag for the given site to the `nexus <https://repo-nexus.lsst.org/nexus>`_ repository.
#. If necessary, update the appropriate environment configuration in the application directory and commit that to GitHub.
    a. **NOTE**: Any changes to general configuration (``values.yaml`` or indexed YAML files) will be seen by all sites, so be careful with this.
#. At the site, send the CSC to *OFFLINE* before the upgrade.
    a. If the CSC is a multi-index component, make sure to send all indices *OFFLINE*.
#. Log into the :ref:`site specific <CSC-Ops-with-ArgoCD-UI-URLs>` `Argo CD`_ UI and find the application within the UI.

.. figure:: ../_static/argocd_ui.png
     :name: argocd-ui

     Use the :guilabel:`Search applications...` box at the top of the UI or use the page list to find the application.

.. figure:: ../_static/find_app.png
     :name: find-app

     Finding an application by the :guilabel:`Search applications...` box.

5. Bring up the detailed view by clicking on the application in the UI.
#. The pod should show :guilabel:`completed` status unless the CSC is an *OFFLINE* state entrypoint variant. In that case it will continue to say :guilabel:`running`.

.. figure:: ../_static/app_in_completed_state.png
     :name: completed-app

     Pod status of a *STANDBY*-entry CSC after being sent *OFFLINE*.

7. Delete the job (**NOT** the application) by clicking on the three vertical dots and selecting, :guilabel:`Delete`. **DO NOT** use the :guilabel:`Delete` button on the top bar as this will delete the application.
    a. You will have to type in the name of the application to perform the delete.
    #. For most applications the foreground delete is OK to select.

.. figure:: ../_static/delete_api.png
     :name: delete-app

     Deleting application via the three vertical dots on the job box.

.. figure:: ../_static/delete_dialog.png
     :name: delete-dialog

     Deletion dialog showing the need to type the application name in order to activate the :guilabel:`OK` button.

8. Once the job is deleted and shows :guilabel:`Out of Sync`, it is ready to be synced again.
    a. If a configuration change was made, make sure to check the commit message in the :guilabel:`Current Sync Status` box to ensure that it matches the expected configuration commit.
    #. If it doesn't, click the :guilabel:`Refresh` button or reload the page to force an update.

.. figure:: ../_static/app_ready_for_sync.png
     :name: app-ready-for-sync

     Application status after deletion but before syncing.

9. To do this, either click the :guilabel:`Sync` button on the top menu bar or click the three vertical dots on the job and select :guilabel:`Sync`.

.. figure:: ../_static/app_sync.png
     :name: app-sync

     Dialog showing the synchronization options. Complete the process by clicking the :guilabel:`Synchronize` button.

Producers
---------

The producers should normally be upgraded as a whole in spite of the fact that there are multiple producer deployments/pods.
They are not CSCs, so cannot be shutdown in the same manner.
The best way to delete the producer deployments en masse is via *kubectl*:

.. prompt:: bash

  kubectl delete deployments -n kafka-producers --all

Otherwise, the procedure for upgrading is the same as for CSCs.

The configuration does support the ability to change per-producer attributes, but use this feature with caution.
It is very possible to create a configuration for one producer that can interfere with the operation of all the other producers.
The indivdual producers can be restarted by deleting the appropriate deployment and performing the sync on that deployment.
