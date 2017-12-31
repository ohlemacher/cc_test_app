#!/usr/bin/env python3

"""
A trivial python script.
Useful for testing from a concourse pipeline.

"""

import argparse
from cc_test_module import rot13_encode

def arg_parse():
    """ Parse some arg """
    parser = argparse.ArgumentParser()
    parser.add_argument("--in",
                        help="Input string to rot13 encode",
                        action="store",
                        dest='ins',
                        required=True)
    results = parser.parse_args()

    inputs = dict()
    inputs['ins'] = results.ins
    return inputs

def to_upper(ins):
    """ A trivial function to test from pytest in the app file. """
    return ins.upper()


if __name__ == '__main__':
    args = arg_parse()
    print(rot13_encode(args['ins']))
