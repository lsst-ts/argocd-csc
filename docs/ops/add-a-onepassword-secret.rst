###########################################
Add a secret with 1Password and VaultSecret
###########################################

.. _Secret: https://kubernetes.io/docs/concepts/configuration/secret/

Static secrets for applications are stored in a 1Password vault before being automatically synced to the Vault service itself and ultimately to Kubernetes Secret_ resources.
When we manually create such a secret, we store it in 1Password.
This page provides steps for adding an application secret through 1Password.

.. note::

   Dynamic secrets that don't have to be coordinated with external resources and only have to be consistent for a given installation of the CSC deployment should be generated automatically via the ``SecretGenerator`` class in the `installer/generate_secrets.py <https://github.com/lsst-ts/argocd-csc/blob/main/installer/generate_secrets.py>`__ script.
   Those secrets are not stored in 1Password since it's fine for them to change on each installation of the CSC deployment.
   Currently, no application in the CSC deployment uses a dynamic secret.

.. note::

   This document only covers creating a 1Password-backed Secret for the first time for an application.
   If you want to update a Secret, either by adding new 1Password secrets or by changing their secret values, you should follow the instructions in :doc:`/ops/update-a-onepassword-secret`.

Part 1. Open the 1Password vault
================================

In 1Password, access the **LSST IT** 1Password team and open the vault named ``Build and Deploy``.
Most items in this vault are synced into Kubernetes ``Secret`` resources.

Part 2. Create a Secret Note
============================

Each item in a Kubernetes ``Secret`` corresponds to either the contents of a secure note or the password field of a login item in 1Password
(Many 1Password items can combined into a single Kubernetes ``Secret`` by configuring the ``VaultSecret``).

- The title of the 1Password item should be formatted as:

  .. code-block:: text

     {{env}} {{key}} {{description}}

  This format is a convention and isn't tied into the automation.
  The ``env`` can be omitted if the secret applies to all environments.
  The ``key`` is usually associated with a particular system (like LOVE or the LFA), but can also be an application if necessary.

- Add the secret:

  - For a secure note, set the note's **contents** to the secret value.
  - For a login item, set the **password field** to the secret value.

- Add a metadata field labeled ``generate_secrets_key``. The value of that field is formatted as:

  .. code-block:: text

     {{key}} {{secret name}}

  The ``key`` and ``secret name`` must both be lower case.
  This field provides part of a Vault path for the secret value, which in turn is used by the Vault Secrets Operator resources to create Kubernetes secrets.

- Add a metadata field labeled ``environment``. The value of that field should be the CSC environment that this secret applies to.

  If the secret applies to multiple environments, add additional ``environment`` metadata fields for each environment.

  If the secret applies to **all** environments, omit the ``environment`` field altogether.

Part 3. Sync 1Password items into Vault
=======================================

Once an application's secrets are stored in 1Password, you need to sync them into Vault.

Open the CSC deployment ``installer/`` directory:

.. code-block:: sh

   cd installer

Install the Python dependencies (using a virtual environment is ideal):

.. code-block:: sh

   pip install -r requirements.txt

You will also need to install the package for the ``jq`` executable.
This will be operating system dependent.
To sync the secrets for a single environment, run:

.. code-block:: sh

   ./update_secrets.sh {{environment}}

For example:

.. code-block:: sh

   ./update_secrets.sh tucson-teststand

Next steps: connecting Vault to Kubernetes with VaultSecret
===========================================================

Once a secret is in Vault, you need to create or update a ``VaultSecret`` resource in your application's deployment (typically in its Helm_ chart).
If you are adding a secret for a CSC application (anything within the ``apps`` directory), an entry should be made in the appropriate site specific file in ``apps/cluster-config``.
All services (anything within the ``services`` directory) handle their own secrets via the Helm_ chart.
See the `Rapid Analysis vault-secret.yaml <https://github.com/lsst-ts/argocd-csc/blob/main/services/rapid-analysis/templates/vault-secret.yaml>`_
