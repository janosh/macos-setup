import requests

__date__ = "2022-12-27"

# adapted from script posted by @jrs65 in
# https://github.com/zenodo/zenodo/issues/1463#issuecomment-1007602828


headers = {"Accept": "application/vnd.github.v3+json"}



print(f"prior {len(releases)=}")


# -- upload oldest release first --
# for release in reversed(releases):

    print(f"uploaded {release['tag_name']}")
    print(response.json())
