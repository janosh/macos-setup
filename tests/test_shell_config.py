
import os

import pytest


@pytest.mark.parametrize(
    [
    ],
)
    with open(config_path, encoding="utf-8") as config_file:
        assert setting in config_file.read()
