#!/usr/bin/env python3
import argparse
import os
import pathlib
import subprocess as sp

import yaml

UWS_INFO = {
    "namespace": "uws",
    "github": "https://github.com/lsst-dm/uws_deploy.git",
    "path": "services/uws-api-server",
}


def get_apps_and_services():
    """Get list of apps and services from configuration file

    Returns
    -------
    apps: `set`
        The unique list of applications from all sites.
    services: `set`
        The unique list of services from all sites
    """
    config_file = pathlib.Path("site-config.yaml")
    with config_file.open() as ifile:
        site_config = yaml.safe_load(ifile)

    all_apps = site_config["applications"]
    all_services = site_config["services"]

    apps = []
    services = []
    for i in all_apps.values():
        for app in i:
            apps.append(app)
    for i in all_services.values():
        for service in i:
            services.append(service)

    return set(apps), set(services)


def create_command(app, top_dir, conf):
    """Create the app creation command.

    Parameters
    ----------
    app : `str`
        The name of the app to create.
    top_dir : `str`
        The top-directory containing the ArgoCD application.
    conf : `SimpleNamespace`
        The options for the app.

    Returns
    -------
    `list` of `str`
        The assembled command line to run.
    """
    if app == "csc-cluster-config":
        app_dir = app.replace("csc-", "")
    elif app == "test42":
        app_dir = "test-csc"
    elif app.endswith("-sim"):
        app_dir = app.replace("-sim", "")
    else:
        app_dir = app

    if app != "uws":
        dir_for_app = pathlib.Path("../") / top_dir / app_dir
        if not dir_for_app.exists():
            print(
                f"Directory for application not found! ({str(dir_for_app)})."
            )
            return None

    cmd = [
        "argocd",
        "app",
        "create",
        f"{app}",
        "--dest-namespace",
        "argocd",
        "--dest-server",
        "https://kubernetes.default.svc",
        "--repo",
        "https://github.com/lsst-ts/argocd-csc.git",
        "--revision",
        f"{conf.revision}",
        "--path",
        f"{top_dir}/{app_dir}",
        "--values",
        f"values-{conf.env}.yaml",
    ]
    if app == "test42":
        cmd.append("--values")
        cmd.append(f"values-{app}.yaml")
    if app.endswith("-sim"):
        extra_config = f"values-{conf.env}-sim.yaml"
        if app.startswith("mt"):
            cmd[5] = "maintel"
        if app.startswith("at"):
            cmd[5] = "auxtel"
        if app.startswith("mtm1m3"):
            cmd[-1] = extra_config
        else:
            cmd.append("--values")
            cmd.append(extra_config)
    if app == "uws":
        cmd[5] = UWS_INFO["namespace"]
        cmd[9] = UWS_INFO["github"]
        cmd[13] = UWS_INFO["path"]
    cmd.append("--port-forward")
    cmd.append("--port-forward-namespace")
    cmd.append("argocd")

    return cmd


def run_cmd(command, as_lines=False):
    """Run a command via subprocess::run.

    Parameters
    ----------
    command : `list`
        The command to run.
    as_lines : `bool`, optional
        Return the output as a list instead of a string.

    Returns
    -------
    str or list
        The output from the command.
    """
    output = sp.run(command, stdout=sp.PIPE, stderr=sp.STDOUT)
    decoded_output = output.stdout.decode("utf-8")
    if as_lines:
        return decoded_output.split(os.linesep)
    else:
        return decoded_output[:-1]


def run_command(command, no_run):
    """

    Parameters
    ----------
    command : `list`
        The command to run.
    no_run : `bool`
        Flag for deciding if to run the command.
    """
    if command is None:
        return
    print(f"{' '.join(command)}")
    if not no_run:
        output = run_cmd(command)
        print(output)


def main(opts):
    apps = []
    services = []

    if opts.apps is not None:
        apps = opts.apps.split(",")
    elif opts.services is not None:
        services = opts.services.split(",")
    else:
        config_file = pathlib.Path("site-config.yaml")
        with config_file.open() as ifile:
            site_config = yaml.safe_load(ifile)

        apps = site_config["applications"][opts.env]
        try:
            services = site_config["services"][opts.env]
        except KeyError:
            services = []

    for service in services:
        run_cmd = create_command(service, "services", opts)
        run_command(run_cmd, opts.no_run)

    for app in apps:
        run_cmd = create_command(app, "apps", opts)
        run_command(run_cmd, opts.no_run)


if __name__ == "__main__":
    description = [
        "Create argocd applications or services. Not all applications/services are deployed to "
    ]
    description.append(
        "all sites, so check the site-config.yaml for details. The list of all deployed "
    )
    description.append("applications/services is:")
    apps, services = get_apps_and_services()
    for app in apps:
        description.append(f"   apps/{app}")
    for service in services:
        description.append(f"   services/{service}")
    parser = argparse.ArgumentParser(
        description=os.linesep.join(description),
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )

    parser.add_argument(
        "--no-run", action="store_true", help="Do not run the commands."
    )
    parser.add_argument(
        "env", help="Provide the environment for the Helm values files."
    )
    parser.add_argument(
        "--apps", help="Provide a comma-delimited list of apps to create."
    )

    parser.add_argument(
        "--services",
        help="Provide a comma-delimited list of services to create.",
    )

    parser.add_argument(
        "--revision",
        default="HEAD",
        help="Provide the git branch against which the app will be created. Default is HEAD.",
    )

    args = parser.parse_args()

    main(args)
