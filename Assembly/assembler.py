import argparse
import re
from typing import List, Dict


class Assembler:
    lista_opcodes: List[str]
    raw_assembly_lines: List[str]
    fmt_assembly_lines: List[str]
    labels_dict: Dict[str, int]

    def __init__(self, code: List[str], lista_opcodes: List[str]):
        self.raw_assembly_lines = code
        self.lista_opcodes = lista_opcodes

    def pre_pro(self):
        fmt_code = []
        labels_dict = {}
        lines_skipped = 0
        for idx, linha in enumerate(self.raw_assembly_lines):
            # dont add comments
            if linha.find("#") != -1:
                lines_skipped += 1
                continue
            # remove indent
            linha = linha.lstrip()
            linha = linha.rstrip()
            # remove line breaks
            linha = re.sub("\n", "", linha)
            # dont add empty lines
            if len(linha) == 0:
                lines_skipped += 1
                continue
            # append labels to label_dict but don't save it
            if linha[-1] == ":":
                label_name = linha[:-1]  # remove :
                labels_dict[label_name] = idx - lines_skipped
                lines_skipped += 1
                continue

            fmt_code.append(linha)

        self.fmt_assembly_lines = fmt_code
        self.labels_dict = labels_dict

    def parse(self):
        self.pre_pro()


def main(raw_assembly: List[str]):
    lista_opcodes = [
        "MOV",
        "STORE",
        "LOAD",
        "CMP",
        "JE",
        "JMP",
        "INC",
        "JL",
        "ADD",
        "SUB",
    ]
    Assembler(raw_assembly, lista_opcodes).parse()


if __name__ == "__main__":
    argparse = argparse.ArgumentParser()
    argparse.add_argument("input_file", type=str)
    args = argparse.parse_args()

    assembly_file_name = args.input_file

    with open(assembly_file_name, "r") as f:
        linhas = f.readlines()

    main(linhas)
