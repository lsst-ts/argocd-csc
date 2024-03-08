##############################
Bootstrapping a new deployment
##############################

Since creating new CSC deployments or re-deploying an old one is an infrequent process, knowledge of that procedure might atrophy over time.
What is written here is how to bring up a CSC deployment on Kubernetes_ from scratch.
As mentioned before, the CSC deployment relies heavily on services provided by SQuaRE, so close coordination with them will be necessary.

#. Choose an environment name for the deployment if one is not already established for that site.
#. Check with SQuaRE to see if a `vault <https://vault.lsst.cloud>`_ is available.
    a. Get the Vault tokens from SQuaRE and add them to the notes field of the ``Vault Tokens`` secret in the ``Build and Deploy`` vault of the `LSST IT 1Password`_ system.
    #. Follow the instructions in :doc:`add-a-onepassword-secret` to populate the necessary secrets for the site.
#. Once the Kubernetes_ system has been prepared by SQuaRE, get the following:
    a. The `Argo CD`_ login credentials.
    #. The `Kubernetes`_ config (``kubectl`` config) file for the cluster.
#. Ask IT for any special ingress routes for the system.
    a. Example: The HeaderService instances can run with a web service for header file serving, so they require an ingress, but were not designed to leverage the standard cluster ingress route.
    Therefore they were given a route that started with the lower-cased CSC name (``atheaderservice.<site>.lsst.org``) to differentiate the instances.
#. Ensure that all configuration has been committed to site specific ``values-<environment>.yaml`` files and available in the ``argocd-csc`` repository.
#. Add the list of applications and services to the ``site-config.yaml`` in the ``installer`` directory.
#. Run the installation script.
    a. Change directory to ``installer``.
    #. ``pip`` install the requirements (preferably in a virtual environment).
    #. Run ``./install.sh <environment> <vault token>``.
