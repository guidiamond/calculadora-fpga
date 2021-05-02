import argparse
import re
from typing import List, Dict


class Formater:
    @staticmethod
    def gen_opcode_dict(n_bits: str, lista_opcodes: List[str]):
        opcode_dict = {}
        for idx, opc_name in enumerate(lista_opcodes):
            op_code_bits = f"{idx:04b}"
            opcode_dict[opc_name] = op_code_bits
        return opcode_dict

    @staticmethod
    def gen_imediato_ram(label_name, labels_dict: Dict[str, int]):
        posicao_mem = labels_dict[label_name]
        return f"{posicao_mem:012b}"

    @staticmethod
    def gen_imediato_valor(imediato_str: str):
        imediato_num = int(imediato_str)
        return f"{imediato_num:08b}"

    @staticmethod
    def gen_imediato_rom(label_name, labels_dict: Dict[str, int]):
        posicao_mem = labels_dict[label_name]
        return f"{posicao_mem:010b}"


class Assembler:
    opcodes_dict: Dict[str, int]
    raw_assembly_lines: List[str]
    fmt_assembly_lines: List[str]
    labels_dict: Dict[str, int]
    jump_instructions: List[str]

    def __init__(
        self, code: List[str], lista_opcodes: List[str], jump_instructions: List[str]
    ):
        self.raw_assembly_lines = code
        self.opcodes_dict = Formater.gen_opcode_dict(4, lista_opcodes)
        self.jump_instructions = jump_instructions

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
            linha = re.sub(",", "", linha)
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

    @staticmethod
    def gen_line_tokens(line: str):
        return line.split()

    def get_instruction_type(self, tokens: List[str]):
        if tokens[0][0] in self.jump_instructions:
            return "a"  # ROM (10b)
        elif tokens[1][0] == "$":
            return "b"  # IMEDIATO_VALOR (8b)
        else:
            return "c"  # RAM (12b)

    def parse_line(self, line: str):
        tokens = self.gen_line_tokens(line)  # ex: [MOV, $1]
        instruction = list(f"{0:016b}")  # ex: [0,0,0...] representing the bits
        opcode_name = tokens[0]  # ex: MOV

        opcode_bin = self.opcodes_dict[opcode_name]
        instruction[12:15] = opcode_bin

        inst_type = self.get_instruction_type(tokens)

        if inst_type == "a":
            imediato_rom_bin = Formater.gen_imediato_rom(tokens[1], self.labels_dict)
            instruction[:9] = imediato_rom_bin

        elif inst_type == "b":
            token_imediato_valor = tokens[1]
            imediato_valor = token_imediato_valor[
                1:
            ]  # ex: $1 (token_imediato) -> 1 (imediato_valor)
            imediato_bin = Formater.gen_imediato_valor(imediato_valor)
            instruction[0:7] = imediato_bin

        elif inst_type == "c":
            imediato_ram_bin = Formater.gen_imediato_ram(tokens[1], self.labels_dict)
            instruction[:11] = imediato_ram_bin

    def parse(self):
        self.pre_pro()
        for line in self.fmt_assembly_lines:
            self.parse_line(line)


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
    jump_instructions = ["JE", "JMP", "JL"]
    Assembler(raw_assembly, lista_opcodes, jump_instructions).parse()


if __name__ == "__main__":
    argparse = argparse.ArgumentParser()
    argparse.add_argument("input_file", type=str)
    args = argparse.parse_args()

    assembly_file_name = args.input_file

    with open(assembly_file_name, "r") as f:
        linhas = f.readlines()

    main(linhas)
