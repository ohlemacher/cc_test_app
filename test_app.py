import pytest
import app
from cc_test_module import rot13_encode

"""
Unit test app.py
  python -m pytest -v test_app.py
"""

@pytest.mark.parametrize("test_input, expected", [
    ("foo", "FOO"),
	("sbb", "SBB"),
    ("bar", "BAR"),
    ("one", "ONE"),
])
def test_to_upper(test_input, expected):
    assert app.to_upper(test_input) == expected
