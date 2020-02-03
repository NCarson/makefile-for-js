#!/usr/bin/env python3
"""
"""

__author__ = "Nate Carson"
__version__ = "0.1.0"
__license__ = "MIT"

import argparse
import fileinput
import sys


def main(args):
    """ Main entry point of the app """
    libs = set()
    for line in fileinput.input(files=args.file if len(args.file) > 0 else ('-', )):
        if line.startswith(args.src_dir):
            pass
        elif line.startswith(args.node_dir):
            if line.startswith('@'):
                sys.stderr.write("%(prog)s: scoped directory not implimented yet:{line}".format(line=line))
                sys.exit(1)
            line = line[len(args.node_dir) + 1:]
            lib = line.split('/')[0]
            libs.add(lib)
        else:
            sys.stderr.write("%(prog)s: unknown direc:{line}".format(line=line))
            sys.exit(1)

    sys.stdout.write('\n'.join(libs) +'\n')


if __name__ == "__main__":
    """ This is executed when run from the command line """
    parser = argparse.ArgumentParser()
    
    parser.add_argument('file', metavar='FILE', nargs=1, help='files to read, if empty, stdin is used')

    # Required positional argument
    parser.add_argument("src_dir", help="source directory")

    # Required positional argument
    parser.add_argument("node_dir", help="node modules directory")

    # Specify output of "--version"
    parser.add_argument(
        "--version",
        action="version",
        version="%(prog)s (version {version})".format(version=__version__))

    args = parser.parse_args()
    main(args)
