library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity unidadeControle is
  generic (
              OPCODE_WIDTH: natural := 4;
              PALAVRA_CONTROLE_WIDTH: natural := 10
  );
  port   (
    -- Input ports
    clk  :  in  std_logic;
    opCode  :  in  std_logic_vector(OPCODE_WIDTH-1 downto 0);
    -- Output ports
    palavraControle  :  out std_logic_vector(PALAVRA_CONTROLE_WIDTH-1 downto 0)
  );
end entity;


architecture arch_name of unidadeControle is
  signal pontosControle : std_logic_vector(PALAVRA_CONTROLE_WIDTH-1 downto 0);

  -- Output alias (mais facil de atribuir os valores)
  alias habJump : std_logic is pontosControle(0);
  alias habEscritaAcumulador : std_logic is pontosControle(1);
  alias selOperacaoULA : std_logic_vector(2 downto 0) is pontosControle(4 downto 2);
  alias muxImediatoRam : std_logic is pontosControle(5);
  alias habLeituraRam : std_logic is pontosControle(6);
  alias habEscritRam : std_logic is pontosControle(7);
  alias habJE : std_logic is pontosControle(8);

  -- INSTRUCTIONS
  constant STORE : std_logic_vector := "0000";
  constant LOAD  : std_logic_vector := "0001";
  constant CMP   : std_logic_vector := "0010";
  constant JE    : std_logic_vector := "0011";
  constant JMP   : std_logic_vector := "0100";
  constant INC   : std_logic_vector := "0101";
  constant JL    : std_logic_vector := "0110";
  constant ADD   : std_logic_vector := "0111";
  constant SUB   : std_logic_vector := "1000";

  begin
    habJump <= '1' when opCode = JMP;
    muxImediatoRam <= '1' when opCode = CMP or opCode = INC or opCode = ADD or opCode = SUB else '0';

    habEscritaAcumulador <= '1' when opCode = LOAD or opCode = INC or opCode = ADD or opCode = SUB;

    selOperacaoULA <= "000" when opCode = ADD or opCode=INC else
                   "001" when opCode = SUB or opCode= CMP else
                   "010" when opCode = STORE else
                   "011" when opCode = LOAD else
                   "100" when opCode = JE else
                   "000";

    habLeituraRam <= '1' when opCode = LOAD else '0';
    habEscritRam  <= '1' when opCode = STORE else '0';

    -- Assign resultado final para output
    palavraControle <= pontosControle;

end architecture;
