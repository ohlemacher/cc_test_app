#!/usr/bin/env python3

import argparse
from cc_test_module.cc_test_module import rot13_encode

def arg_parse():
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


if __name__ == '__main__':
    args = arg_parse()
    print(rot13_encode(args['ins']))
