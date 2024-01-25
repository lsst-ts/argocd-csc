import argparse
import pathlib

import helpers as hp


def get_credentials(token_file):
    """Get authentication credentials from a file.

    Parameters
    ----------
    token_file : `path.Pathlib`
        The full path of the credentials file.

    Returns
    -------
    `tuple`
        The username and password for authentication as a tuple.
    """
    with open(token_file.expanduser(), "r") as fd:
        uname = fd.readline().strip()  # Can't hurt to be paranoid
        pwd = fd.readline().strip()
    return (uname, pwd)


def main(opts):
    username, password = get_credentials(opts.token_file)

    cmd = [
        "argocd",
        "login",
        "--core",
        "--plaintext",
        "--port-forward",
        "--port-forward-namespace",
        "argocd",
        "--username",
        f"{username}",
        "--password",
        f"{password}",
    ]

    output = hp.run_cmd(cmd)
    print(output)


if __name__ == "__main__":
    description = [
        "This script logs into a given argocd pod using the port-forwarding mechanism."
    ]
    parser = argparse.ArgumentParser(
        description=" ".join(description),
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )

    parser.add_argument(
        "token_file",
        type=pathlib.Path,
        default="~/.argocd_auth",
        help="Specify path to Argo CD credentials file.",
    )

    args = parser.parse_args()

    main(args)
