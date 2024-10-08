import subprocess
from typing import Literal

__author__ = "Janosh Riebesell"
__date__ = "2022-07-04"

description = """
Batch merge bot-created PRs. Uses the GitHub CLI (`brew install gh`) which must be
authenticated (`gh auth status` must exit 0). By default asks for confirmation
before merging each PR. Pass --yes to skip confirmation.

Written to auto-merge green pre-commit.ci auto-update PRs.

Example invocation to merge all PRs regardless of CI status but prompt
for confirmation on each one:
python merge_bot_prs.py --ci-status any

Or to auto-merge all PRs with passing checks (green CI):
python merge_bot_prs.py --yes
"""


def main(
    bot: str,
    owner: str,
    yes: bool = False,
    ci_status: Literal["success", "any"] = "success",
) -> int:
    """Merge bot-created PRs (e.g. pre-commit.ci auto-update PRs)

    Args:
        bot (str): Name of the bot user (e.g. pre-commit-ci)
        owner (str): Name of the repo owner (e.g. @me)
        yes (bool, optional): Auto-merge without confirmation. Defaults to False.
        ci_status ('success' | 'any', optional): Only merge PRs with passing CI or any
            CI status. Defaults to 'success'.

    Raises:
        PermissionError: If gh auth status returns non-zero.
        ValueError: If pr_number is not a number.

    Returns:
        int: exit code (0 for success)
    """
    # make sure gh auth status returns 0 which means user is logged in and hopefully
    # authorized to merge PRs
    if subprocess.run("gh auth status".split(), check=True).returncode != 0:
        raise PermissionError("Please run `gh auth login` and then `gh auth token`")

    search_prs_cmd = f"gh search prs --state=open --app={bot} --owner={owner}"
    if ci_status == "success":
        search_prs_cmd += " --checks=success"
    pr_list = (
        subprocess.run(search_prs_cmd.split(), capture_output=True, check=False)
        .stdout.decode("utf-8")
        .split("\n")
    )
    pr_list = list(filter(bool, pr_list))

    if len(pr_list) == 0:
        print("No PRs found")

    for idx, pr_header in enumerate(pr_list, start=1):
        try:
            repo_handle, pr_number, *_ = pr_header.split("\t")
            counter = f"{idx}/{len(pr_list)}"

            if not pr_number.isdigit():
                raise ValueError(f"{pr_number=} is not a number")

            pr_url = f"https://github.com/{repo_handle}/pull/{pr_number}"

            if yes:
                print(f"{counter} Merging {pr_url}")

            answer = "yes" if yes else ""
            while answer not in ("y", "n", "yes", "no"):
                answer = input(f"{counter} Merge {pr_url}? [y/n] ").lower()

            if answer in ("y", "yes"):
                merge_pr_cmd = (
                    f"gh pr merge {pr_number} --repo {repo_handle} --squash --delete-branch"
                ).split()
                subprocess.run(merge_pr_cmd, capture_output=True, check=True)
                print(f"✓ {repo_handle}#{pr_number} merged!")
        except ValueError:
            print(f"{pr_header=}")
            raise

    return 0


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description=description)

    parser.add_argument(
        "--bot", default="pre-commit-ci", help="Name of the bot to merge PRs from"
    )
    parser.add_argument(
        "--owner",
        default="@me",
        help="GitHub user handle of the repos' owner. Can be an org handle but you "
        "must be privileged to merge org PRs.",
    )
    parser.add_argument(
        "--yes",
        action="store_true",
        help="Skip confirmation prompt for each PR and automatically merge all "
        "matching PRs.",
    )
    parser.add_argument(
        "--ci-status",
        choices=("success", "any"),
        default="success",
        help="Only merge PRs that have this status. 'success' will only merge green "
        "PRs. 'any' also includes 'failure' and 'pending'.",
    )
    args = parser.parse_args()

    try:
        ret_code = main(**vars(args))
    except KeyboardInterrupt:
        ret_code = 1

    raise SystemExit(ret_code)
