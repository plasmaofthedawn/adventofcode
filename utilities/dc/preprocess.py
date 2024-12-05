import sys
import argparse


parser = argparse.ArgumentParser(prog="preprocess.py")
parser.add_argument("input", nargs='?', help="input file",
                    type=argparse.FileType('r'), default=sys.stdin)
parser.add_argument("-o", "--output", nargs='?', help="output file",
                    type=argparse.FileType('w'), default=sys.stdout)

args = parser.parse_args(sys.argv[1:])

contents = args.input.read()

args.output.write(
        " ".join([str(ord(c)) for c in contents])
)
args.output.close()
