import argparse
import os
import pathlib

from ruamel.yaml import YAML

APPS_DIR = "apps"
SERVICES_DIR = "services"
WORKFLOWS_DIR = "workflows"

IGNORE_LIST = [
    "auxtel",
    "calsys",
    "cluster-config",
    "dmocps",
    "eas",
    "hexapodsim",
    "love",
    "maintel",
    "obssys",
    "ospl-config",
]

EXTRA_IMAGE_TAGS = {
    "love-nginx": ["initContainers.frontend", "initContainers.manager"],
    "love-manager": ["manager.frontend", "manager.producers", "viewBackup"],
}


def update_tag(values, top_key, update_key, update_value):
    if top_key is None:
        tags = []
        vtt = values
    else:
        tags = top_key.split(".")
        vtt = values[tags[0]]
    for tag in tags[1:]:
        vtt = vtt[tag]
    keys = update_key.split(".")
    try:
        for key in keys[:-1]:
            vtt = vtt[key]
    except KeyError:
        return

    vtt[keys[-1]] = update_value


def main(opts):
    if opts.ignore_non_ospl:
        IGNORE_LIST.extend(["love-manager", "love-nginx"])

    if opts.dir_file is not None:
        with open(os.path.expanduser(opts.dir_file)) as ifile:
            dirs = [x.strip() for x in ifile.readlines()]
        use_dirs = True
    else:
        use_dirs = False

    yaml = YAML(typ="rt", pure=True)

    print(
        f"Updating {opts.update_key} to {opts.update_value} for {opts.env} environment"
    )
    apps = pathlib.PosixPath(APPS_DIR)
    services = pathlib.PosixPath(SERVICES_DIR)
    workflows = pathlib.PosixPath(WORKFLOWS_DIR)
    dirlist = list(apps.iterdir())
    dirlist.extend(list(services.iterdir()))
    dirlist.extend(list(workflows.iterdir()))
    extra_image_tags_keys = list(EXTRA_IMAGE_TAGS.keys())

    for appdir in dirlist:
        if use_dirs:
            if appdir.name not in dirs:
                continue
        else:
            if appdir.name in IGNORE_LIST:
                continue

        if opts.debug:
            print(appdir)

        top_tag = None

        for appfile in appdir.iterdir():
            if opts.env in appfile.name:
                print(f"Updating: {appfile}")

                values = None

                with open(appfile) as ifile:
                    values = yaml.load(ifile)

                if opts.update_key == "image.tag":
                    if appdir.name in extra_image_tags_keys:
                        extras = EXTRA_IMAGE_TAGS[appdir.name]
                        for extra in extras:
                            update_tag(
                                values,
                                extra,
                                opts.update_key,
                                f"{opts.update_value}.000",
                            )
                    else:
                        if (
                            "love-commander" in appdir.name
                            or "love-producer" in appdir.name
                        ):
                            tag = f"{opts.update_value}.000"
                        else:
                            tag = opts.update_value
                        update_tag(values, top_tag, opts.update_key, tag)
                else:
                    update_tag(
                        values, top_tag, opts.update_key, opts.update_value
                    )

                if opts.debug and values is not None:
                    print(values)

                if values is None:
                    print(f"Problem reading {appfile}")
                else:
                    with open(appfile, "w") as ofile:
                        yaml.dump(values, ofile)


if __name__ == "__main__":
    description = ["Update parameter for a given environment."]
    description.append("Run the script in the top-level argocd-csc directory.")
    description.append(
        "Do not include the top-level section in key specification."
    )
    description.append(
        "If the key does not appear in the files, it will be added."
    )
    parser = argparse.ArgumentParser(
        description=" ".join(description),
        formatter_class=argparse.ArgumentDefaultsHelpFormatter,
    )
    parser.add_argument(
        "update_key", help="Key to update. Uses dot formatting for sections."
    )
    parser.add_argument("update_value", help="Value for key to update.")
    parser.add_argument(
        "-e",
        "--env",
        dest="env",
        required=True,
        help="Pass the environment to change.",
    )
    parser.add_argument(
        "-d",
        "--debug",
        dest="debug",
        action="store_true",
        help="Print intermediate information",
    )
    parser.add_argument(
        "--dir-file",
        help="Provide a file with a list of directories to look at.",
    )
    parser.add_argument(
        "--ignore-non-ospl",
        action="store_true",
        help="Do not apply parameter to non-OSPL apps.",
    )
    args = parser.parse_args()

    main(args)
