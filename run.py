from __future__ import annotations

from pathlib import Path
import subprocess
import sys
from typing import Optional
import shlex
import re
import os
import argparse

class Language:
    def __init__(self, name: str, extension: str, run, build_extension: Optional[str] = None):

        self.name = name
        self.extension = extension
        self.run = run
        self.build_extension = build_extension

class Problem:
    def __init__(self, language: Language, year: int, day: int, part: int, resource_location = None):
        self.language = language
        self.year = year
        self.day = day
        self.part = part

        self.source_location = str(Path("src") / self.language.name / str(self.year) / f"day{self.day}" / f"part{self.part}.{self.language.extension}")

        if resource_location:
            self.resource_location = resource_location
        else:
            self.resource_location = str(Path("resources") / str(self.year) / f"day{self.day}.txt")

        self.build_location = str(Path("build") / f"{self.language.name}{self.year}day{self.day}part{self.part}") + (f".{self.language.build_extension}" if self.language.build_extension else "")

        self.resource_build_location = str(Path("build") / f"{self.language.name}{self.year}day{self.day}part{self.part}input")            


    def run(self, flags=None):
        if flags is None:
            flags = []

        try: 
            self.language.run(self, flags=flags)
        except RuntimeError:
            pass


def print_command(command: str | list):
    print(command if isinstance(command, str) else shlex.join([str(x) for x in command]))

def run_command(command: str | list[str], **kwargs):
    print_command(command)
    p = subprocess.run(command, **kwargs)
    if p.returncode != 0:
        print("process returned with error code", p.returncode)
        raise RuntimeError()

def run_compile_command(command: str | list[str], **kwargs):
    run_command(command, stdout=subprocess.DEVNULL, stderr=sys.stderr, **kwargs)
    

def run_run_command(command: str | list[str], **kwargs):
    run_command(command, stdout=sys.stdout, stderr=sys.stderr, **kwargs)


def generate_commands_pladcl(problem: Problem, flags: Optional[list[str]]=None):

    preprocess_location = "utilities/dc/preprocess.py"

    run_compile_command(["pladclc", problem.source_location, "-o", problem.build_location] + (flags if flags else []))
    run_compile_command(["python3", preprocess_location, problem.resource_location, "-o", problem.resource_build_location])
    run_run_command(" ".join(["cat", problem.resource_build_location, "|", "dc", problem.build_location]), shell=True)


def generate_commands_pascal(problem: Problem, flags: Optional[list[str]]=None):

    run_compile_command(["fpc", problem.source_location, "-o" + problem.build_location] + (flags if flags else []))
    run_run_command([problem.build_location])

def generate_commands_z80(problem: Problem, flags:Optional[list[str]]=None):
    simulator_location = "utilities/z80/z80sim"
    preamble_location = "utilities/z80/preamble"

    run_compile_command(["zasm", problem.source_location, "-o", problem.build_location] + (flags if flags else []))
    run_compile_command(f"cat {preamble_location} {problem.build_location} > {problem.build_location + "0"}", shell=True)

    run_run_command(f"echo q | {simulator_location} -x{problem.build_location}0", shell=True)
    

languages = {
    "pladcl": Language("pladcl", "pdl", generate_commands_pladcl, build_extension="dc"),
    "pascal": Language("pascal", "pas", generate_commands_pascal),
    "python": Language("python", "py", lambda problem, flags: run_run_command(["python3", problem.source_location] + (flags if flags else []))),
    "z80": Language("z80", "z80", generate_commands_z80, build_extension="bin")
}


def parse_problem(problem: str):
    
    pattern = r"^([a-zA-Z0-9]+)(\d{4})d(?:ay)?(\d+)p(?:art)?(\d+)$"

    if not (match := re.match(pattern, problem)):
        raise ValueError(f"unable to understand problem \"{problem}\"")

    language, year, day, part = match.groups()

    if not language in languages:
        raise ValueError(f"unknown language \"{language}\"")

    language = languages[language]
    year = int(year)
    day = int(day)
    part = int(part)

    p = Problem(language, year, day, part)

    return p

USAGE = """

for example, to run pladcl year 2024 day 3 part 1 with debug flags
python3 run.py pladcl2024day3part1 -d

extra flags are passed as is to the compiler"""
    
parser = argparse.ArgumentParser(
                prog="run.py",
                epilog=USAGE,
                formatter_class = argparse.RawDescriptionHelpFormatter,
                exit_on_error=False,
)

parser.add_argument("problem", type=str,
                   help="program to run [formatted as <language><year>day<day>part<part>]")
parser.add_argument("--resource-location", type=str,
                    help="override the default resource file (which is resources/<year>/day<day>.txt)")


def fail():
    parser.print_usage()
    print()

    print("\n".join(parser.format_help().splitlines()[2:]))
    quit(2)



if __name__ == "__main__":

    try:
        args, extra_flags = parser.parse_known_args(sys.argv[1:])
        
        problem = parse_problem(args.problem)

        if args.resource_location:
            problem.resource_location = args.resource_location

        if not os.path.exists(loc := problem.source_location):
            raise ValueError(f"couldn't find the source file\nexpected it to be {loc}")

        if not os.path.exists(loc := problem.resource_location):
            raise ValueError(f"couldn't find the resource file\nexpected it to be {loc}")


        problem.run(extra_flags)

    except (argparse.ArgumentError, ValueError) as e:
        print(e)
        print()
        fail()

        
    

