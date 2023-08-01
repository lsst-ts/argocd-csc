import argparse
import pathlib

import yaml

APPS_DIR = "apps"

DIR_MAP = {"csc": "csc", "collector": "csc_collector"}


def shared_chart(appdir, shared_dir):
    """Determine if app directory has templates dir as link.

    Parameters
    ----------
    appdir: `str`
        The application directory to check.
    shared_dir: `str`
        The shared directory to make sure the link resolves to.

    Returns
    -------
    `bool`: True if the link resolves to the requested shared dir.
    """
    template_dir = appdir / "templates"
    return (
        template_dir.is_symlink() and template_dir.resolve().name == shared_dir
    )


def main(opts):
    print(
        f"Updating {opts.app_type} apps Helm chart to version {opts.chart_version}"
    )

    apps = pathlib.PosixPath(APPS_DIR)
    dirlist = list(apps.iterdir())
    for appdir in dirlist:
        if not shared_chart(appdir, DIR_MAP[opts.app_type]):
            continue

        chart = appdir / "Chart.yaml"

        with chart.open() as ifile:
            values = yaml.safe_load(ifile)
            values["version"] = opts.chart_version

        # print(appdir, values)

        with chart.open("w") as ofile:
            yaml.dump(values, ofile, sort_keys=False)


if __name__ == "__main__":
    description = [
        "Update version for apps using the csc or shared Helm chart"
    ]
    parser = argparse.ArgumentParser(
        description=" ".join(description),
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )
    parser.add_argument(
        "app_type",
        choices=["csc", "collector"],
        help="Specify the application type to set the chart version for.",
    )
    parser.add_argument(
        "chart_version", help="The version of the Helm chart to set."
    )
    args = parser.parse_args()
    main(args)
