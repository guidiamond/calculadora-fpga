import argparse
import re
from typing import List, Dict


def prepro(code: List[str]):
    fmt_code = []
    labels = {}
    lines_skipped = 0
    for idx, linha in enumerate(code):
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
            labels[label_name] = idx - lines_skipped
            lines_skipped += 1

            continue

        fmt_code.append(linha)

    return [fmt_code, labels]


def gen_op_code_dict(n_bits: int, lista_opcodes: List[str]):
    opcode_dict = {}
    for idx, opc_name in enumerate(lista_opcodes):
        op_code_bits = f"{idx:04b}"
        opcode_dict[opc_name] = op_code_bits
    return opcode_dict


def gen_tokens(linha: str):
    return linha.split()


def gen_imediato_rom(n_bits, label_name: str, labels_dict: Dict[str, int]):
    posicao_mem = labels_dict[label_name]
    return f"{posicao_mem:010b}"


def gen_imediato_valor(n_bits, imediato_str: str):
    imediato_num = int(imediato_str)
    return f"{imediato_num:08b}"


def gen_imediato_ram(n_bits, label_name: str, labels_dict: Dict[str, int]):
    posicao_mem = labels_dict[label_name]
    return f"{posicao_mem:016b}"


class Assembler:
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
    raw_assembly_lines: List[str]
    fmt_assembly_lines: List[str]
    labels_dict: Dict[str, int]

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

    def __init__(self, code: str):
        self.raw_assembly_lines = code

    def parse(self):
        self.pre_pro()


def main(linhas: List[str]):
    fmt_input, labels_dict = prepro(linhas)
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
    jump_instructions = ["JE", "JMP", "JL"]
    opcode_dict = gen_op_code_dict(4, lista_opcodes)
    encoded_instructions = []

    for idx, linha in enumerate(fmt_input):
        instruction = list(f"{0:016b}")
        tokens = gen_tokens(linha)  # ex: [MOV, $1]
        opcode = opcode_dict[tokens[0]]
        instruction[12:15] = opcode
        # ROM
        if tokens[0][0] in jump_instructions:
            instruction[:9] = gen_imediato_rom(10, tokens[1], labels_dict)
        # IMEDIATO
        elif tokens[1][0] == "$":
            imed = gen_imediato_valor(8, tokens[1][1])
            instruction[:7] = imed
        # RAM
        else:
            instruction[:11] = gen_imediato_rom(11, tokens[1], labels_dict)

        encoded_instructions.append(instruction)
    print(encoded_instructions)


if __name__ == "__main__":
    argparse = argparse.ArgumentParser()
    argparse.add_argument("input_file", type=str)
    args = argparse.parse_args()

    assembly_file_name = args.input_file

    with open(assembly_file_name, "r") as f:
        linhas = f.readlines()

    main(linhas)
